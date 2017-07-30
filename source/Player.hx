package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class Player extends FlxSprite
{
	// Sprint + stamina
	public var _currentStamina						: Float;
	public var _isSprinting							: Bool = false;
	public var _canSprint							: Bool = true;
	public var _isAbleToMove						: Bool = true;
	
	// Bullying
	public var _canBully							: Bool = true;
	public var _currentBullyCooldown 				: Float;
	
	// Polishing
	public var _stepSound							: FlxSound;
	
	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);

		loadGraphic(AssetPaths.player__png, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, false, false);
		setFacingFlip(FlxObject.RIGHT, true, false);

		animation.add("lr", [3, 4, 3, 5], 6, false);
		animation.add("u", [6, 7, 6, 8], 6, false);
		animation.add("d", [0, 1, 0, 2], 6, false);

		drag.x = drag.y = 1600;

		setSize(8, 6);
		offset.set(4, 10);
		
		_currentStamina = Tweaking.playerMaxStamina;
		
		_currentBullyCooldown = 0;
		
		FlxG.watch.add(this, "_currentStamina");
		FlxG.watch.add(this, "_isSprinting");
	}

	override public function update(elapsed:Float):Void
	{
		// Gestion du mouvement
		movement();
		
		// Gestion de la jauge de stamina (sprint)
		if (_isSprinting) {
			_currentStamina -= elapsed * Tweaking.playerStaminaSprintConsumptionPerSecond;
		} else {
			_currentStamina += elapsed * Tweaking.playerStaminaRecoveryPerSecond;
			if (_currentStamina > Tweaking.playerMaxStamina){
				_currentStamina = Tweaking.playerMaxStamina;
			}
		}
		
		// A bout de souffle, peut plus sprinter
		if (_currentStamina <= 0 && _canSprint) {
			_canSprint = false;
			new FlxTimer().start(Tweaking.playerDelayAfterEmptyStamina, StaminaRecoveryFinished);
		}
		
		// Update du cooldown du bullying
		if (_currentBullyCooldown > 0) {
			_currentBullyCooldown -= elapsed;
		}
		
		super.update(elapsed);
	}
	
	private function StaminaRecoveryFinished(Timer:FlxTimer):Void {
		_canSprint = true;
		_currentStamina = Tweaking.playerMaxStamina;
	}
	
	public function getBullied():Void
	{
		_isAbleToMove = false;
		FlxG.camera.shake(0.02); //TWEAKAGE POSSIBLE
		new FlxTimer().start(Tweaking.playerKnockDownDuration, PlayerWakeUpAfterBullied);
	}
	
	public function getBulliedByDogpunk():Void
	{
		_isAbleToMove = false;
		FlxG.camera.shake(0.02); //TWEAKAGE POSSIBLE
		Battery.instance._batteryLevel -= 5;
		new FlxTimer().start(Tweaking.playerKnockDownDuration, PlayerWakeUpAfterBullied);
	}
	
	private function PlayerWakeUpAfterBullied(Timer:FlxTimer):Void
	{
		_isAbleToMove = true;
	}
	
	/**
	 * Gestion des mouvements et sprint
	 */
	private function movement():Void
	{
		var _up:Bool = false;
		var _down:Bool = false;
		var _left:Bool = false;
		var _right:Bool = false;
		
		if (_isAbleToMove)
		{
			_up = FlxG.keys.anyPressed([UP, Z]);
			_down = FlxG.keys.anyPressed([DOWN, S]);
			_left = FlxG.keys.anyPressed([LEFT, Q]);
			_right = FlxG.keys.anyPressed([RIGHT, D]);
		}
				
		_isSprinting = FlxG.keys.pressed.SPACE && _canSprint;

		if (_up && _down)
		{
			_up = _down = false;
		}

		if (_left && _right)
		{
			_left = _right = false;
		}

		if (_up || _down || _left || _right)
		{
			var _ma:Float = 0;

			if (_up)
			{
				_ma = -90;
				if (_left) {
					_ma -= 45;
				}
				else if (_right) {
					_ma += 45;
				}

				facing = FlxObject.UP;
			}
			else if (_down)
			{
				_ma = 90;
				if (_left) {
					_ma += 45;
				}
				else if (_right) {
					_ma -= 45;
				}

				facing = FlxObject.DOWN;
			}
			else if (_left)
			{
				_ma = 180;
				facing = FlxObject.LEFT;
			}
			else if (_right)
			{
				_ma = 0;
				facing = FlxObject.RIGHT;
			}

			velocity.set((_isSprinting ? Tweaking.playerWalkingSpeed * Tweaking.playerSprintMultiplier : Tweaking.playerWalkingSpeed), 0);
			velocity.rotate(FlxPoint.weak(0, 0), _ma);

			if ((velocity.x != 0 || velocity.y != 0) && touching == FlxObject.NONE)
			{
				switch (facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT:
						animation.play("lr");
					case FlxObject.UP:
						animation.play("u");
					case FlxObject.DOWN:
						animation.play("d");
				}
			}
		}
	}
}
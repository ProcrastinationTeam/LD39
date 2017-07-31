package;

import flash.geom.Point;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;
import flixel.util.FlxTimer;
import flixel.util.FlxTimer.FlxTimerManager;
import flixel.system.FlxSound;

class DogPunk extends FlxSprite 
{

	public var etype(default, null)							: Int;
	public var id 											: Int;

	// IA variables
	private var _brain										: FSM;
	private var _idleTmr									: Float;
	private var _moveDir									: Float;
	public var _seesPlayer									: Bool = false;
	public var _playerPosition(default, null)				: FlxPoint;
	public var _playerInstance 								: Player;

	public var _isInRangeForHack 			 				: Bool = false;
	public var _life 										: Int = 2;
	public var _isOffensive 								: Bool = true;
	public var _isAbleToMove								: Bool = true;
	public var _isCurrentlyHacking							: Bool = false;
	
	public var _canBully									: Bool = true;
	
	public var _initialPos									: FlxPoint;
	public var _initialPos2									: FlxPoint;
	//public var _actualSpriteName 							: String;
	//public var _hackerSpriteName 							: String = "assets/images/enemy-2.png";
	
	public var _heyYouSound									: FlxSound;

	//DEBUG LOG
	public var distance 									: Int;

	public function new(X:Float=0, Y:Float=0,Id : Int, player: Player)
	{
		super(X, Y);
		id = Id;
		_playerInstance = player; 
		

		loadGraphic(Tweaking.dogpunkSprite, true, 16, 16);
		animation.add("idle", [0], 6, false);
		animation.add("run", [0,1,2], 6, false);
		
		setFacingFlip(FlxObject.RIGHT, false, false);
		setFacingFlip(FlxObject.LEFT, true, false);

		drag.x = drag.y = 10;

		setSize(6, 4);
		offset.set(5, 12);
		
		//IA SECTION
		_brain = new FSM(idle);
		_idleTmr = 0;
		_playerPosition = FlxPoint.get();
		trace("POS PLAYER : " + FlxPoint.get());

		//DEBUG SECTION
		FlxG.watch.add(this, "_initialPos", "DOG :");
		FlxG.watch.add(this, "_initialPos2", "DOG 2 :");
		
		_initialPos2 = this.getScreenPosition();
		_initialPos = new FlxPoint(X, Y);
		
		_heyYouSound = FlxG.sound.load(AssetPaths.hey_you__wav);

	}

	override public function draw():Void
	{
		if ((velocity.x != 0 || velocity.y != 0 ) && touching == FlxObject.NONE)
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = FlxObject.LEFT;
				else
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = FlxObject.UP;
				else
					facing = FlxObject.DOWN;
			}

			//PAS D'ANIMATION ACTUELLEMENT
			switch (facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT, FlxObject.UP, FlxObject.DOWN:
						{
							animation.play("run");
						}
				}
		}
		super.draw();
	}

	//Fonction d'action du Hacker
	public function hackPlayer():Void
	{

		//SI REVELER ONLY

	}

	public function getCounterHack():Void
	{
		//TODO SI ON A DU TEMPS
	}

	/*public function getBullied(player:Player):Void
	{
		_isAbleToMove = false;
		new FlxTimer().start(Tweaking.hackerKnockDownDuration, HackerWakeUpAfterBullied);

		if (_actualSpriteName != _hackerSpriteName)
		{
			_actualSpriteName = _hackerSpriteName;
			loadGraphic(_actualSpriteName, true, 16, 16);
			animation.add("hack", [0, 1, 0], 6, true);
			animation.add("idle", [0], 6, false);
		}

		if (_life > 0)
		{
			this._life--;

		}

		if (_life == 0)
		{
			animation.finish();
			_brain.activeState = idle;

			if (_isInRangeForHack)
			{
				_isInRangeForHack = false;
				Battery.instance._numberOfHackersHacking--;
			}
			_life = -1;
			_isOffensive  = false;
		}

		var vector:FlxVector = new FlxVector(this.x - player.x, this.y - player.y);
		vector.normalize();
		var vectorPoint:FlxPoint = new FlxPoint(vector.x * Tweaking.playerBullyForce, vector.y * Tweaking.playerBullyForce);
		velocity.addPoint(vectorPoint);

	}*/

	private function DogpunkBullyingRecover(Timer:FlxTimer):Void
	{
		_canBully = true;
		_seesPlayer = false;
	//	_brain.activeState = idle;
		
	}
	
	private function DogpunkOnTheRoad(Timer:FlxTimer):Void
	{
		_brain.activeState = goBackHome;
	}

	public function idle():Void
	{
		//animation.play("idle");

		if (_seesPlayer && _isOffensive)
		{
			if (_brain.activeState != chase) {
				_heyYouSound.play();
			}
			_brain.activeState = chase;
		}
		/*else if (_idleTmr <= 0)
		{
			if (FlxG.random.bool(1))
			{
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			}
			else
			{
				_moveDir = FlxG.random.int(0, 8) * 45;

				velocity.set(Tweaking.hackerSpeed * 0.5, 0);
				velocity.rotate(FlxPoint.weak(), _moveDir);
			}
			_idleTmr = FlxG.random.int(1, 4);
		}
		else
			_idleTmr -= FlxG.elapsed;*/

	}

	public function chase():Void
	{
		if (!_seesPlayer)
		{
			//Modification du Idle probable
			_brain.activeState = idle;
			//Retourne a sa position de base
		}
		else
		{
			trace("I SEE U");
			FlxVelocity.moveTowardsPoint(this, _playerPosition, Std.int(Tweaking.hackerSpeed)); 
			if (distance < Tweaking.dogpunkDistanceToHit && _canBully)
			{
				_playerInstance.getBulliedByDogpunk();
				_isOffensive = false;
				_canBully = false;
				
				new FlxTimer().start(1, DogpunkOnTheRoad);
				new FlxTimer().start(Tweaking.dogpunkCooldownBully, DogpunkBullyingRecover);
			}
		}

	}
	
	public function goBackHome():Void
	{
		
		var o : FlxPoint = new	FlxPoint(130, 100);
		FlxVelocity.moveTowardsPoint(this, _initialPos , Std.int(Tweaking.hackerSpeed));
		_brain.activeState = idle;
		
	}
	

	override public function update(elapsed:Float):Void
	{
		if (_isAbleToMove)
		{
			_brain.update();
		}
		super.update(elapsed);
	}
	
}
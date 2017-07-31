package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

class Hacker extends FlxSprite
{
	public var etype(default, null)							: Int;
	public var id 											: Int;

	// IA variables
	private var _brain										: FSM;
	private var _idleTmr									: Float;
	private var _moveDir									: Float;
	public var _seesPlayer									: Bool = false;
	public var _playerPosition(default, null)				: FlxPoint;
	

	public var _isInRangeForHack 							: Bool = false;
	public var _life 										: Int = 2;
	public var _isOffensive 								: Bool = true;
	public var _isAbleToMove								: Bool = true;
	public var _isCurrentlyHacking							: Bool = false;

	public var _actualSpriteName 							: String;
	public var _hackerSpriteName 							: String = Tweaking.hackerSprite;

	//DEBUG LOG
	public var distance 									: Int;
	
	public var _pnjTabasseSound								: FlxSound;

	
	public function new(X:Float=0, Y:Float=0, EType:Int, Id : Int)
	{
		super(X, Y);
		id = Id;
		etype = EType;
		
		
		//LOADING SPRITE RANDOM
		_actualSpriteName = Tweaking.npcSpritePrefix +  FlxG.random.int(1, 5) + ".png";
		loadGraphic(_actualSpriteName, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		animation.add("idle", [0], 6, false);
		animation.add("walk", [0,1,2,1], 6, true);
	

		drag.x = drag.y = 10;

		setSize(6, 4);
		offset.set(5, 12);
		
		//IA SECTION
		_brain = new FSM(idle);
		_idleTmr = 0;
		_playerPosition = FlxPoint.get();

		//DEBUG SECTION
		//	FlxG.watch.add(this, "_life", "Player " + this.id + " :");
		
		_pnjTabasseSound = FlxG.sound.load(AssetPaths.pnj_tabasse__wav);
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
							animation.play("walk");
						}
				}
		}
		else
		{
			animation.play("idle");
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

	public function getBullied(player:Player):Void
	{
		_isAbleToMove = false;
		_pnjTabasseSound.play();
		new FlxTimer().start(Tweaking.hackerKnockDownDuration, HackerWakeUpAfterBullied);

		if (_actualSpriteName != _hackerSpriteName)
		{
			_actualSpriteName = _hackerSpriteName;
			loadGraphic(_actualSpriteName, true, 16, 16);
			animation.add("walk", [0,1,2,1], 6, true);
			//animation.add("hack", [0, 1, 0], 6, true);
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

	}

	private function HackerWakeUpAfterBullied(Timer:FlxTimer):Void
	{
		_isAbleToMove = true;
	}

	public function idle():Void
	{
		

		if (_seesPlayer && _isOffensive)
		{
			_brain.activeState = chase;
		}
		else if (_idleTmr <= 0)
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
			_idleTmr -= FlxG.elapsed;

	}

	public function chase():Void
	{
		if (!_seesPlayer)
		{
			//Modification du Idle probable
			_brain.activeState = idle;

			if (_isInRangeForHack)
			{
				Battery.instance._numberOfHackersHacking--;
				_isCurrentlyHacking = false;
				_isInRangeForHack = false;
			}
		}
		else
		{
			//SI EN RANGE DE HACK
			if (distance < Tweaking.hackerMaxDistanceToHack)
			{
				if (distance < Tweaking.hackerBestDistanceToHack && !_isCurrentlyHacking)
				{
					// entre distance min et max
					//trace("FOLLOW");
					FlxVelocity.moveTowardsPoint(this, _playerPosition, Std.int(Tweaking.hackerSpeed * 0.5)); // hacker speed reduite
				}

				if (distance < Tweaking.hackerMinDistanceToHack)
				{
					// sous distance min
					//trace("IDLE");
					this.velocity = new FlxPoint(0, 0);
				}

				if (!_isInRangeForHack && !_isCurrentlyHacking)
				{
					Battery.instance._numberOfHackersHacking++;
					_isCurrentlyHacking = true;

					//Animation gestion
					if (_actualSpriteName == _hackerSpriteName)
					{
						//animation.play("hack");
					}
					_isInRangeForHack = true;
				}
			}
			else 	//SI PAS EN RANGE DE HACK
			{
				FlxVelocity.moveTowardsPoint(this, _playerPosition, Std.int(Tweaking.hackerSpeed)); // fullspeed
				//Fonction de Hack lancé quand le hacker est en range (idée de rajouter une connexion de x secondes)
				if (_isInRangeForHack)
				{
					Battery.instance._numberOfHackersHacking--;
					_isCurrentlyHacking = false;
					_isInRangeForHack = false;
				}

			}
		}

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
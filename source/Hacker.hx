package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.math.FlxVelocity;

class Hacker extends FlxSprite
{
	public var etype(default, null):Int;
	public var id : Int;

	// IA variables
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	public var _seesPlayer:Bool = false;
	public var _playerPosition(default, null):FlxPoint;

	public var _isInRangeForHack : Bool = false;
	public var _life : Int;
	public var _isOffensive : Bool;

	public var _actualSpriteName : String;
	public var _hackerSpriteName : String = "assets/images/enemy-1.png";
	
	//DEBUG LOG
	public var distance : Int;
	
	public function new(X:Float=0, Y:Float=0, EType:Int, Id : Int)
	{
		super(X, Y);
		id = Id;
		etype = EType;
		_isOffensive = true;

		//LOADING SPRITE RANDOM
		_actualSpriteName = "assets/images/pnj-" + FlxG.random.int(0, 3) +".png";
		loadGraphic(_actualSpriteName, true, 16, 16);
		animation.add("idle", [0], 6, false);
		
		//setFacingFlip(FlxObject.LEFT, false, false);
		//setFacingFlip(FlxObject.RIGHT, true, false);
		
		drag.x = drag.y = 10;
		width = 8;
		height = 14;
		offset.x = 4;
		offset.y = 2;

		//IA SECTION
		_brain = new FSM(idle);
		_idleTmr = 0;
		_playerPosition = FlxPoint.get();

		//TWEAK VALUE
		_life = 2;
		
		//DEBUG SECTION
		FlxG.watch.add(this, "_life", "Player " + this.id + " :");
		FlxG.watch.add(this, "graphic.key", "name asset :" );
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
			//switch (facing)
			//{
			//case FlxObject.LEFT, FlxObject.RIGHT:
			//// animation.play("lr");
//
			//case FlxObject.UP:
			//animation.play("u");
//
			//case FlxObject.DOWN:
			//animation.play("d");
			//}
		}
		super.draw();
	}

	//Fonction d'action du Hacker
	public function hackPlayer():Void
	{
		//SI REVELER ONLY
		if (_actualSpriteName == _hackerSpriteName)
		{
			animation.play("hack");
		}
	}

	public function getCounterHack():Void
	{
		//TODO SI ON A DU TEMPS
	}

	public function getBullied(player:Player):Void
	{
		if (_actualSpriteName != _hackerSpriteName)
		{
			loadGraphic(_hackerSpriteName, true, 16, 16);
			animation.add("hack", [0, 1, 0], 6, true);
			animation.add("idle", [0], 6, false);
		}
		
		if (_life > 0)
		{
			this._life--;
		}
		
		if (_life == 0)
		{
			_brain.activeState = idle;
			if (_isInRangeForHack) {
				_isInRangeForHack = false;
				Battery.instance._numberOfHackersHacking--;
			}
			_life = -1;
			_isOffensive  = false;
		}
		
		var vector:FlxVector = new FlxVector(this.x - player.x, this.y - player.y);
		vector.normalize();
		var vectorPoint:FlxPoint = new FlxPoint(vector.x * player._bullyForce, vector.y * player._bullyForce);
		velocity.addPoint(vectorPoint);
	
		
	}

	public function idle():Void
	{
		animation.play("idle");
		
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
		}
		else
		{
			//VALUE TO TWEAK
			if (distance > Tweaking.hackerDistanceToHack)
			{
				FlxVelocity.moveTowardsPoint(this, _playerPosition, Std.int(Tweaking.hackerSpeed));
				if (_isInRangeForHack)
				{
					Battery.instance._numberOfHackersHacking--;
				}
				_isInRangeForHack = false;

				//Bourrinage animation
				animation.finish();
			}
			else
			{
				this.velocity = new FlxPoint(0, 0);
				//Fonction de Hack lancé quand le hacker est en range (idée de rajouter une connexion de x secondes)

				if (!_isInRangeForHack)
				{
					hackPlayer();
					Battery.instance._numberOfHackersHacking++;
				}
				_isInRangeForHack = true;
			}

		}
	}

	override public function update(elapsed:Float):Void
	{
		_brain.update();
		super.update(elapsed);
	}
}
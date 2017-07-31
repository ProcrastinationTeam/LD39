package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVector;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

class PNJ extends FlxSprite 
{
	public var id : Int;

	//IA variables
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;
	
	public var _actualSpriteName 							: String;
	
	public var _pnjTabasseSound								: FlxSound;

	public function new(X:Float=0, Y:Float=0, Id : Int)
	{
		super(X, Y);
		id = Id;

		//remplacer le EType par un random
		_actualSpriteName = Tweaking.npcSpritePrefix +  FlxG.random.int(1, 5) + ".png";
		loadGraphic(_actualSpriteName, true, 16, 16);
		setFacingFlip(FlxObject.LEFT, true, false);
		setFacingFlip(FlxObject.RIGHT, false, false);
		
		animation.add("idle", [0], 6, true);
		animation.add("walk", [0,1,2,1], 6, true);
		
		drag.x = drag.y = 10;
		setSize(6, 4);
		offset.set(5, 12);
		
		//IA SECTION
		_brain = new FSM(idle);
		_idleTmr = 0;

		//DEBUG SECTION
		//FlxG.watch.add(this, "_life", "Player " + this.id + " :");
		_pnjTabasseSound = FlxG.sound.load(AssetPaths.pnj_tabasse__wav);
	}
	
	override public function draw():Void
	{
		if ((velocity.x != 0 || velocity.y != 0 ) && touching == FlxObject.NONE)
		{
			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0) {
					facing = FlxObject.LEFT;
				}
				else {
					facing = FlxObject.RIGHT;
				}
			}
			else
			{
				if (velocity.y < 0) {
					facing = FlxObject.UP;
				}
				else {
					facing = FlxObject.DOWN;
				}
			}

			//PAS D'ANIMATION ACTUELLEMENT
			/*switch (facing)
				{
					case FlxObject.LEFT, FlxObject.RIGHT, FlxObject.UP, FlxObject.DOWN:
						{
							animation.play("walk");
						}
				}*/
				animation.play("walk");
		}
		else
		{
			animation.play("idle");
		}
		super.draw();
	}
	
	
	public function idle():Void
	{
		//animation.play("idle");
		
		if (_idleTmr <= 0)
		{
			if (FlxG.random.bool(1))
			{
				_moveDir = -1;
				velocity.x = velocity.y = 0;
			}
			else
			{
				_moveDir = FlxG.random.int(0, 8) * 45;

				velocity.set(Tweaking.npcSpeed * 0.5, 0);
				velocity.rotate(FlxPoint.weak(), _moveDir);
			}
			_idleTmr = FlxG.random.int(1, 4);
		}
		else {
			_idleTmr -= FlxG.elapsed;
		}
	}

	override public function update(elapsed:Float):Void
	{
		_brain.update();
		super.update(elapsed);
	}
	
	public function getBullied(player:Player):Void
	{
		var vector:FlxVector = new FlxVector(this.x - player.x, this.y - player.y);
		vector.normalize();
		var vectorPoint:FlxPoint = new FlxPoint(vector.x * Tweaking.playerBullyForce, vector.y * Tweaking.playerBullyForce);
		velocity.addPoint(vectorPoint);
		_pnjTabasseSound.play(true);
		
		var randomizer = FlxG.random.float(0, 1);
		if (randomizer < Tweaking.npcChanceToHitBack)
		{	
			_pnjTabasseSound.play(true);
			new FlxTimer().start(0.2, function(timer:FlxTimer) {
				_pnjTabasseSound.play(true);
			});
			player.getBullied();
		}
		
	}
	
	
}
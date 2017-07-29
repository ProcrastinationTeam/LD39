package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

class PNJ extends FlxSprite 
{
	public var speed:Float = 140;
	public var id : Int;

	//IA variables
	private var _brain:FSM;
	private var _idleTmr:Float;
	private var _moveDir:Float;

	public function new(X:Float=0, Y:Float=0, Id : Int)
	{
		super(X, Y);
		id = Id;

		//remplacer le EType par un random
		loadGraphic("assets/images/pnj-1.png", true, 16, 16);

		//setFacingFlip(FlxObject.LEFT, false, false);
		//setFacingFlip(FlxObject.RIGHT, true, false);
		//animation.add("hack", [0, 1, 0], 6, true);
		animation.add("idle", [0], 6, false);
		drag.x = drag.y = 10;
		width = 4;
		height = 4;
		offset.x = 6;
		offset.y = 12;

		//IA SECTION
		_brain = new FSM(idle);
		_idleTmr = 0;

		//DEBUG SECTION
		//FlxG.watch.add(this, "_life", "Player " + this.id + " :");
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
	
	
	public function idle():Void
	{
		animation.play("idle");
		
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

				velocity.set(speed * 0.5, 0);
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
}
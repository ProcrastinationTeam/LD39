package;

import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author ElRyoGrande
 */
class PowerUp extends FlxSprite
{

	public function new(?X:Float=0, ?Y:Float=0)
	{
		super(X, Y);
		loadGraphic("assets/images/batery.png", true, 16, 16);
		scale = new FlxPoint(0.5, 0.5);
		setSize(4, 6);
		offset.set(6, 5);
	}

	//TO DO RAMASSER
	override public function kill():Void
	{
		addBattery();
		alive = false;
		FlxTween.tween(this, { alpha: 0, y: y - 16 }, .33, { ease: FlxEase.circOut, onComplete: finishKill });
		
	}

	private function finishKill(_):Void
	{
		exists = false;
	}

	private function addBattery():Void
	{
		Battery.instance._batteryLevel += Tweaking.batteryToAdd;
	}
	
}
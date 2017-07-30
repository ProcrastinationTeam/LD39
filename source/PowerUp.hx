package;


import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;

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
		scale = new FlxPoint(0.5,0.5);
	}
	
	
	//TO DO RAMASSER
}
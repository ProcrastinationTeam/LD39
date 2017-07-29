package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Battery extends FlxSprite
{
	public var _batteryValue:Float;
	public var _batteryDecreaseRatePerSecond:Float;

	// Si on est entrain de parler avec maman, ça pompe la batterie
	public var _isCallingMom:Bool = false;
	public var _batteryDecreaseRatePerSecondThroughCall:Float = 0.5;

	public function new(InitialBatteryValue:Float, BatteryDecreaseRatePerSecond:Float)
	{
		super();

		loadGraphic(AssetPaths.player__png, true, 16, 16);

		_batteryValue = InitialBatteryValue;
		_batteryDecreaseRatePerSecond = BatteryDecreaseRatePerSecond;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//

		if (_isCallingMom)
		{
			_batteryValue -= _batteryDecreaseRatePerSecond * elapsed;
		}
	}

	// Quand on se fait pomper de la batterie de façon ponctuelle, ça screenshake un coup
	public function punctualDecreaseBattery(value:Float):Void
	{
		_batteryValue -= value;
		FlxG.camera.shake(0.005, 0.2);
	}

	// Mettre à jour le sprite de la batterie
	public function updateBatterySprite():Void
	{

	}
}
package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Battery extends FlxSprite
{
	public var _batteryLevel:Float;
	public var _batteryDecreaseRatePerSecond:Float;

	// Si on est entrain de parler avec maman, ça pompe la batterie
	public var _isInCallWithMom:Bool = false;
	public var _batteryDecreaseRatePerSecondThroughCall:Float = 0.5;

	public function new(InitialBatteryValue:Float, BatteryDecreaseRatePerSecond:Float)
	{
		super();

		loadGraphic(AssetPaths.player__png, true, 16, 16);

		_batteryLevel = InitialBatteryValue;
		_batteryDecreaseRatePerSecond = BatteryDecreaseRatePerSecond;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//

		_batteryLevel -= _batteryDecreaseRatePerSecond * elapsed;
		
		if (_isInCallWithMom)
		{
			_batteryLevel -= _batteryDecreaseRatePerSecondThroughCall * elapsed;
		}
	}

	// Quand on se fait pomper de la batterie de façon ponctuelle, ça screenshake un coup
	public function punctualDecreaseBattery(value:Float):Void
	{
		_batteryLevel -= value;
		FlxG.cameras.list[1].shake(0.005, 0.2);
	}
}
package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;

class Battery extends FlxSprite
{
	public var _batteryLevel							: Float;
	public var _batteryDecreaseRatePerSecond			: Float;

	// Si on est entrain de parler avec maman, ça pompe la batterie
	public var _isInCallWithMom							: Bool = false;
	public var _batteryDecreaseRatePerSecondThroughCall	: Float = 0.5;
	
	// Pompage de batterie / hacker / seconde
	private var _numberOfHackersHacking 					: Int = 0;
	private var _batteryDecreaseRatePerSecondPerHacker		: Float = 0.2;

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

		// La batterie diminue toute seule par défaut
		_batteryLevel -= _batteryDecreaseRatePerSecond * elapsed;
		
		// Si on est en call avec maman, la batterie descend
		if (_isInCallWithMom)
		{
			_batteryLevel -= _batteryDecreaseRatePerSecondThroughCall * elapsed;
		}
		
		// Si on se fait hack, la batterie se fait voler
		_batteryLevel -= _numberOfHackersHacking * _batteryDecreaseRatePerSecondPerHacker * elapsed;
	}

	// Quand on se fait pomper de la batterie de façon ponctuelle, ça screenshake un coup
	public function punctualDecreaseBattery(value:Float):Void
	{
		_batteryLevel -= value;
		FlxG.cameras.list[1].shake(0.005, 0.2);
	}
}
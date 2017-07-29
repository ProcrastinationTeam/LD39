package;

import flixel.FlxG;
import flixel.FlxSprite;

class Battery extends FlxSprite
{
	public static var instance(default, null): Battery = new Battery();
	
	public var _batteryLevel								: Float = 50;
	public var _batteryDecreaseRatePerSecond				: Float = 0.25;

	// Si on est entrain de parler avec maman, ça pompe la batterie
	public var _batteryDecreaseRatePerSecondThroughCall		: Float = 0.5;
	
	// Pompage de batterie / hacker / seconde
	public var _numberOfHackersHacking 						: Int = 0;
	private var _batteryDecreaseRatePerSecondPerHacker		: Float = 0.7;

	// Constructeur privé pour singletoniser
	private function new()
	{
		super();
	}
	
	// "Constructeur" (pour init les valeurs de la batterie), à appeller pour relancer une partie
	public function initBattery(InitialBatteryValue:Float, BatteryDecreaseRatePerSecond:Float):Void
	{
		_batteryDecreaseRatePerSecond = BatteryDecreaseRatePerSecond;
		_batteryLevel = InitialBatteryValue;
		_numberOfHackersHacking = 0;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		//

		// La batterie diminue toute seule par défaut
		_batteryLevel -= _batteryDecreaseRatePerSecond * elapsed;
		
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
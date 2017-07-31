package;

import flixel.FlxG;
import flixel.FlxSprite;

class Battery extends FlxSprite
{
	public static var instance(default, null): Battery;
	
	public var _batteryLevel								: Float;
	public var _numberOfHackersHacking 						: Int;

	// Constructeur privé pour singletoniser
	public function new(batteryLevel:Float )
	{
		super();
		instance = this;
		_batteryLevel = batteryLevel;
		_numberOfHackersHacking = 0;
	}
	
	// "Constructeur" (pour init les valeurs de la batterie), à appeller pour relancer une partie
	//public function initBattery(InitialBatteryValue:Float):Void
	//{
		//_batteryLevel = InitialBatteryValue;
		//_numberOfHackersHacking = 0;
	//}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		// La batterie diminue toute seule par défaut
		_batteryLevel -= Tweaking.batteryDecreaseRatePerSecond * elapsed * (_batteryLevel < Tweaking.batteryLowBatteryThreshold ? Tweaking.batteryLowBatterySaverMultiplier : 1);
		
		// Si on se fait hack, la batterie se fait voler
		_batteryLevel -= _numberOfHackersHacking * Tweaking.batteryDecreaseRatePerSecondPerHacker * elapsed;
	}

	// Quand on se fait pomper de la batterie de façon ponctuelle, ça screenshake un coup
	public function punctualDecreaseBattery(value:Float):Void
	{
		_batteryLevel -= value;
		FlxG.cameras.list[1].shake(0.005, 0.2);
	}
}
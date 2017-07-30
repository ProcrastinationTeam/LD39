package;

class Tweaking 
{
	// HACKER
	public static inline var hackerVisionDistance 						: Float = 75;
	public static inline var hackerDistanceToHack 						: Float = 50;
	public static inline var hackerSpeed								: Float = 140;
	
	// BATTERY
	public static inline var batteryDecreaseRatePerSecond				: Float = 0.25;
	public static inline var batteryLowBatteryThreshold					: Float = 10;
	public static inline var batteryLowBatterySaverMultiplier 			: Float = 0.3;
	public static inline var batteryDecreaseRatePerSecondThroughCall	: Float = 0.5;
	public static inline var batteryDecreaseRatePerSecondPerHacker		: Float = 0.7;
	
	// PLAYER
	// Sprint + stamina
	public static inline var playerWalkingSpeed							: Float = 150;
	public static inline var playerSprintMultiplier						: Float = 1.5;
	public static inline var playerMaxStamina							: Float = 2;
	public static inline var playerStaminaRecoveryPerSecond				: Float = 1;
	public static inline var playerStaminaSprintConsumptionPerSecond	: Float = 1;
	public static inline var playerDelayAfterEmptyStamina 				: Float = playerStaminaRecoveryPerSecond * playerMaxStamina;
	
	// Bullying
	public static inline var playerMinDistanceToBully 					: Int = 20;
	public static inline var playerBullyingCost							: Float = 0.5;
	public static inline var playerBullyingDelay						: Float = 0.5;
	public static inline var playerBullyForce							: Float = 300;
	
	// PNJ
	public static inline var npcSpeed									: Float = 140;
	
	// Call avec maman
	public static inline var momCallDuration							: Float = 3;
	public static inline var momCallDelayBetweenTwoCalls				: Float = 4;
	public static inline var momCallDelayBetweenScreenShakes			: Float = 0.5;
}
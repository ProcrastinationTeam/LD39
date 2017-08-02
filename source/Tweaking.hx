package;

class Tweaking 
{
	// HACKER
	public static inline var hackerVisionDistance 						: Float = 75;
	public static inline var hackerMaxDistanceToHack 					: Float = 50;
	public static inline var hackerMinDistanceToHack					: Float = 20;
	public static inline var hackerBestDistanceToHack					: Float = 35;
	public static inline var hackerSpeed								: Float = 80;
	
	// Interaction avec temps
	public static inline var hackerHitPoints							: Int = 1;
	public static inline var hackerKnockDownDuration					: Float = 2; // en secondes
	
	// DOGPUNK
	public static inline var dogpunkVisionDistance 						: Float = 100;
	public static inline var dogpunkDistanceToHit						: Float = 10; 
	public static inline var dogpunkCooldownBully						: Float = 5;
	
	// BATTERY
	public static inline var batteryInitialLevel						: Float = 98;
	public static inline var batteryDecreaseRatePerSecond				: Float = 0.4;
	public static inline var batteryLowBatteryThreshold					: Float = 10;
	public static inline var batteryLowBatterySaverMultiplier 			: Float = 0.5;
	public static inline var batteryDecreaseRatePerSecondThroughCall	: Float = 1;
	public static inline var batteryDecreaseRatePerSecondPerHacker		: Float = 0.7;
	
	public static inline var batteryToAdd								: Float = 10.0;
	
	// PLAYER
	// Sprint + stamina
	public static inline var playerWalkingSpeed							: Float = 75;
	public static inline var playerSprintMultiplier						: Float = 1.5;
	public static inline var playerMaxStamina							: Float = 2;
	public static inline var playerStaminaRecoveryPerSecond				: Float = 1;
	public static inline var playerStaminaSprintConsumptionPerSecond	: Float = 1;
	public static inline var playerDelayAfterEmptyStamina 				: Float = playerStaminaRecoveryPerSecond * playerMaxStamina;
	
	// Interaction avec temps
	public static inline var playerKnockDownDuration					: Float = 2; // en secondes;
	
	// Bullying
	public static inline var playerMinDistanceToBully 					: Int = 20;
	public static inline var playerBullyingCost							: Float = 0.5;
	public static inline var playerBullyingDelay						: Float = 0.5;
	public static inline var playerBullyForce							: Float = 100;
	
	// Messaging
	public static inline var playerMessagingMultiplier					: Float = 0.5;
	
	// PNJ
	public static inline var npcSpeed									: Float = 140;
	public static inline var npcChanceToHitBack							: Float = 0.05; // Entre 0 et 1
	
	// Call avec maman
	public static inline var momMessagesThreshold						: Int = 3;
	public static inline var momMessagesDelayBetweenTwoMessages			: Float = 1.5;
	public static inline var momMessageTimeToSend						: Float = 1;
	
	public static inline var momCallDuration							: Float = 3;
	public static inline var momCallDelayBetweenTwoCalls				: Float = 3;
	public static inline var momCallDelayBetweenScreenShakes			: Float = 0.5;
	
	public static inline var phoneOpeningTime							: Float = 0.3;
	
	// SPRITES SECTION
	public static inline var playerSprite								: String = "assets/images/MisterBelly.png";
	public static inline var hackerSprite								: String = "assets/images/MisterHacky.png";
	public static inline var dogpunkSprite								: String = "assets/images/MisterDougy.png";
	public static inline var npcSpritePrefix							: String = "assets/images/MisterEverybody-";
	
	// Punk à chien
	public static inline var dogPunkSpeed								: Float = 70;
	
	//public static inline var playerSprite								: String = "";
	//public static inline var playerSprite								: String = "";
	//public static inline var playerSprite								: String = "";
	//public static inline var playerSprite								: String = "";
}
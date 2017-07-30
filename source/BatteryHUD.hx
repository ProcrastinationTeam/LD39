package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class BatteryHUD extends FlxTypedGroup<FlxSprite>
{
	public var _width						: Int = 64;
	public var _height						: Int = 480; 
	
	// Rectangle de background
	public var _backgroundSprite			: FlxSprite;

	private var _staminaText				: FlxText;
	private var _staminaBar					: FlxBar;

	private var _bullyDelayText				: FlxText;
	private var _bullyDelayBar				: FlxBar;

	private var _batteryBar					: FlxBar;
	private var _batteryText 				: FlxText;
	
	// Référence au player (pas propre ? pratique en tout cas)
	private var _player 					: Player;
	private var _battery					: Battery;
	
	public function new(player:Player)
	{
		super();
		
		var x: Int = 10000;

		_backgroundSprite = new FlxSprite(x, 0).makeGraphic(_width, _height, FlxColor.BLACK);
		add(_backgroundSprite);

		_staminaText = new FlxText(x + 2, 0);
		_staminaText.height = 16;
		_staminaText.text = "STAMINA";
		add(_staminaText);

		_staminaBar = new FlxBar(x, 16, LEFT_TO_RIGHT, 64, 16);
		_staminaBar.createColoredEmptyBar(FlxColor.GREEN, true, FlxColor.WHITE);
		_staminaBar.setRange(0, Tweaking.playerMaxStamina);
		add(_staminaBar);

		_bullyDelayText = new FlxText(x + 2, 32);
		_bullyDelayText.height = 16;
		_bullyDelayText.text = "BULLY CD";
		add(_bullyDelayText);

		_bullyDelayBar = new FlxBar(x + 0, 48, LEFT_TO_RIGHT, 64, 16);
		_bullyDelayBar.createColoredFilledBar(FlxColor.RED, true, FlxColor.WHITE);
		_bullyDelayBar.setRange(0, Tweaking.playerBullyingDelay);
		add(_bullyDelayBar);

		// TODO: virer le vert dégueu du background
		_batteryBar = new FlxBar(x + 0, 64, BOTTOM_TO_TOP, 64, 418);
		_batteryBar.createGradientFilledBar([FlxColor.BLUE, FlxColor.PURPLE, FlxColor.RED], 16, 90, true, FlxColor.BLACK);
		add(_batteryBar);

		_batteryText = new FlxText(x + 8, 250);
		_batteryText.color = 0xFFFFFF;
		_batteryText.size = 18;
		_batteryText.setSize(64, 30);
		_batteryText.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		add(_batteryText);
		
		// CA CASSE TOUT
		//forEach(function(sprite:FlxSprite)
		//{
			//sprite.scrollFactor.set(0, 0);
		//});

		_player = player;
		_battery = Battery.instance;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		var batteryLevel:Int = Math.round(_battery._batteryLevel);
		_batteryBar.value = batteryLevel;
		_batteryText.text = batteryLevel + "%";
		
		if (_battery._batteryLevel < Tweaking.batteryLowBatteryThreshold) {
			// TODO: Afficher un hud de low batterie
		}

		_staminaBar.value = _player._currentStamina;

		_bullyDelayBar.value = Tweaking.playerBullyingDelay - _player._currentBullyCooldown;
	}
}
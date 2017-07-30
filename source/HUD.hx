package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	// Rectangle de background
	private var _backgroundSprite			: FlxSprite;

	private var _wifiIcon					: FlxSprite;
	private var _callingIcon				: FlxSprite;

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

		_backgroundSprite = new FlxSprite().makeGraphic(64, 64, FlxColor.BLACK);
		_backgroundSprite.x = 0;
		_backgroundSprite.y = 0;
		//_sprBack.drawRect(0, 0, FlxG.width, 50, FlxColor.WHITE);
		add(_backgroundSprite);

		_wifiIcon = new FlxSprite().loadGraphic(AssetPaths.wifi__png, true, 16, 16);
		_wifiIcon.x = 0;
		_wifiIcon.y = 0;
		_wifiIcon.visible = false;
		_wifiIcon.animation.add("hack", [0, 1, 2, 3], 3, true);
		add(_wifiIcon);

		_callingIcon = new FlxSprite().loadGraphic(AssetPaths.call_icon__png, true, 16, 16);
		_callingIcon.x = 16;
		_callingIcon.y = 0;
		_callingIcon.visible = false;
		_callingIcon.animation.add("call", [0, 1, 2, 3, 4], 3, true);
		add(_callingIcon);

		_staminaText = new FlxText(2, 16);
		_staminaText.height = 16;
		_staminaText.text = "STAMINA";
		add(_staminaText);

		_staminaBar = new FlxBar(0, 32, LEFT_TO_RIGHT, 64, 16);
		_staminaBar.createColoredFilledBar(FlxColor.GREEN, true, FlxColor.WHITE);
		// TODO: PRENDRE LES VALEURS DANS PLAYER
		_staminaBar.setRange(0, 2);
		add(_staminaBar);

		_bullyDelayText = new FlxText(2, 48);
		_bullyDelayText.height = 16;
		_bullyDelayText.text = "BULLY CD";
		add(_bullyDelayText);

		_bullyDelayBar = new FlxBar(0, 64, LEFT_TO_RIGHT, 64, 16);
		_bullyDelayBar.createColoredFilledBar(FlxColor.RED, true, FlxColor.WHITE);
		// TODO: PRENDRE LES VALEURS DANS PLAYER
		_bullyDelayBar.setRange(0, 0.5);
		add(_bullyDelayBar);

		_batteryBar = new FlxBar(0, 80, BOTTOM_TO_TOP, 64, 402);
		_batteryBar.createGradientFilledBar([FlxColor.BLUE, FlxColor.PURPLE, FlxColor.RED], 16, 90, true, FlxColor.BLACK);
		add(_batteryBar);

		_batteryText = new FlxText(8, 285);
		_batteryText.color = 0xFFFFFF;
		_batteryText.size = 18;
		_batteryText.setSize(64, 30);
		_batteryText.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		add(_batteryText);

		forEach(function(sprite:FlxSprite)
		{
			sprite.scrollFactor.set(0, 0);
		});

		_player = player;
		_battery = Battery.instance;

		FlxG.watch.add(_batteryBar, "height");
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		var batteryLevel:Int = Math.round(_battery._batteryLevel);
		_batteryBar.value = batteryLevel;
		_batteryText.text = batteryLevel + "%";

		if (_battery._numberOfHackersHacking > 0)
		{
			_wifiIcon.visible = true;
			_wifiIcon.animation.play("hack");
		}
		else
		{
			if (_wifiIcon.visible)
			{
				_wifiIcon.visible = false;
				_wifiIcon.animation.finish();
			}
		}
		
		if (_battery._batteryLevel < _battery._lowBatteryThreshold) {
			// TODO: Afficher un hud de low batterie
		}

		_staminaBar.value = _player._currentStamina;

		_bullyDelayBar.value = 0.5 - _player._currentBullyCooldown;
	}

	/**
	 * Indique que le call avec maman commence, faire clignoter l'icône
	 */
	public function startCall():Void
	{
		//_callingIcon.flicker(0, 0.5);
		_callingIcon.visible = true;
		_callingIcon.animation.play("call");
	}

	/**
	 * Indique que le call avec maman est fini, arrêter le clignotage
	 */
	public function endCall():Void
	{
		//_callingIcon.stopFlickering();
		_callingIcon.animation.finish();
		_callingIcon.visible = false;
	}
}
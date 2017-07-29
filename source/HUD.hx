package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import flixel.util.FlxAxes;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	private var _sprBack					: FlxSprite;
	
	private var _wifiIcon					: FlxSprite;
	private var _callingIcon				: FlxSprite;
	
	private var _staminaBarText				: FlxText;
	private var _staminaBar					: FlxBar;
	
	private var _pushDelayTarText			: FlxText;
	private var _pushDelayBar				: FlxBar;
	
	private var _batteryBar					: FlxBar;
	private var _batteryText 				: FlxText;

	public function new() {
		super();
		
		_sprBack = new FlxSprite().makeGraphic(64, 64, FlxColor.BLACK);
		_sprBack.x = 0;
		_sprBack.y = 0;
		//_sprBack.drawRect(0, 0, FlxG.width, 50, FlxColor.WHITE);
		add(_sprBack);
		
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
		add(_callingIcon);
		
		_staminaBarText = new FlxText(2, 16);
		_staminaBarText.height = 16;
		_staminaBarText.text = "STAMINA";
		add(_staminaBarText);
		
		_staminaBar = new FlxBar(0, 32, LEFT_TO_RIGHT, 64, 16);
		_staminaBar.createColoredFilledBar(FlxColor.GREEN, true, FlxColor.WHITE);
		// TODO: PRENDRE LES VALEURS DANS PLAYER
		_staminaBar.setRange(0, 2);
		add(_staminaBar);
		
		_pushDelayTarText = new FlxText(2, 48);
		_pushDelayTarText.height = 16;
		_pushDelayTarText.text = "PUSH CD";
		add(_pushDelayTarText);
		
		_pushDelayBar = new FlxBar(0, 64, LEFT_TO_RIGHT, 64, 16);
		_pushDelayBar.createColoredFilledBar(FlxColor.RED, true, FlxColor.WHITE);
		// TODO: PRENDRE LES VALEURS DANS PLAYER
		_pushDelayBar.setRange(0, 0.5);
		add(_pushDelayBar);
		
		_batteryBar = new FlxBar(0, 80, BOTTOM_TO_TOP, 64, 402);
		_batteryBar.createGradientFilledBar([FlxColor.BLUE, FlxColor.PURPLE, FlxColor.RED], 16, 90, true, FlxColor.BLACK);
		add(_batteryBar);
		
		_batteryText = new FlxText(8, 285);
		_batteryText.color = 0xFFFFFF;
		_batteryText.size = 18;
		_batteryText.setSize(64, 30);
		_batteryText.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		add(_batteryText);
		
		forEach(function(sprite:FlxSprite) {
			sprite.scrollFactor.set(0, 0);
		});
		
		FlxG.watch.add(_batteryBar, "height");
	}

	public function updateHUD(BatteryValue:Float, StaminaValue:Float, PushDelay:Float):Void {
		var vol:Int = Math.round(BatteryValue);
		_batteryBar.value = vol;
		_batteryText.text = vol + "%";
		
		if (Battery.instance._numberOfHackersHacking > 0)
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
		
		_staminaBar.value = StaminaValue;
		
		_pushDelayBar.value = 0.5 -  PushDelay;
	}
	
	public function startCall():Void {
		_callingIcon.visible = true;
		_callingIcon.flicker(0, 0.6);
	} 
	
	public function endCall():Void {
		_callingIcon.stopFlickering();
		_callingIcon.visible = false;
	}
	
	public function showWifi(ShowWifi:Bool):Void {
		_wifiIcon.visible = ShowWifi;
	}
}
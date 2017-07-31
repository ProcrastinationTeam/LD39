package hud;

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
	//public var _backgroundSprite			: FlxSprite;

	public var _batteryBar					: FlxBar;
	private var _batteryText 				: FlxText;
	
	// Référence au player (pas propre ? pratique en tout cas)
	private var _player 					: Player;
	private var _battery					: Battery;
	
	public var _batterySprite				: FlxSprite;
	
	public function new(player:Player)
	{
		super();
		
		var x: Int = 10000;

		//_backgroundSprite = new FlxSprite(x, 0).makeGraphic(_width, _height, FlxColor.BLACK);
		//add(_backgroundSprite);

		// TODO: virer le vert dégueu du background
		_batteryBar = new FlxBar(x + 8, 8, BOTTOM_TO_TOP, 48, 480);
		_batteryBar.createGradientBar([FlxColor.BLACK], [FlxColor.BLUE, FlxColor.PURPLE, FlxColor.RED], 16, 90);
		add(_batteryBar);
		
		_batterySprite = new FlxSprite().loadGraphic(AssetPaths.BatteryHUD__png, false, 64, 480);
		_batterySprite.setPosition(x + 0, 0);
		add(_batterySprite);

		_batteryText = new FlxText(x + 12, 250);
		_batteryText.color = 0xFFFFFF;
		_batteryText.size = 18;
		_batteryText.setSize(64, 30);
		_batteryText.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		add(_batteryText);
		
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
	}
}
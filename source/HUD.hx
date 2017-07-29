package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.ui.FlxBar;

using flixel.util.FlxSpriteUtil;

class HUD extends FlxTypedGroup<FlxSprite>
{
	//private var _sprBack:FlxSprite;
	//private var _txtHealth:FlxText;
	//private var _txtMoney:FlxText;
	//private var _sprHealth:FlxSprite;
	//private var _sprMoney:FlxSprite;
	
	private var _barVolume				: FlxBar;

	public function new() {
		super();
		//_sprBack = new FlxSprite().makeGraphic(FlxG.width, 20, FlxColor.BLACK);
		//_sprBack.drawRect(0, 19, FlxG.width, 1, FlxColor.WHITE);
		//_txtHealth = new FlxText(16, 2, 0, "3 / 3", 8);
		//_txtHealth.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		//_txtMoney = new FlxText(0, 2, 0, "0", 8);
		//_txtMoney.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
		//_sprHealth = new FlxSprite(4, _txtHealth.y + (_txtHealth.height/2)  - 4, AssetPaths.health__png);
		//_sprMoney = new FlxSprite(FlxG.width - 12, _txtMoney.y + (_txtMoney.height/2)  - 4, AssetPaths.coin__png);
		//_txtMoney.alignment = RIGHT;
		//_txtMoney.x = _sprMoney.x - _txtMoney.width - 4;
		//add(_sprBack);
		//add(_sprHealth);
		//add(_sprMoney);
		//add(_txtHealth);
		//add(_txtMoney);
		
		_barVolume = new FlxBar(FlxG.camera.x, FlxG.camera.y, BOTTOM_TO_TOP, 50, 300);
		_barVolume.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		_barVolume.scrollFactor.set(0, 0);
		add(_barVolume);
		
		forEach(function(spr:FlxSprite) {
			spr.scrollFactor.set(0, 0);
		});
	}

	public function updateHUD(BatteryValue:Float):Void {
		_barVolume.value = BatteryValue;
	}
}
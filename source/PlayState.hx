package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _map 					: FlxOgmoLoader;
	private var _mWalls 				: FlxTilemap;
	private var _player 				: Player;
	private var _battery				: Battery;

	private var _barVolume				: FlxBar;
	private var _volume					: Float = 50;
	
	private var _initialRemainingTime 	: Float = 60;
	private var _currentRemainingTime 	: Float = 60;

	override public function create():Void
	{
		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "background");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(38, FlxObject.ANY);
		_mWalls.setTileProperties(37, FlxObject.ANY);
		add(_mWalls);

		_player = new Player();
		_map.loadEntities(placeEntities, "entities");
		add(_player);
		
		_battery = new Battery(50, 1);
		add(_battery);

		_barVolume = new FlxBar(0, 0, BOTTOM_TO_TOP, 50, 300);
		_barVolume.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		_barVolume.value = _battery._batteryValue;
		add(_barVolume);

		super.create();
	}

	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_currentRemainingTime -= elapsed;
		
		_battery._batteryValue += FlxG.mouse.wheel;

		var vol:Int = Math.round(_battery._batteryValue);
		_barVolume.value = vol;

		if (FlxG.keys.justPressed.C)
		{
			_battery._isCallingMom = !_battery._isCallingMom;
		}
		if (FlxG.keys.justPressed.V)
		{
			_battery.punctualDecreaseBattery(FlxG.random.float(2, 5));
		}
		
		if (_battery._batteryValue <= 0 || _currentRemainingTime <= 0) {
			// GAMEOVER
			FlxG.switchState(new GameOverState(false));
		}
	}
}

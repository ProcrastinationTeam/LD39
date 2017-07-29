package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.tile.FlxTilemap;

private var _map : FlxOgmoLoader;
private var _mWalls : FlxTilemap;
private var _player : Player;

class PlayState extends FlxState
{

	private var _barVolume:FlxBar;
	private var _volume:Float = 50;
	
	override public function create():Void
	{
		
		_barVolume = new FlxBar(0, 0, BOTTOM_TO_TOP, 50, 300);
		_barVolume.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		_barVolume.value = _volume;
		add(_barVolume);
		
		super.create();

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
		
		_volume += FlxG.mouse.wheel / 20.;
		
		var vol:Int = Math.round(_volume);
		_barVolume.value = vol;
	}
}

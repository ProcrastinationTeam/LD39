package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;

class PlayState extends FlxState
{
	private var _map : FlxOgmoLoader;
	private var _mWalls : FlxTilemap;
	private var _player : Player;
	private var _exit : FlxSprite;

	private var _isOut: Bool;
		
		
	override public function create():Void
	{
		_isOut = false;
		
		_exit = new FlxSprite();
		_exit.alpha = 0;

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
		add(_exit);
		FlxG.camera.follow(_player, TOPDOWN, 1);

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
		else if (entityName == "exit")
		{
			_exit.x = x;
			_exit.y = y;
		}
	}

	private function playerExit(P:Player, C:FlxSprite):Void
	{
		if (P.alive && P.exists)
		{
			FlxG.switchState(new MenuState());	
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _exit, playerExit);
	}
}

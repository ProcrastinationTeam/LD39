package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.math.FlxPoint;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private var _map 					: FlxOgmoLoader;
	private var _mWalls 				: FlxTilemap;
	private var _player 				: Player;
	private var _battery				: Battery;

	private var _exit : FlxSprite;
	private var _isOut: Bool;

	private var _barVolume				: FlxBar;
	private var _volume					: Float = 50;

	private var _initialRemainingTime 	: Float = 60;
	private var _currentRemainingTime 	: Float = 60;

	override public function create():Void
	{
		_isOut = false;

		_exit = new FlxSprite();
		_exit.alpha = 0;
		add(_exit);

		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tiles__png, 16, 16, "background");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(38, FlxObject.ANY);
		_mWalls.setTileProperties(37, FlxObject.ANY);
		add(_mWalls);

		_player = new Player();
		add(_player);

		_map.loadEntities(placeEntities, "entities");

		FlxG.camera.follow(_player, TOPDOWN, 1);

		_battery = new Battery(50, 1);
		add(_battery);

		FlxG.camera.zoom = 2;
		
		_barVolume = new FlxBar(FlxG.camera.x, FlxG.camera.y, BOTTOM_TO_TOP, 50, 300);
		_barVolume.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		_barVolume.value = _battery._batteryValue;
		//_barVolume.scrollFactor.set(0, 0);
		add(_barVolume);
		
		var hudCam = new FlxCamera(0, 0, 50, 300, 1);
		//hudCam.x = -20;
		hudCam.target = _barVolume;
		FlxG.cameras.add(hudCam);
		
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

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_currentRemainingTime -= elapsed;

		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _exit, playerExit);
		
		_barVolume.x = FlxG.camera.x;
		_barVolume.y = FlxG.camera.y;

		//_battery._batteryValue += FlxG.mouse.wheel;
		
		FlxG.camera.zoom += FlxG.mouse.wheel / 20.;

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

		if (_battery._batteryValue <= 0 || _currentRemainingTime <= 0)
		{
			// GAMEOVER
			gameOver(false);
		}
	}

	private function playerExit(P:Player, C:FlxSprite):Void
	{
		if (P.alive && P.exists)
		{
			gameOver(true);
		}
	}

	public function gameOver(won:Bool):Void
	{
		FlxG.switchState(new GameOverState(won));
	}
}

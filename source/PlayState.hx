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
import flixel.FlxCamera;

class PlayState extends FlxState
{
	private var _map 					: FlxOgmoLoader;
	private var _mWalls 				: FlxTilemap;
	private var _player 				: Player;
	private var _battery				: Battery;

	private var _exit : FlxSprite;
	private var _isOut: Bool;

	private var _volume					: Float = 50;
	
	private var _hud 					: HUD;
	
	private var _isInCallWithMom		: Bool = false;
	
	private var _showWifi 				: Bool = false;

	override public function create():Void
	{
		_isOut = false;

		_exit = new FlxSprite();
		_exit.alpha = 0;
		add(_exit);

		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 16, 16, "background");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(4, FlxObject.NONE);
		_mWalls.setTileProperties(7, FlxObject.NONE);
		_mWalls.setTileProperties(38, FlxObject.NONE);
		_mWalls.setTileProperties(39, FlxObject.NONE);
		_mWalls.setTileProperties(40, FlxObject.NONE);
		_mWalls.setTileProperties(41, FlxObject.NONE);
		_mWalls.setTileProperties(42, FlxObject.NONE);
		_mWalls.setTileProperties(43, FlxObject.NONE);
		_mWalls.setTileProperties(44, FlxObject.NONE);
		
		_mWalls.setTileProperties(45, FlxObject.ANY);
		_mWalls.setTileProperties(46, FlxObject.ANY);
		_mWalls.setTileProperties(48, FlxObject.ANY);
		_mWalls.setTileProperties(10, FlxObject.ANY);
		_mWalls.setTileProperties(9, FlxObject.ANY);
		_mWalls.setTileProperties(75, FlxObject.ANY);
		_mWalls.setTileProperties(76, FlxObject.ANY);
		_mWalls.setTileProperties(77, FlxObject.ANY);
		add(_mWalls);

		_player = new Player();
		add(_player);

		_map.loadEntities(placeEntities, "entities");

		// Baisser la deadzone de la caméra si la caméra suit pas assez
		FlxG.camera.follow(_player, TOPDOWN_TIGHT, 1);

		_battery = Battery.instance;
		add(_battery);
		
		_battery.initBattery(FlxG.random.float(40, 60), 0.3);

		FlxG.camera.zoom = 3;
		
		_hud = new HUD();
		add(_hud);
		
		var hudCam = new FlxCamera(0, 0, 64, 316, 1);
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

		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _exit, playerExit);
		
		var batteryLevel:Int = Math.round(_battery._batteryLevel);
		_hud.updateHUD(batteryLevel);
		
		_battery._batteryLevel += FlxG.mouse.wheel;
		
		if (FlxG.keys.pressed.X && _player._canPush) {
			_grpHackers.forEachAlive(tryToPush);
			new FlxTimer().start(_pushDelay, AfterPushTimer);
		}
		
		if (FlxG.keys.justPressed.C)
		{
			_battery._isInCallWithMom = !_battery._isInCallWithMom;
			_isInCallWithMom = !_isInCallWithMom;
			
			if (_isInCallWithMom) {
				_hud.startCall();
			} else {
				_hud.endCall();
			}
		}
		if (FlxG.keys.justPressed.V)
		{
			_battery.punctualDecreaseBattery(FlxG.random.float(2, 5));
		}
		if (FlxG.keys.justPressed.W)
		{
			_showWifi = !_showWifi;
			_hud.showWifi(_showWifi);
		}

		if (_battery._batteryLevel <= 0)
		{
			// GAMEOVER
			gameOver(false);
		}
	}
	
	private function AfterPushTimer(Timer:FlxTimer):Void {
		_player._canPush  = true;
		_player._currentStamina = _player._maxStamina;
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

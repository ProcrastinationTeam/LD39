package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tile.FlxTilemap;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.FlxCamera;
import flixel.util.FlxTimer;

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

	//Enemy variables
	private var _grpHackers				:FlxTypedGroup<Hacker>;

	//Debug variable
	private var _counterHacker 			:Int = 0;

	override public function create():Void
	{
		
		_isOut = false;

		_exit = new FlxSprite();
		_exit.alpha = 0;
		add(_exit);

		//Modification a faire sur le tileset et les TileProperties (RENDRE PLUS PROPRE)
		_map = new FlxOgmoLoader(AssetPaths.level1__oel);
		_mWalls = _map.loadTilemap(AssetPaths.tileset__png, 16, 16, "background");
		_mWalls.follow();
		_mWalls.setTileProperties(1, FlxObject.NONE);
		_mWalls.setTileProperties(4, FlxObject.NONE);
		_mWalls.setTileProperties(7, FlxObject.NONE);
		_mWalls.setTileProperties(37, FlxObject.NONE);
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

		//HackerSpawn
		_grpHackers = new FlxTypedGroup<Hacker>();
		add(_grpHackers);

		_map.loadEntities(placeEntities, "entities");

		// Baisser la deadzone de la caméra si la caméra suit pas assez
		FlxG.camera.follow(_player, LOCKON, 1);
		// TODO 
		//FlxG.camera.deadzone

		_battery = Battery.instance;
		add(_battery);

		_battery.initBattery(FlxG.random.float(40, 60), 0.3);

		FlxG.camera.zoom = 4;

		_hud = new HUD();
		add(_hud);

		var hudCam = new FlxCamera(0, 0, 64, 480, 1);

		FlxG.cameras.add(hudCam);

		//ZONE DE DEBUG
		FlxG.watch.add(Battery.instance, "_numberOfHackersHacking" );
		///////////
		
		FlxG.mouse.visible = false;
		
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
		else if (entityName == "hacker")
		{
			_grpHackers.add(new Hacker(x + 4, y, Std.parseInt(entityData.get("etype")), _counterHacker));
			_counterHacker++;
		}

	}

	//Methode a migrer dans l'ideal 
	private function checkEnemyVision(e:Hacker):Void
	{
		e.distance = FlxMath.distanceBetween(_player, e);
		FlxG.watch.add(e, "distance", "Distance between me and hacker " + e.id +": ");

		if (_mWalls.ray(e.getMidpoint(), _player.getMidpoint()) && e.distance < 75)
		{
			e.seesPlayer = true;
			e.playerPos.copyFrom(_player.getMidpoint());
			
		}
		else
			e.seesPlayer = false;
	}
	
	/*private function checkRangeForHack(e:Hacker):Void
	{
	
		if (e.isInRangeForHack == true)
		{
			_battery._numberOfHackersHacking++;
		}
		
	}*/
	
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		//COLLISION SECTION
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _exit, playerExit);
		
		
		//FlxG.collide(_player, _grpHackers); //
		FlxG.collide(_grpHackers, _grpHackers);
		FlxG.collide(_grpHackers, _mWalls);

		//Action applique a un groupe d'entité
		_grpHackers.forEachAlive(checkEnemyVision);
		//_grpHackers.forEachAlive(checkRangeForHack);

		//BATTERY SECTION
		var batteryLevel:Int = Math.round(_battery._batteryLevel);
		_hud.updateHUD(batteryLevel, _player._currentStamina, _player._currentPushCooldown);

		_battery._batteryLevel += FlxG.mouse.wheel;
		
		if (FlxG.keys.pressed.X && _player._canPush) {
			_grpHackers.forEachAlive(tryToPush);
		}
		
		//DEBUG FUNCTION SECTION
		if (FlxG.keys.justPressed.C)
		{
			_battery._isInCallWithMom = !_battery._isInCallWithMom;
			_isInCallWithMom = !_isInCallWithMom;

			if (_isInCallWithMom)
			{
				_hud.startCall();
			}
			else
			{
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
		if (FlxG.keys.justPressed.B)
		{
			_grpHackers.forEachAlive(bullied);
		}
		//DEBUG FUNCTION SECTION

		if (_battery._batteryLevel <= 0)
		{
			// GAMEOVER
			gameOver(false);
		}
	}
	
	private function AfterPushTimer(Timer:FlxTimer):Void {
		_player._canPush  = true;
		_player._currentPushCooldown = 0;
	}

	private function bullied(h:Hacker):Void
	{
		//VALEUR A TWEAK
		if (FlxMath.distanceBetween(_player, h) < 15)
		{
			h.getBullied();
		}
	}
	
	private function tryToPush(h:Hacker):Void
	{
		//VALEUR A TWEAK
		if (FlxMath.distanceBetween(_player, h) < 15)
		{
			h.getBullied();
			_player._canPush = false;
			_player._currentStamina -= _player._pushCost;
			_player._currentPushCooldown = _player._pushDelay;
			new FlxTimer().start(_player._pushDelay, AfterPushTimer);
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

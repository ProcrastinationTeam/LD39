package states;

import enums.Levels;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.FlxPointer;
import flixel.math.FlxMath;
import flixel.system.FlxSound;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import hud.BatteryHUD;
import hud.PhoneHUD;
import states.GameOverState;
import hud.StaminaHUD;

class PlayState extends FlxState
{
	private var _map 								: FlxOgmoLoader;
	private var _walls 								: FlxTilemap;
	private var _foreground							: FlxTilemap;
	private var _hiddenground						: FlxTilemap;

	private var _player 							: Player;
	private var _battery							: Battery;

	private var _exit 								: FlxSprite;

	private var _currentLevel						: Levels;

	// Variables pour le call de maman
	private var _isInCallWithMom					: Bool = false;
	private var _lastCallWithMomDelay				: Float = 0;

	private var _momMessagesCount					: Int = 0;
	private var _lastMessageFromMomDelay			: Float = 0;
	private var _timeSendingMessage					: Float = 0;

	private var _canTweenPhone						: Bool = true;

	// TODO: ajouter une mécanique de décrochage ?
	//private var _momIsCalling						: Bool = false;

	// Environement variables
	private var _hackers							: FlxTypedGroup<Hacker>;
	private var _dogpunks							: FlxTypedGroup<DogPunk>;
	private var _npcs								: FlxTypedGroup<PNJ>;
	private var _powerups							: FlxTypedGroup<PowerUp>;

	private var _maxiGroup 							: FlxTypedGroup<FlxSprite>;

	// Debug variable
	private var _counterHacker 						: Int = 0;
	private var _counterPnj							: Int = 0;
	private var _counterDogpunk						: Int = 0;

	private var _showWifi 							: Bool = false;

	private var _spritePhone 						: FlxSprite;

	private var _phoneIsFullyShown					: Bool = false;

	private var _soundNewMessage					: FlxSound;

	// HUD
	private var _batteryHudCam 						: FlxCamera;
	private var _phoneHudCam 						: FlxCamera;
	//private var _staminaHudCam						: FlxCamera;

	private var _batteryHud 						: BatteryHUD;
	private var _phoneHud							: PhoneHUD;
	private var _staminaHud							: StaminaHUD;
	
	private var _phoneHudTop						: Float;
	private var _phoneHudBottom						: Float;
	
	private var _soundFadeIn						: FlxSound;
	private var _soundFadeOut						: FlxSound;

	public function new(level:Levels)
	{
		super();
		_currentLevel = level;
	}

	override public function create():Void
	{
		// Pas besoin de la souris pour le jeu (pour le moment en tout cas) donc on la cache
		//FlxG.mouse.visible = false;

		_soundNewMessage = FlxG.sound.load(AssetPaths.new_message_received__wav);
		
		_soundFadeIn = FlxG.sound.load(AssetPaths.fadein__wav);
		_soundFadeOut = FlxG.sound.load(AssetPaths.fadeout__wav);
		
		_exit = new FlxSprite();
		_exit.alpha = 0;
		add(_exit);

		switch (_currentLevel)
		{
			case TUTO :
				new Battery(Tweaking.batteryInitialLevel);
				_map = new FlxOgmoLoader(AssetPaths.tuto_new__oel);
			case LEVEL_1 :
				_map = new FlxOgmoLoader(AssetPaths.level_1_new__oel);
			case LEVEL_2 :
				_map = new FlxOgmoLoader(AssetPaths.level_2__oel);
			case LEVEL_3 :
				_map = new FlxOgmoLoader(AssetPaths.level_3__oel);
			case END :
				_map = new FlxOgmoLoader(AssetPaths.end__oel);
		}

		//Modification a faire sur le tileset et les TileProperties (RENDRE PLUS PROPRE)
		_walls = _map.loadTilemap(AssetPaths.tO__png, 16, 16, "background");
	
		_walls.follow(FlxG.camera, 1);
		
		_walls.setTileProperties(194, FlxObject.ANY);
		_walls.setTileProperties(196, FlxObject.ANY);
		_walls.setTileProperties(306, FlxObject.ANY);
		_walls.setTileProperties(342, FlxObject.ANY);
		_walls.setTileProperties(343, FlxObject.ANY);
		_walls.setTileProperties(888, FlxObject.NONE);
		_walls.setTileProperties(925, FlxObject.NONE);
		_walls.setTileProperties(926, FlxObject.NONE);
		_walls.setTileProperties(927, FlxObject.NONE);
		_walls.setTileProperties(962, FlxObject.NONE);
		_walls.setTileProperties(963, FlxObject.NONE);
		_walls.setTileProperties(964, FlxObject.NONE);
		
		_walls.setTileProperties(1000, FlxObject.NONE);
		_walls.setTileProperties(1001, FlxObject.NONE);
		_walls.setTileProperties(902, FlxObject.NONE);
		_walls.setTileProperties(795, FlxObject.NONE);
		_walls.setTileProperties(794, FlxObject.NONE);
		_walls.setTileProperties(898, FlxObject.NONE);
		_walls.setTileProperties(901, FlxObject.NONE);
		_walls.setTileProperties(789, FlxObject.NONE);
		_walls.setTileProperties(827, FlxObject.NONE);
		_walls.setTileProperties(907, FlxObject.NONE);
		
		_foreground = _map.loadTilemap(AssetPaths.tO__png, 16, 16, "foreground");
		
		_foreground.setTileProperties(403, FlxObject.ANY);
		_foreground.setTileProperties(440, FlxObject.ANY);
		_foreground.setTileProperties(440, FlxObject.ANY);
		_foreground.setTileProperties(440, FlxObject.ANY);
		_foreground.setTileProperties(440, FlxObject.ANY);
		
		if (_currentLevel == TUTO)
		{
		_hiddenground = _map.loadTilemap(AssetPaths.tO__png, 16, 16, "hiddenground");
		_hiddenground.setTileProperties(889, FlxObject.ANY);
		}
		
		/*_walls.setTileProperties(1, FlxObject.NONE);
		_walls.setTileProperties(2, FlxObject.NONE);
		_walls.setTileProperties(4, FlxObject.NONE);
		_walls.setTileProperties(5, FlxObject.NONE);
		_walls.setTileProperties(7, FlxObject.NONE);
		_walls.setTileProperties(37, FlxObject.NONE);
		_walls.setTileProperties(38, FlxObject.NONE);
		_walls.setTileProperties(39, FlxObject.NONE);
		_walls.setTileProperties(40, FlxObject.NONE);
		_walls.setTileProperties(41, FlxObject.NONE);
		_walls.setTileProperties(42, FlxObject.NONE);
		_walls.setTileProperties(43, FlxObject.NONE);
		_walls.setTileProperties(44, FlxObject.NONE);

		_walls.setTileProperties(45, FlxObject.ANY);
		_walls.setTileProperties(46, FlxObject.ANY);
		_walls.setTileProperties(48, FlxObject.ANY);
		_walls.setTileProperties(10, FlxObject.ANY);
		_walls.setTileProperties(9, FlxObject.ANY);
		_walls.setTileProperties(75, FlxObject.ANY);
		_walls.setTileProperties(76, FlxObject.ANY);
		_walls.setTileProperties(77, FlxObject.ANY);*/
		add(_walls);
		add(_foreground);

		_powerups = new FlxTypedGroup<PowerUp>();
		add(_powerups);

		_player = new Player();
		//add(_player);

		_hackers = new FlxTypedGroup<Hacker>();
		//add(_hackers);

		_npcs = new FlxTypedGroup<PNJ>();
		//add(_npcs);

		_dogpunks = new FlxTypedGroup<DogPunk>();

		// Spawing des entités (player + hackers + NPCs)
		_map.loadEntities(placeEntities, "entities");

		//_battery = Battery.instance;
		_battery = new Battery(Battery.instance._batteryLevel);
		// TODO: Fixer des valeurs, et les sortir d'ici
		//_battery.initBattery(FlxG.random.float(40, 60));
		// Même si elle n'a pas de sprite à afficher, il faut l'ajouter au state sinon ça fonctionne pas (le update se lance pas ?)
		add(_battery);

		// TODO: Baisser la deadzone de la caméra si la caméra suit pas assez
		FlxG.camera.follow(_player, LOCKON, 1);
		FlxG.camera.zoom = 4;

		_maxiGroup = new FlxTypedGroup<FlxSprite>();

		_maxiGroup.add(_player);
		_hackers.forEachAlive(function(hacker:Hacker)
		{
			_maxiGroup.add(hacker);
		});
		_dogpunks.forEachAlive(function(dogpunk:DogPunk)
		{
			_maxiGroup.add(dogpunk);
		});
		_npcs.forEachAlive(function(pnj:PNJ)
		{
			_maxiGroup.add(pnj);
		});
		_powerups.forEachAlive(function(powerUp:PowerUp)
		{
			_maxiGroup.add(powerUp);
		});
		add(_maxiGroup);

		////////////////////////////////////// BATTERY HUD
		_batteryHud = new BatteryHUD(_player);
		add(_batteryHud);

		// Caméra pour le HUD (on sait pas trop comment, mais ça marche)
		_batteryHudCam = new FlxCamera(0, 0, _batteryHud._width, _batteryHud._height, 1);
		_batteryHudCam.zoom = 1;
		_batteryHudCam.bgColor = FlxColor.TRANSPARENT;
		_batteryHudCam.follow(_batteryHud._batterySprite, NO_DEAD_ZONE);
		FlxG.cameras.add(_batteryHudCam);
		/////////////////////////////////////

		//////////////////////////////////// PHONE HUD
		_phoneHud = new PhoneHUD(_player);
		add(_phoneHud);

		// Caméra pour le HUD du téléphone
		_phoneHudCam = new FlxCamera(448, 416, _phoneHud._width, _phoneHud._height);
		_phoneHudCam.zoom = 1;
		_phoneHudCam.bgColor = FlxColor.TRANSPARENT;
		_phoneHudCam.follow(_phoneHud._phoneSprite, NO_DEAD_ZONE);
		FlxG.cameras.add(_phoneHudCam);
		////////////////////////////////////

		//////////////////////////////////// STAMINA HUD
		_staminaHud = new StaminaHUD(_player);
		add(_staminaHud);

		// Caméra pour le HUD du téléphone
		//_staminaHudCam = new FlxCamera(290, 115, _staminaHud._width, _staminaHud._height);
		//_staminaHudCam.zoom = 1;
		//_staminaHudCam.bgColor = FlxColor.TRANSPARENT;
		//_staminaHudCam.follow(_staminaHud._staminaBar, NO_DEAD_ZONE);
		//FlxG.cameras.add(_staminaHudCam);
		////////////////////////////////////

		// ZONE DE DEBUG
		FlxG.watch.add(_battery, "_numberOfHackersHacking" );
		// FIN DE ZONE DE DEBUG
		
		_phoneHudTop = _phoneHudCam.y - _phoneHud._height + 32;
		_phoneHudBottom = _phoneHudCam.y;

		_soundFadeIn.play();
		FlxG.camera.fade(FlxColor.BLACK, .2, true);
		_batteryHudCam.fade(FlxColor.BLACK, .2, true);
		_phoneHudCam.fade(FlxColor.BLACK, .2, true);

		super.create();
	}

	/**
	 * Fonction de spawn des entités de la map
	 *
	 * @param	entityName
	 * @param	entityData
	 */
	private function placeEntities(entityName:String, entityData:Xml):Void
	{
		var x:Int = Std.parseInt(entityData.get("x"));
		var y:Int = Std.parseInt(entityData.get("y"));
		if (entityName == "player")
		{
			_player.x = x;
			_player.y = y;
		}
		else if (entityName == "hacker")
		{
			_hackers.add(new Hacker(x + 4, y, Std.parseInt(entityData.get("etype")), _counterHacker));
			_counterHacker++;
		}
		else if (entityName == "pnj")
		{
			_npcs.add(new PNJ(x + 4, y, _counterPnj));
			_counterPnj++;
		}
		else if (entityName == "dogpunk")
		{
			_dogpunks.add(new DogPunk(x, y, _counterDogpunk, _player));
			_counterDogpunk++;
		}
		else if (entityName == "exit")
		{
			_exit.x = x;
			_exit.y = y;
		}
		else if (entityName == "powerup")
		{
			_powerups.add(new PowerUp(x + 4, y));
		}
	}

	/**
	 * Check si un hacker voit le joueur
	 *
	 * @param	hacker
	 */
	private function checkEnemyVision(hacker:Hacker):Void
	{
		hacker.distance = FlxMath.distanceBetween(_player, hacker);
		FlxG.watch.add(hacker, "distance", "Distance between me and hacker " + hacker.id +" : ");
		if (_walls.ray(hacker.getMidpoint(), _player.getMidpoint()) && hacker.distance < Tweaking.hackerVisionDistance)
		{
			trace("HACKER SEE YOU");
			hacker._seesPlayer = true;
			hacker._playerPosition.copyFrom(_player.getMidpoint());
		}
		else
		{
			hacker._seesPlayer = false;
		}
	}

	/**
	 * Check si un hacker voit le joueur
	 *
	 * @param	dogpunk
	 */
	private function checkEnemyVisionDogpunk(dogpunk:DogPunk):Void
	{
		dogpunk.distance = FlxMath.distanceBetween(_player, dogpunk);
		FlxG.watch.add(dogpunk, "distance", "Distance between me and hacker " + dogpunk.id +" : ");
		if (_walls.ray(dogpunk.getMidpoint(), _player.getMidpoint()) && dogpunk.distance < Tweaking.dogpunkVisionDistance)
		{
			dogpunk._seesPlayer = true;
			dogpunk._playerPosition.copyFrom(_player.getMidpoint());
		}
		else
		{
			dogpunk._seesPlayer = false;
		}
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_maxiGroup.sort(FlxSort.byY);

		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////// Reformater
		// COLLISION SECTION

		// PLAYER
		FlxG.collide(_player, _walls);
		FlxG.collide(_player, _npcs);
		FlxG.collide(_player, _foreground);
		FlxG.collide(_player, _hackers); // Transform to Enemy maybe
		FlxG.collide(_player, _dogpunks);

		FlxG.overlap(_player, _powerups, PlayerGetPowerup);
		FlxG.overlap(_player, _exit, PlayerExit);

		// PNJ
		FlxG.collide(_npcs, _walls);
		FlxG.collide(_npcs, _foreground);
		FlxG.collide(_npcs, _npcs);
		
		

		// HACKER (ENEMY)
		FlxG.collide(_hackers, _hackers); // Il semble que suite a un bullied ils se supperposent
		FlxG.collide(_hackers, _npcs);
		FlxG.collide(_hackers, _walls);
		FlxG.collide(_hackers, _foreground);
		
		

		// DOGPUNK (ENEMY)
		FlxG.collide(_dogpunks, _dogpunks);
		FlxG.collide(_dogpunks, _npcs);
		FlxG.collide(_dogpunks, _walls);
		FlxG.collide(_dogpunks, _foreground);
		
		FlxG.collide(_dogpunks, _hiddenground);

		// POWERUP
		FlxG.collide(_powerups, _walls);
		
		if (_currentLevel == TUTO)
		{
			FlxG.collide(_npcs, _hiddenground);
			FlxG.collide(_hackers, _hiddenground);
		}

		////////////////////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////////////////////////////////////////////////////////////////////////////////////////////

		// FOREACH SECTION (FONCTION APPLIQUEE A UN GROUPE)
		//Action applique a un groupe d'entité
		_hackers.forEachAlive(checkEnemyVision);
		_dogpunks.forEachAlive(checkEnemyVisionDogpunk);
		//_grpHackers.forEachAlive(checkRangeForHack);

		// SECTION GESTION DE LA BATTERIE
		if (_isInCallWithMom)
		{
			_battery._batteryLevel -= Tweaking.batteryDecreaseRatePerSecondThroughCall * elapsed;
		}

		// BULLY SECTION
		if (FlxG.keys.pressed.X && _player._canBully)
		{
			_hackers.forEachAlive(TryToBullyHacker);
			_npcs.forEachAlive(TryToBullyNpc);
		}

		// MAMAN MESSAGE / APPEL SECTION
		if (!_isInCallWithMom
		&& _lastCallWithMomDelay > Tweaking.momCallDuration + Tweaking.momCallDelayBetweenTwoCalls
		&& _lastMessageFromMomDelay > Tweaking.momMessagesDelayBetweenTwoMessages)
		{
			// TODO: Tweak ?
			if (FlxG.random.bool(1))
			{
				_momMessagesCount++;
				_lastMessageFromMomDelay = 0;
				if (_momMessagesCount > Tweaking.momMessagesThreshold)
				{
					// Appel de maman
					_isInCallWithMom = true;
					_player._isInCallWithMom = true;
					_momMessagesCount = 0;
					_lastCallWithMomDelay = 0;
					_player._isOnHisPhone = true;
					_phoneHud.startCall();
					_phoneHudCam.shake(0.05, Tweaking.momCallDuration - 0.1);
					new FlxTimer().start(Tweaking.momCallDuration, CallWithMomEndend);
					//new FlxTimer().start(Tweaking.momCallDelayBetweenScreenShakes, CallScreenShake, Std.int(Tweaking.momCallDuration));
				}
				else
				{
					// TODO: Screenshake parce que reçu message + anima du HUD
					_soundNewMessage.play();
				}
			}
		}

		if (_isInCallWithMom && _canTweenPhone && !_phoneIsFullyShown)
		{
			_canTweenPhone = false;
			FlxTween.tween(_phoneHudCam, { x: _phoneHudCam.x, y: _phoneHudTop }, Tweaking.phoneOpeningTime, { ease: FlxEase.quadInOut, onComplete: phoneTweenOpeningEnded });
		}

		_lastCallWithMomDelay += elapsed;
		_lastMessageFromMomDelay += elapsed;

		// Si on reste appuyé sur M pendant X secondes, on reset le nombre de messages envoyés par maman
		// TODO: empêcher de bouger le player
		if (FlxG.keys.pressed.M && _phoneIsFullyShown && _momMessagesCount > 0)
		{
			_player._isOnHisPhone = true;
			_timeSendingMessage += elapsed;
			if (_timeSendingMessage >= Tweaking.momMessageTimeToSend)
			{
				_momMessagesCount = 0;
				_timeSendingMessage = 0;
				_player._isOnHisPhone = false;
				_phoneHud.stopWritingSms();
				FlxTween.tween(_phoneHudCam, { x: _phoneHudCam.x, y: _phoneHudBottom }, Tweaking.phoneOpeningTime, { ease: FlxEase.quadInOut, onComplete: phoneTweenClosingEnded });
			}
		}
		else if (FlxG.keys.justPressed.M && _momMessagesCount > 0 && _canTweenPhone)
		{
			_canTweenPhone = false;
			FlxTween.tween(_phoneHudCam, { x: _phoneHudCam.x, y: _phoneHudTop }, Tweaking.phoneOpeningTime, { ease: FlxEase.quadInOut, onComplete: phoneTweenOpeningEnded });
		}
		if (FlxG.keys.checkStatus(M, RELEASED) && FlxG.keys.checkStatus(T, RELEASED) && !_isInCallWithMom)
		{
			_player._isOnHisPhone = false;
			_timeSendingMessage = 0;
			if (_phoneIsFullyShown && _canTweenPhone)
			{
				_canTweenPhone = false;
				_phoneHud.stopWritingSms();
				FlxTween.tween(_phoneHudCam, { x: _phoneHudCam.x, y: _phoneHudBottom }, Tweaking.phoneOpeningTime, { ease: FlxEase.quadInOut, onComplete: phoneTweenClosingEnded });
			}
			// TODO: attendre le minimum de temps et retweener
		}

		_phoneHud.updatePhoneHUD(_momMessagesCount, _player._isOnHisPhone && !_player._isInCallWithMom);

		/////////////////////////////////////////////////////////////////////// SECTION DEBUG
		// Il faut obligatoirement avoir SHIFT d'enfoncer pour utiliser ces fonctions de debug
		if (FlxG.keys.pressed.SHIFT)
		{
			if (FlxG.keys.pressed.ALT)
			{
				FlxG.camera.zoom += FlxG.mouse.wheel / 20.;
			}
			else
			{
				// Contrôle du niveau de la batterie avec la molette
				_battery._batteryLevel += FlxG.mouse.wheel;
			}

			// Test call avec maman
			if (FlxG.keys.justPressed.C)
			{
				_isInCallWithMom = !_isInCallWithMom;

				if (_isInCallWithMom)
				{
					_phoneHud.startCall();
				}
				else
				{
					_phoneHud.endCall();
				}
			}

			// Test niquage ponctuel de batterie
			if (FlxG.keys.justPressed.V)
			{
				_battery.punctualDecreaseBattery(FlxG.random.float(2, 5));
			}

			// Test bullying sans vergogne
			if (FlxG.keys.justPressed.B)
			{
				_hackers.forEachAlive(TryToBullyFreely);
			}

			// Aller direct à l'exit
			if (FlxG.keys.justPressed.E)
			{
				switch (_currentLevel)
				{
					case TUTO :
						_player.x = 320;
						_player.y = 208;
					case LEVEL_1 :
						_player.x = 595;
						_player.y = 60;
					case LEVEL_2 :
						_player.x = 600;
						_player.y = 440;
					case LEVEL_3 :
						_player.x = 304;
						_player.y = 176;
					case END :
				}
			}

			// Fait apparaitre le tel
			// TODO: empêcher d'appeler avant la fin
			// TODO: va disparaitre ?
			if (FlxG.keys.justPressed.T && _canTweenPhone)
			{
				_canTweenPhone = false;
				if (_phoneIsFullyShown)
				{
					FlxTween.tween(_phoneHudCam, { x: _phoneHudCam.x, y: _phoneHudBottom }, Tweaking.phoneOpeningTime, { ease: FlxEase.quadInOut, onComplete: phoneTweenClosingEnded });
				}
				else
				{
					FlxTween.tween(_phoneHudCam, { x: _phoneHudCam.x, y: _phoneHudTop }, Tweaking.phoneOpeningTime, { ease: FlxEase.quadInOut, onComplete: phoneTweenOpeningEnded });
				}
				_phoneIsFullyShown = !_phoneIsFullyShown;
			}
		}
		////////////////////////////////////////////////// FIN SECTION DEBUG

		// Si la batterie atteint les 0%, c'est un game over
		if (_battery._batteryLevel <= 0)
		{
			gameOver(false);
		}
	}

	private function phoneTweenOpeningEnded(Tween:FlxTween):Void
	{
		_canTweenPhone = true;
		_phoneIsFullyShown = true;
		if (FlxG.keys.pressed.M) {
			_phoneHud.startWritingSms();
		}
	}

	private function phoneTweenClosingEnded(Tween:FlxTween):Void
	{
		_canTweenPhone = true;
		_phoneIsFullyShown = false;
	}

	/**Fonction de recupération de powerUp
	 *
	 *
	 */
	private function PlayerGetPowerup(P:Player, UP:PowerUp):Void
	{
		if (P.alive && P.exists && UP.alive && UP.exists)
		{
			UP.kill();
		}
	}

	/**
	 * Fonction de debug (bully sans cout)
	 *
	 * @param	hacker
	 */
	private function TryToBullyFreely(hacker:Hacker):Void
	{
		if (FlxMath.distanceBetween(_player, hacker) < Tweaking.playerMinDistanceToBully)
		{
			hacker.getBullied(_player);
		}
	}

	/**
	 * Essaye de bully un hacker
	 *
	 * @param	hacker
	 */
	private function TryToBullyHacker(hacker:Hacker):Void
	{
		// TODO: faire une autre fonction pour bully aussi les pnj et les punks à chien
		if (FlxMath.distanceBetween(_player, hacker) < Tweaking.playerMinDistanceToBully)
		{
			hacker.getBullied(_player);
			_player._canBully = false;
			_player._currentStamina -= Tweaking.playerBullyingCost;
			_player._currentBullyCooldown = Tweaking.playerBullyingDelay;
			new FlxTimer().start(Tweaking.playerBullyingDelay, AfterBullyTimer);
		}
	}

	/**
	 * Essaye de bully un pnj
	 *
	 * @param	npc
	 */
	private function TryToBullyNpc(pnj:PNJ):Void
	{
		// TODO: faire une autre fonction pour bully aussi les pnj et les punks à chien
		if (FlxMath.distanceBetween(_player, pnj) < Tweaking.playerMinDistanceToBully)
		{
			pnj.getBullied(_player);
			_player._canBully = false;
			_player._currentStamina -= Tweaking.playerBullyingCost;
			_player._currentBullyCooldown = Tweaking.playerBullyingDelay;
			new FlxTimer().start(Tweaking.playerBullyingDelay, AfterBullyTimer);
		}
	}

	// CALLBACKS
	/**
	 * Fonction appellée à la fin du timer de bully
	 * On peut de nouveau bully et on reset le cooldown
	 *
	 * @param	Timer
	 */
	private function AfterBullyTimer(Timer:FlxTimer):Void
	{
		_player._canBully = true;
		_player._currentBullyCooldown = 0;
	}

	/**
	 * Fonction appellée à la fin du timer de call avec maman
	 * On met à jour le hud pour arrêter de faire clignoter l'icone
	 *
	 * @param	Timer
	 */
	private function CallWithMomEndend(Timer:FlxTimer):Void
	{
		_isInCallWithMom = false;
		_player._isInCallWithMom = false;
		_player._isOnHisPhone = false;
		FlxTween.tween(_phoneHudCam, { x: _phoneHudCam.x, y: _phoneHudCam.y + _phoneHud._height - 32 }, Tweaking.phoneOpeningTime, { ease: FlxEase.quadInOut, onComplete: phoneTweenClosingEnded });
		_phoneHud.endCall();
	}

	/**
	 * Fonction appelée toutes les X secondes pendant l'appel
	 * Fais un petit screenshake pour rappeler qu'on est en call
	 *
	 * @param	Timer
	 */
	private function CallScreenShake(Timer:FlxTimer):Void
	{
		// TODO: même qu'au lancement ?
		// TODO: ajouter un effet sonore ? ou pendant tout le call ?
		FlxG.camera.shake(0.005, 0.1);
	}

	/**
	 * Indique que le joueur est arrivé à la sortie du niveau !
	 * @param	player
	 * @param	sprite
	 */
	private function PlayerExit(player:Player, sprite:FlxSprite):Void
	{
		if (player.alive && player.exists)
		{
			gameOver(true);
		}
	}

	/**
	 * Switch vers le state game over en indiquant si le joueur a gagné
	 *
	 * @param	won
	 */
	public function gameOver(won:Bool):Void
	{
		// TODO: gérer le multi niveaux
		if (won)
		{
			_soundFadeOut.play();
			_batteryHudCam.fade(FlxColor.BLACK, .2, false);
			_phoneHudCam.fade(FlxColor.BLACK, .2, false);
			switch (_currentLevel)
			{
				case TUTO :
					FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
					{
						FlxG.switchState(new PlayState(LEVEL_1));
					});
				case LEVEL_1 :
					FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
					{
						FlxG.switchState(new PlayState(LEVEL_2));
					});
				case LEVEL_2 :
					FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
					{
						FlxG.switchState(new PlayState(LEVEL_3));
					});
				case LEVEL_3 :
					FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
					{
						FlxG.switchState(new PlayState(END));
					});
				case END :
					// TODO
					FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
					{
						FlxG.switchState(new MenuState());
					});
			}
		}
		else {
			// LOSE
			_soundFadeOut.play();
			FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
			{
				//TODO: reset que le niveau actuel ?
				FlxG.switchState(new GameOverState(false));
			});
		}
	}
}
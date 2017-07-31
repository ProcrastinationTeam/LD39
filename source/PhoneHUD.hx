package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

using flixel.util.FlxSpriteUtil;

class PhoneHUD extends FlxTypedGroup<FlxSprite>
{
	public var _width						: Int = 128;
	public var _height						: Int = 256;

	//Rectangle de background
	public var _backgroundSprite			: FlxSprite;

	private var _phoneSprite				: FlxSprite;

	private var _wifiSprite32				: FlxSprite;
	private var _callSprite32				: FlxSprite;
	private var _messageSprite32			: FlxSprite;

	// Référence au player (pas propre ? pratique en tout cas)
	private var _player 					: Player;
	private var _battery					: Battery;
	
	private var _numberOfMessages			: Int = 0;
	private var _numberOfHackersHacking		: Int = 0;
	
	public function new(player:Player)
	{
		super();
		
		var x:Int = 20000;

		_backgroundSprite = new FlxSprite().makeGraphic(_width, _height, FlxColor.BLACK);
		_backgroundSprite.setPosition(x + 0, 0);
		add(_backgroundSprite);

		_wifiSprite32 = new FlxSprite().loadGraphic(AssetPaths.wifi_32__png, true, 32, 32);
		_wifiSprite32.setPosition(x + 96, 0);
		//_wifiSprite32.visible = false;
		_wifiSprite32.animation.add("default", [0], 3, true);
		_wifiSprite32.animation.add("hack", [0, 1, 2, 3], 3, true);
		_wifiSprite32.animation.play("default");
		add(_wifiSprite32);

		_callSprite32 = new FlxSprite().loadGraphic(AssetPaths.call_32__png, true, 32, 32);
		_callSprite32.setPosition(x, 0);
		//_callSprite32.visible = false;
		_callSprite32.animation.add("default", [0], 3, true);
		_callSprite32.animation.add("call", [0, 1, 2, 3, 4], 3, true);
		_callSprite32.animation.play("default");
		add(_callSprite32);
		
		_messageSprite32 = new FlxSprite().loadGraphic(AssetPaths.messages_32__png, true, 32, 32);
		_messageSprite32.setPosition(x + 32, 0);
		_messageSprite32.animation.add("0", [0], 3, true);
		_messageSprite32.animation.add("1", [0, 1], 3, true);
		_messageSprite32.animation.add("2", [0, 2], 3, true);
		_messageSprite32.animation.add("3", [0, 3], 3, true);
		_messageSprite32.animation.play("0");
		add(_messageSprite32);

		// CA CASSE TOUT CACA
		//forEach(function(sprite:FlxSprite)
		//{
		//sprite.scrollFactor.set(0, 0);
		//});

		_player = player;
		_battery = Battery.instance;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		if (_numberOfHackersHacking != _battery._numberOfHackersHacking) {
			_numberOfHackersHacking = _battery._numberOfHackersHacking;
			_wifiSprite32.animation.finish();
			if (_numberOfHackersHacking > 0) {
				_wifiSprite32.animation.play("hack");
			} else {
				_wifiSprite32.animation.play("default");
			}
		}

		if (_battery._batteryLevel < Tweaking.batteryLowBatteryThreshold)
		{
			// TODO: Afficher un hud de low batterie
		}
	}
	
	public function updatePhoneHUD(numberOfMessages:Int):Void {
		if (_numberOfMessages != numberOfMessages) {
			_numberOfMessages = numberOfMessages;
			_messageSprite32.animation.finish();
			switch (_numberOfMessages) 
			{
				case 0:
					_messageSprite32.animation.play("0");
				case 1:
					_messageSprite32.animation.play("1");
				case 2:
					_messageSprite32.animation.play("2");
				case 3:
					_messageSprite32.animation.play("3");
			}
		}
	}

	/**
	* Indique que le call avec maman commence, faire clignoter l'icône
	*/
	public function startCall():Void
	{
		_callSprite32.animation.finish();
		_callSprite32.animation.play("call");
	}

	/**
	* Indique que le call avec maman est fini, arrêter le clignotage
	*/
	public function endCall():Void
	{
		_callSprite32.animation.finish();
		_callSprite32.animation.play("default");
	}
}
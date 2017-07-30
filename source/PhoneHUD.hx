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

	public function new(player:Player)
	{
		super();
		
		var x:Int = 20000;

		_backgroundSprite = new FlxSprite().makeGraphic(_width, _height, FlxColor.BLACK);
		_backgroundSprite.setPosition(x + 0, 0);
		add(_backgroundSprite);

		_wifiSprite32 = new FlxSprite().loadGraphic(AssetPaths.wifi_32__png, true, 32, 32);
		_wifiSprite32.setPosition(x + 96, 0);
		_wifiSprite32.visible = false;
		_wifiSprite32.animation.add("hack", [0, 1, 2, 3], 3, true);
		_wifiSprite32.animation.play("hack");
		add(_wifiSprite32);

		_callSprite32 = new FlxSprite().loadGraphic(AssetPaths.call_32__png, true, 32, 32);
		_callSprite32.setPosition(x, 0);
		_callSprite32.visible = false;
		_callSprite32.animation.add("call", [0, 1, 2, 3, 4], 3, true);
		_callSprite32.animation.play("call");
		add(_callSprite32);
		
		_messageSprite32 = new FlxSprite().loadGraphic(AssetPaths.message_32_temp__png, false, 32, 32);
		_messageSprite32.setPosition(x + 32, 0);
		_messageSprite32.visible = true;
		//_messageSprite32.animation.add("call", [0, 1, 2, 3, 4], 3, true);
		//_messageSprite32.animation.play("call");
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

		if (_battery._numberOfHackersHacking > 0)
		{
			_wifiSprite32.visible = true;
			_wifiSprite32.animation.play("hack");
		}
		else
		{
			if (_wifiSprite32.visible)
			{
				_wifiSprite32.visible = false;
				_wifiSprite32.animation.finish();
			}
		}

		if (_battery._batteryLevel < Tweaking.batteryLowBatteryThreshold)
		{
			// TODO: Afficher un hud de low batterie
		}
	}

	/**
	* Indique que le call avec maman commence, faire clignoter l'icône
	*/
	public function startCall():Void
	{
		_callSprite32.visible = true;
		_callSprite32.animation.play("call");
	}

	/**
	* Indique que le call avec maman est fini, arrêter le clignotage
	*/
	public function endCall():Void
	{
		_callSprite32.animation.finish();
		_callSprite32.visible = false;
	}
}
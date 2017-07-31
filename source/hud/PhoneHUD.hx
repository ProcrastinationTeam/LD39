package hud;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

using flixel.util.FlxSpriteUtil;

class PhoneHUD extends FlxTypedGroup<FlxSprite>
{
	public var _width						: Int = 128;
	public var _height						: Int = 256;

	//Rectangle de background
	public var _phoneSprite					: FlxSprite;

	private var _backgroundTopSprite		: FlxSprite;
	private var _backgroundSeparationSprite	: FlxSprite;
	private var _backgroundBottomSprite		: FlxSprite;

	private var _wifiSprite32				: FlxSprite;
	private var _callSprite32				: FlxSprite;
	private var _messageSprite32			: FlxSprite;

	// Référence au player (pas propre ? pratique en tout cas)
	private var _player 					: Player;
	private var _battery					: Battery;

	private var _numberOfMessages			: Int = 0;
	private var _numberOfHackersHacking		: Int = 0;

	private var _textMom0					: FlxText;
	private var _textMom0Background			: FlxSprite;
	private var _textMom1					: FlxText;
	private var _textMom1Background			: FlxSprite;
	private var _textMom2					: FlxText;
	private var _textMom2Background			: FlxSprite;
	private var _textPlayer					: FlxTypeText;
	private var _textPlayerBackground		: FlxSprite;

	private var _isTexting					: Bool = false;

	private var _soundMom					: FlxSound;
	
	public function new(player:Player)
	{
		super();

		var x:Int = 20000;

		_backgroundTopSprite = new FlxSprite().makeGraphic(_width - 22, _height - 96, FlxColor.BLACK);
		_backgroundTopSprite.setPosition(x + 11, 32);
		add(_backgroundTopSprite);

		// 0x847e87
		_backgroundBottomSprite = new FlxSprite().makeGraphic(_width - 22, _height - 64, FlxColor.GRAY);
		_backgroundBottomSprite.setPosition(x + 11, 64 + 4);
		add(_backgroundBottomSprite);

		_backgroundSeparationSprite = new FlxSprite().makeGraphic(_width - 22, 4, FlxColor.GREEN);
		_backgroundSeparationSprite.setPosition(x + 11, 64);
		add(_backgroundSeparationSprite);

		_phoneSprite = new FlxSprite().loadGraphic(AssetPaths.iDroidPhone128__png, false, 128, 256);
		_phoneSprite.setPosition(x + 0, 0);
		add(_phoneSprite);

		_callSprite32 = new FlxSprite().loadGraphic(AssetPaths.call_icon_32__png, true, 32, 32);
		_callSprite32.setPosition(x + 11 + 1, 32);
		_callSprite32.visible = false;
		_callSprite32.animation.add("default", [0], 3, true);
		_callSprite32.animation.add("call", [0, 1, 2, 3], 4, true);
		add(_callSprite32);

		_messageSprite32 = new FlxSprite().loadGraphic(AssetPaths.messages_32__png, true, 32, 32);
		_messageSprite32.setPosition(x + 11 + 32 + 3, 32);
		_messageSprite32.visible = false;
		_messageSprite32.animation.add("0", [0], 3, true);
		_messageSprite32.animation.add("1", [1, 0], 4, true);
		_messageSprite32.animation.add("2", [2, 0], 4, true);
		_messageSprite32.animation.add("3", [3, 0], 4, true);
		add(_messageSprite32);

		_wifiSprite32 = new FlxSprite().loadGraphic(AssetPaths.wifi_32__png, true, 32, 32);
		_wifiSprite32.setPosition(x + 11 + 64 + 6, 32);
		_wifiSprite32.animation.add("default", [0], 3, true);
		_wifiSprite32.animation.add("hack", [1, 2, 3, 0], 4, true);
		_wifiSprite32.animation.play("default");
		add(_wifiSprite32);

		_textMom0 = new FlxText(x + 13, 70, _width - 22, "Call me when you get this message", 10, true);
		_textMom0.visible = false;
		
		_textMom0Background = new FlxSprite().makeGraphic(Std.int(_textMom0.width) - 5, Std.int(_textMom0.height), FlxColor.BLACK);
		_textMom0Background.setPosition(_textMom0.x, _textMom0.y);
		_textMom0Background.visible = false;
		add(_textMom0Background);
		add(_textMom0);

		_textMom1 = new FlxText(x + 13, _textMom0.y + _textMom0.height + 5, _width - 22, "Where are you???", 10, true);
		_textMom1.visible = false;
		
		_textMom1Background = new FlxSprite().makeGraphic(Std.int(_textMom1.width) - 5, Std.int(_textMom1.height), FlxColor.BLACK);
		_textMom1Background.setPosition(_textMom1.x, _textMom1.y);
		_textMom1Background.visible = false;
		add(_textMom1Background);
		add(_textMom1);

		_textMom2 = new FlxText(x + 13, _textMom1.y + _textMom1.height + 5, _width - 22, "Timmy. Edward. Samuel. Answer. Me. NOW!", 10, true);
		_textMom2.visible = false;
		
		_textMom2Background = new FlxSprite().makeGraphic(Std.int(_textMom2.width) - 5, Std.int(_textMom2.height), FlxColor.BLACK);
		_textMom2Background.setPosition(_textMom2.x, _textMom2.y);
		_textMom2Background.visible = false;
		add(_textMom2Background);
		add(_textMom2);

		_textPlayer = new FlxTypeText(x + 35, _textMom2.y + _textMom2.height + 5, _width - 24, "I'm still alive", 10, true);
		//_textPlayer.alignment = RIGHT;
		//new FlxTimer().start(2, function(timer:FlxTimer)
		//{
		//_textPlayer.start(0.07);
		//new FlxTimer().start(2, function(timer:FlxTimer)
		//{
		//_textPlayer.erase();
		//_textPlayer.skip();
		//});
		//});
				
		_textPlayerBackground = new FlxSprite().makeGraphic(Std.int(_textPlayer.width) - 5, Std.int(_textPlayer.height), FlxColor.BLACK);
		_textPlayerBackground.setPosition(_textPlayer.x, _textPlayer.y);
		_textPlayerBackground.visible = false;
		add(_textPlayerBackground);
		add(_textPlayer);
		
		_soundMom = FlxG.sound.load(AssetPaths.mom__wav);

		//_player = player;
		_battery = Battery.instance;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (_numberOfHackersHacking != _battery._numberOfHackersHacking)
		{
			_numberOfHackersHacking = _battery._numberOfHackersHacking;
			_wifiSprite32.animation.finish();
			if (_numberOfHackersHacking > 0)
			{
				_wifiSprite32.animation.play("hack");
			}
			else
			{
				_wifiSprite32.animation.play("default");
			}
		}

		if (_battery._batteryLevel < Tweaking.batteryLowBatteryThreshold)
		{
			// TODO: Afficher un hud de low batterie
		}
	}

	public function updatePhoneHUD(numberOfMessages:Int, isTexting:Bool):Void
	{
		if (_numberOfMessages != numberOfMessages)
		{
			_numberOfMessages = numberOfMessages;
			_messageSprite32.animation.finish();
			_messageSprite32.visible = _numberOfMessages > 0;
			switch (_numberOfMessages)
			{
				case 0:
					_messageSprite32.animation.play("0");
					_textMom0.visible = false;
					_textMom1.visible = false;
					_textMom2.visible = false;
					
					_textMom0Background.visible = false;
					_textMom1Background.visible = false;
					_textMom2Background.visible = false;
				case 1:
					_messageSprite32.animation.play("1");
					_textMom0.visible = true;
					_textMom1.visible = false;
					_textMom2.visible = false;
					
					_textMom0Background.visible = true;
					_textMom1Background.visible = false;
					_textMom2Background.visible = false;
				case 2:
					_messageSprite32.animation.play("2");
					_textMom0.visible = true;
					_textMom1.visible = true;
					_textMom2.visible = false;
					
					_textMom0Background.visible = true;
					_textMom1Background.visible = true;
					_textMom2Background.visible = false;
				case 3:
					_messageSprite32.animation.play("3");
					_textMom0.visible = true;
					_textMom1.visible = true;
					_textMom2.visible = true;
					
					_textMom0Background.visible = true;
					_textMom1Background.visible = true;
					_textMom2Background.visible = true;
			}

			//if (isTexting != _isTexting)
			//{
			//if (isTexting)
			//{
			//// on commence à textoter
			//_textPlayer.start(0.07);
			//}
			//else
			//{
			//// on arrete de textoter, osef
			//_textPlayer.erase();
			//_textPlayer.skip();
			//}
			//}
			//_isTexting = isTexting;
		}
	}

	/**
	* Indique que le call avec maman commence, faire clignoter l'icône
	*/
	public function startCall():Void
	{
		_callSprite32.visible = true;
		_callSprite32.animation.play("call");
		_soundMom.play();
	}

	/**
	* Indique que le call avec maman est fini, arrêter le clignotage
	*/
	public function endCall():Void
	{
		_callSprite32.visible = false;
		_callSprite32.animation.finish();
		_callSprite32.animation.play("default");
	}

	public function startWritingSms():Void
	{
		_textPlayer.start(0.06);
		_textPlayerBackground.visible = true;
	}

	public function stopWritingSms():Void
	{
		_textPlayer.erase();
		_textPlayer.skip();
		_textPlayerBackground.visible = false;
	}
}
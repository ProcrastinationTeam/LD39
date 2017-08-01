package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import states.ExplicationsState;
import flixel.system.FlxSound;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	public var _titleImage 			: FlxSprite;
	public var _credit 				: FlxText;
	public var _moreCredit 			: FlxText;
	public var _startDisplay 		: FlxText;
	public var _alphaModifier 		: Float;
	
	private var _soundFadeIn						: FlxSound;
	private var _soundFadeOut						: FlxSound;
	
	private var _soundMusic							: FlxSound;
	
	private var _swagSprite							: FlxSprite;
	
	private var _artworkSprite						: FlxSprite;
	
	override public function create():Void
	{
		_soundFadeIn = FlxG.sound.load(AssetPaths.fadein__wav);
		_soundFadeOut = FlxG.sound.load(AssetPaths.fadeout__wav);
		
		#if flash
		//_soundMusic = FlxG.sound.load(AssetPaths.satanic_pasbien__mp3);
		FlxG.sound.playMusic(AssetPaths.ost_v2__mp3, 0.3, true);
		#else
		//_soundMusic = FlxG.sound.load(AssetPaths.satanic_pasbien__ogg);
		FlxG.sound.playMusic(AssetPaths.ost_v2__ogg, 0.3, true);
		#end
		
		_alphaModifier = 0;
		
		_artworkSprite = new FlxSprite().loadGraphic(AssetPaths.Artwork__png, true, 640, 480);
		//_artworkSprite.setPosition(530, 20);
		_artworkSprite.animation.add("lol", [0, 1, 2, 3, 4, 5], 6, false);
		add(_artworkSprite);
		_artworkSprite.animation.play("lol");

		_titleImage = new FlxSprite(0, 0);
		_titleImage.loadGraphic(AssetPaths.Flixoul__png, false, 64,64);
		_titleImage.screenCenter();
		//add(_titleImage);

		_startDisplay = new FlxText(0, 0, 0, "Click or press SPACE to start", 18, true);
		_startDisplay.screenCenter();
		add(_startDisplay);

		_credit = new FlxText(0, 0, 0, "A 72h game by Lucas Tixier & Guillaume Ambrois", 12, true);
		_credit.screenCenter();
		_credit.y += 100;
		add(_credit);

		_moreCredit = new FlxText(0, 0, 0, "                 Twitter : \n@LucasTixier - @Eponopono", 12, true);
		_moreCredit.screenCenter();
		_moreCredit.y = _credit.y + 100;
		add(_moreCredit);

		FlxG.mouse.visible = true;
		
		_swagSprite = new FlxSprite().loadGraphic(AssetPaths.iDroidAnim_5__png, true, 80, 240);
		_swagSprite.setPosition(530, 250);
		_swagSprite.animation.add("lol", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57], 19, false);
		add(_swagSprite);
		_swagSprite.animation.play("lol");
		
		_soundFadeIn.play();
		FlxG.camera.fade(FlxColor.BLACK, .2, true);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		blink();

		// TODO: Faire que ça marche aussi avec n'importe quelle touche du clavier
		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			_soundFadeOut.play();
			FlxG.camera.fade(FlxColor.BLACK, .2, false, function() {
				FlxG.switchState(new ExplicationsState());
			});
		}
	}

	/**
	 * Fonction fait blinker le titre en modifiant son alpha
	 */
	public function blink()
	{
		var currentAlpha : Float;

		if (_startDisplay.alpha == 1)
		{
			_alphaModifier = -0.02;
		}

		if (_startDisplay.alpha == 0)
		{
			_alphaModifier = 0.02;
		}

		currentAlpha = _startDisplay.alpha;
		_startDisplay.alpha = currentAlpha + _alphaModifier;
	}
}
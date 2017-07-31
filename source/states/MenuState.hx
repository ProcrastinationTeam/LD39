package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;

class MenuState extends FlxState
{
	public var _titleImage 			: FlxSprite;
	public var _credit 				: FlxText;
	public var _moreCredit 			: FlxText;
	public var _startDisplay 		: FlxText;
	public var _alphaModifier 		: Float;

	override public function create():Void
	{
		_alphaModifier = 0;

		_titleImage = new FlxSprite(0, 0);
		_titleImage.loadGraphic(AssetPaths.Flixoul__png, false, 64,64);
		_titleImage.screenCenter();
		add(_titleImage);

		_startDisplay = new FlxText(0, 0, 0, "Click to start", 18, true);
		_startDisplay.screenCenter();
		add(_startDisplay);

		_credit = new FlxText(0, 0, 0, "A 72h game by Guillaume Ambrois & Lucas Tixier", 8, true);
		_credit.screenCenter();
		_credit.y += 100;
		add(_credit);

		_moreCredit = new FlxText(0, 0, 0, "Twitter : @LucasTixier \n @GuillaumeLaMouille", 8, true);
		_moreCredit.screenCenter();
		_moreCredit.y = _credit.y + 100;
		add(_moreCredit);

		FlxG.mouse.visible = true;

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		blink();

		// TODO: Faire que ça marche aussi avec n'importe quelle touche du clavier
		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			new Battery(Tweaking.batteryInitialLevel);
			FlxG.switchState(new PlayState(TUTO));
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
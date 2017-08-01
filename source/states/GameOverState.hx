package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.ExplicationsState;
import flixel.system.FlxSound;

class GameOverState extends FlxState
{
	public var _titleImage : FlxSprite;
	public var _credit : FlxText;
	public var _startDisplay : FlxText;
	public var _alphaModifier : Float;

	private var _win:Bool;				// if we won or lost
	
	private var _soundLose					: FlxSound;
	private var _soundWin					: FlxSound;
	
	private var _soundFadeIn						: FlxSound;
	private var _soundFadeOut						: FlxSound;

	/**
	* Called from PlayState, this will set our win and score variables
	* @param	Win		true if the player beat the boss, false if they died
	* @param	Score	the number of coins collected
	*/
	public function new(Win:Bool)
	{
		super();
		_win = Win;
	}

	override public function create():Void
	{
		_soundLose = FlxG.sound.load(AssetPaths.youlose__wav);
		_soundWin = FlxG.sound.load(AssetPaths.youwin__wav);
		
		if (!_win) {
			_soundLose.play();
		} else {
			_soundWin.play();
		}
		
		_soundFadeIn = FlxG.sound.load(AssetPaths.fadein__wav);
		_soundFadeOut = FlxG.sound.load(AssetPaths.fadeout__wav);
		
		_alphaModifier = 0;

		_titleImage = new FlxSprite(0, 0);
		_titleImage.loadGraphic(AssetPaths.Flixoul__png, false, 64,64);
		_titleImage.screenCenter();
		//add(_titleImage);

		_startDisplay = new FlxText(0, 0, 0, "Click to go back to main menu", 18, true);
		_startDisplay.screenCenter();
		add(_startDisplay);

		_credit = new FlxText(0, 0, 0, (_win ? "Congratulations ! " : "You suck"), 8, true);
		_credit.screenCenter();
		_credit.y += 100;
		add(_credit);
		
		FlxG.mouse.visible = true;
		
		_soundFadeIn.play();
		FlxG.camera.fade(FlxColor.BLACK, .2, true);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		blink();

		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			goBackToMainMenu();
		}

	}
	//Fonction fait blinker le titre en modifiant son alpha
	public function blink()
	{
		var currentAlpha : Float;

		if (_startDisplay.alpha == 1 )
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

	/**
	* When the user hits the main menu button, it should fade out and then take them back to the MenuState
	*/
	private function goBackToMainMenu():Void
	{
		FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
		{
			_soundFadeOut.play();
			FlxG.switchState(new MenuState());
		});
	}
}

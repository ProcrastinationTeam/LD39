package states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxTimer;
import flixel.system.FlxSound;

class ExplicationsState extends FlxState
{

	private var _hurryText 							: FlxTypeText;
	private var _startDisplay						: FlxText;
	
	private var _soundFadeIn						: FlxSound;
	private var _soundFadeOut						: FlxSound;
	
	override public function create():Void
	{
		_soundFadeIn = FlxG.sound.load(AssetPaths.fadein__wav);
		_soundFadeOut = FlxG.sound.load(AssetPaths.fadeout__wav);
		
		_startDisplay = new FlxText(0, 0, 0, "Click or press SPACE to skip (not recommended)", 18, true);
		_startDisplay.screenCenter();
		_startDisplay.y = 440;
		add(_startDisplay);

		_hurryText = new FlxTypeText(20, 20, 600, "Hurry!\n\nYour phone battery is almost dead, only 98% remaning!\n\nDon't let it empty because Big Mommy is Watching (Over) You and will punish you if that happens.\n\nAnswer her messages ([J]) before she calls you and drains even more battery.\n\nAvoid thugs who will bully you around.\n\nHackers disguised as NPCs will follow you and steal your wifi, bully them ([H]) to stop them.\n\nQuickly ([SPACE]) find the exit!", 14);
		_hurryText.start(0.02, false, false, [SPACE], function()
		{
			_startDisplay.text = "Click or press SPACE to start";
			_startDisplay.screenCenter();
			_startDisplay.y = 440;
		});
		add(_hurryText);

		_soundFadeIn.play();
		FlxG.camera.fade(FlxColor.BLACK, .2, true);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.mouse.justPressed || FlxG.keys.justPressed.SPACE)
		{
			_soundFadeOut.play();
			FlxG.camera.fade(FlxColor.BLACK, .2, false, function()
			{
				FlxG.switchState(new PlayState(TUTO));
			});
		}
	}
}

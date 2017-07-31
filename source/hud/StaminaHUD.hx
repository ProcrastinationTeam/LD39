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

using flixel.util.FlxSpriteUtil;

class StaminaHUD extends FlxTypedGroup<FlxSprite>
{
	public var _width						: Int = 64;
	public var _height						: Int = 64;

	public var _staminaBar					: FlxBar;

	private var _bullyDelayBar				: FlxBar;

	// Référence au player (pas propre ? pratique en tout cas)
	private var _player 					: Player;

	public function new(player:Player)
	{
		super();

		var x:Int = 30000;

		_staminaBar = new FlxBar(x, 0, LEFT_TO_RIGHT, 16, 4, player);
		_staminaBar.createColoredEmptyBar(FlxColor.GREEN, false);
		_staminaBar.setRange(0, Tweaking.playerMaxStamina);
		_staminaBar.trackParent(-4, -20);
		add(_staminaBar);

		_bullyDelayBar = new FlxBar(x, 20, LEFT_TO_RIGHT, 16, 4, player);
		_bullyDelayBar.createColoredFilledBar(FlxColor.RED, false);
		_bullyDelayBar.setRange(0, Tweaking.playerBullyingDelay);
		_bullyDelayBar.trackParent(-4, -15);
		add(_bullyDelayBar);

		_player = player;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		_staminaBar.value = _player._currentStamina;

		_bullyDelayBar.value = Tweaking.playerBullyingDelay - _player._currentBullyCooldown;
	}
}
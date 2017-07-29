package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flash.display.BitmapData;
import flash.display.Bitmap;
import flixel.math.FlxPoint;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;

class PlayState extends FlxState
{

	private var _barVolume:FlxBar;
	private var _volume:Float = 50;
	
	override public function create():Void
	{
		
		_barVolume = new FlxBar(0, 0, BOTTOM_TO_TOP, 50, 300);
		_barVolume.createFilledBar(0xff464646, FlxColor.WHITE, true, FlxColor.WHITE);
		_barVolume.value = _volume;
		add(_barVolume);
		
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		_volume += FlxG.mouse.wheel / 20.;
		
		var vol:Int = Math.round(_volume);
		_barVolume.value = vol;
	}
}

package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var _player:Player;

	override public function create():Void
	{
		// Add player
		_player = new Player(0, 0);
		add(_player);

		// Add camera
		FlxG.camera.bgColor = FlxColor.fromRGB(68, 71, 89);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var _level:Level;
	var _difficulty:Int = 1;

	override public function create():Void
	{
		// Add level
		_level = new Level(_difficulty);
		for (i in 0..._level.tiles.length)
		{
			for (j in 0..._level.tiles[i].length)
			{
				add(_level.tiles[i][j]);
			}
		}

		// Add Enemies
		for(i in 0..._level.monsters.length)
			add(_level.monsters[i]);

		// Add camera
		FlxG.camera.bgColor = FlxColor.fromRGB(68, 71, 89);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}

package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var _player:Player;
	var _level:Level;

	override public function create():Void
	{
		// Add level
		_level = new Level();
		for (i in 0..._level.tiles.length)
		{
			for (j in 0..._level.tiles[i].length)
			{
				add(_level.tiles[i][j]);
			}
		}

		// Add player
		var startTilePosition = _level.randomPassableTile();
		_player = new Player(startTilePosition.x, startTilePosition.y);
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

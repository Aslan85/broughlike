package;

import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxState;

class PlayState extends FlxState
{
	var _level:Level;
	public var difficulty:Int = 1;

	override public function create():Void
	{
		// Start Level
		startLevel(Const.PLAYERSTARTLIFE);
		
		// Add camera
		FlxG.camera.bgColor = FlxColor.fromRGB(68, 71, 89);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// Reset game
        if(FlxG.keys.anyJustPressed([R]))
        {
            FlxG.switchState(new PlayState());
		}
		
		super.update(elapsed);
	}

	public function startLevel(playerStartLife:Float):Void
	{
		// Clear all level data
		clearLevel();

		// Add level
		_level = new Level(this, difficulty, playerStartLife);
		for (i in 0..._level.tiles.length)
		{
			for (j in 0..._level.tiles[i].length)
			{
				add(_level.tiles[i][j]);
			}
		}

		// Add Enemies and player
		showMonsters();
	}

	function clearLevel():Void
	{
		if(_level != null)
		{
			// kill all monsters with lifes
			if(_level.monsters != null)
			{
				for(i in 0..._level.monsters.length)
				{
					for(j in 0...Const.MAXHP)
					{
						_level.monsters[i].lifes[j].kill();
					}
					_level.monsters[i].kill();
				}
			}

			// kill all tiles
			for (i in 0..._level.tiles.length)
			{
				for (j in 0..._level.tiles[i].length)
				{
					if(_level.tiles[i][j] != null)
						_level.tiles[i][j].kill();
				}
			}
		}
	}

	public function showMonsters()
	{
		if(_level.monsters == null)
			return;

		for(i in 0..._level.monsters.length)
		{
			add(_level.monsters[i]);
			for(j in 0...Const.MAXHP)
			{
				add(_level.monsters[i].lifes[j]);
			}
		}
	}
}

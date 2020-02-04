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
		_level = new Level(this, _difficulty);
		for (i in 0..._level.tiles.length)
		{
			for (j in 0..._level.tiles[i].length)
			{
				add(_level.tiles[i][j]);
			}
		}

		// Add Enemies and player
		showMonsters();
		
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

	public function showMonsters()
	{
		if(_level.monsters == null)
			return;

		for(i in 0..._level.monsters.length)
		{
			add(_level.monsters[i]);
			for(j in 0..._level.monsters[i].lifes.length)
			{
				add(_level.monsters[i].lifes[j]);
			}
		}
	}
}

package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	public var score:Int = 0;
	public var difficulty:Int = 1;

	var _hud:Hud;
	var _gameOverHud:GameOverHud;
	var _level:Level;

	override public function create():Void
	{
		// Init
		score = 0;
		difficulty = 1;

		// Start Level
		startLevel(Const.PLAYERSTARTLIFE);
		
		// Add camera
		FlxG.camera.bgColor = FlxColor.fromRGB(68, 71, 89);

		// Add UI
		_hud = new Hud();
		add(_hud);
		_hud.updateHUD(difficulty, score);
		_gameOverHud = new GameOverHud();

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

		// Add treasures
		showTreasures();

		// Add Enemies and player
		showMonsters();
	}

	function clearLevel():Void
	{
		if(_level != null)
		{
			// kill all treasures
			{
				for(i in 0..._level.treasures.length)
				{
					_level.treasures[i].kill();
				}
			}

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
					{
						_level.tiles[i][j].kill();
					}
				}
			}
		}
	}

	public function showTreasures()
	{
		if(_level.treasures == null)
			return;

		for(i in 0..._level.treasures.length)
		{
			add(_level.treasures[i]);
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

	public function addScore(points:Int):Void
	{
		score += points;
		_hud.updateHUD(difficulty, score);
	}

	public function addLevel():Void
	{
		difficulty++;
		_hud.updateHUD(difficulty, score);
	}

	public function showGameOver():Void
	{
		add(_gameOverHud);
		_gameOverHud.showGameOver();
	}
}

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
			FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
			{
				FlxG.switchState(new PlayState());
			});
		}
		
		super.update(elapsed);
	}

	public function startLevel(playerStartLife:Float):Void
	{
		// Clear all previous level data
		if(_level != null)
			_level.kill();

		// Add level
		_level = new Level(this, difficulty, playerStartLife);
		add(_level);
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

	public function addScores(active:Bool):Void
	{
		_gameOverHud.addScore(score, active);
	}

	public function showGameOver():Void
	{
		_gameOverHud.showGameOver();
		add(_gameOverHud);
	}
}

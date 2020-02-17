package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import Enums.SoundType;

class PlayState extends FlxState
{
	public var score:Int = 0;
	public var difficulty:Int = 1;

	var _hud:Hud;
	var _gameOverHud:GameOverHud;
	var _level:Level;
	var _showingGameOver:Bool;

	var _sndHit1:FlxSound;
	var _sndHit2:FlxSound;
	var _sndTreasure:FlxSound;
	var _sndNewLevel:FlxSound;
	var _sndSpell:FlxSound;

	override public function create():Void
	{
		// Init
		score = 0;
		difficulty = 1;
		_showingGameOver = false;

		// Start Level
		startLevel(Const.PLAYERSTARTLIFE);
		
		// Add camera
		FlxG.camera.bgColor = FlxColor.fromRGB(68, 71, 89);

		// Load sounds
		_sndHit1 = FlxG.sound.load(AssetPaths.hit1__wav);
		_sndHit2 = FlxG.sound.load(AssetPaths.hit2__wav);
		_sndTreasure = FlxG.sound.load(AssetPaths.treasure__wav);
		_sndNewLevel = FlxG.sound.load(AssetPaths.newLevel__wav);
		_sndSpell = FlxG.sound.load(AssetPaths.spell__wav);

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
		if(_showingGameOver)
			return;
		
		_showingGameOver = true;
		_gameOverHud.showGameOver();
		add(_gameOverHud);
	}

	public function playSound(s:SoundType):Void
	{
		switch(s)
		{
			case SoundType.hit1 : _sndHit1.play(true);
			case SoundType.hit2 : _sndHit2.play(true);
			case SoundType.treasure : _sndTreasure.play(true);
			case SoundType.newLevel : _sndNewLevel.play(true);
			case SoundType.spell : _sndSpell.play(true);
		}
	}
}

package state;

import utils.UtilFonctions;

import kha.math.Random;
import kha.Canvas;
import kha.input.KeyCode;
import kha.Assets;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.tmx.TiledMap;
import raccoon.ui.Text;

import tween.Delta;

import asset.ScoreManager;
import char.Player;
import world.Board;

class PlayState extends State
{
	public static var nbColums = 11;
	public static var nbRows = 11;
	
	public static var spawnRate:Int;
	public static var spawnCounter:Int;

	public static var board:Board;
	public static var player:Player;
	public static var level:Int = 1;
	public static var maxLevel:Int = 6;
	public static var startingPlayerHp = 3;

	public static var score:ScoreManager;

	var txtLevel:Text;
	
	public function new()
	{
		super();
		startLevel(startingPlayerHp);
		
		score = new ScoreManager(720, 18, 48);
		add(score);

		txtLevel = new Text('_8bit', 'Level: ' +level, score.position.x, score.position.y + score.text.size, 48);
		add(txtLevel);
	}

	override public function update()
	{
		super.update();
		player.update();
		score.update();

		if(level == maxLevel)
			txtLevel.string = 'Last level';
		else
			txtLevel.string = 'Level: ' +level;

		Delta.step(1/60);
	}

	override public function render(canvas:Canvas)
	{
		board.render(canvas);
		for(m in board.monsters)
			m.render(canvas);
		player.render(canvas);

		super.render(canvas);
	}

	public static function startLevel(hpPlayer:Int):Void
	{
		spawnRate = 15;
		spawnCounter = spawnRate;
	
		// Init board
		board = new Board(nbRows, nbColums);
		board.generateLevel();

		// Add player
		player = new Player(board.randomPassableTile(), hpPlayer);

		// Add monsters
		board.generateMonsters(level);

		// Add exit
		var exitTile = board.randomPassableTile();
		board.replaceByExit(exitTile);

		// Add Treasures
		for(i in 0...3)
		{
			var treasureTile = board.randomPassableTile();
			board.replaceByTreasure(treasureTile);
		}
	}

	public static function tick():Void
	{
		for(i in new ReverseIterator(board.monsters.length-1,0))
		{
			if(!board.monsters[i].dead)
			{
				board.monsters[i].update();
			}
			else
			{
				board.monsters.splice(i, 1);
			}
		}
		spawn();
	}

	public static function spawn():Void
	{
		spawnCounter--;
		if(spawnCounter <= 0)
		{
			board.spawnMonster();
			spawnCounter = spawnRate;
			spawnRate--;
		}
	}

	override public function onKeyDown(keyCode:KeyCode):Void
	{
		player.onKeyDown(keyCode);
		switch (keyCode)
		{
			case R: if(player.dead) State.set('retry');
		default: return;
		}
	}

	override public function onKeyUp(keyCode:KeyCode):Void
	{
		player.onKeyUp(keyCode);
	}

	public static function reset()
	{
		level = 1;
		player.reset();
		startLevel(startingPlayerHp);
	}
}
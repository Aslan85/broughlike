package state;

import utils.UtilFonctions;

import kha.math.Random;
import kha.Canvas;
import kha.input.KeyCode;
import kha.Assets;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.tmx.TiledMap;

import tween.Delta;

import asset.ScoreManager;
import char.Player;
import world.Board;

class PlayState extends State
{
	var _nbColums = 11;
	var _nbRows = 11;
	var _startingPlayerHp = 3;
	var _spawnRate:Int;
	var _spawnCounter:Int;

	public var board:Board;
	public var player:Player;
	public var level:Int = 1;
	public var maxLevel:Int = 6;
	public var score:ScoreManager;
	
	public function new()
	{
		super();
		startLevel(_startingPlayerHp);
		
		score = new ScoreManager(720, 18, 48);
		add(score);
	}

	override public function update()
	{
		super.update();
		player.update();
		score.update();

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

	public function startLevel(hpPlayer:Int):Void
	{
		_spawnRate = 15;
		_spawnCounter = _spawnRate;
	
		// Init board
		board = new Board(_nbRows, _nbColums, this);
		board.generateLevel();

		// Add player
		player = new Player(board.randomPassableTile(), hpPlayer, this);

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

	public function tick():Void
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
		spawnCounter();
	}

	public function spawnCounter():Void
	{
		_spawnCounter--;
		if(_spawnCounter <= 0)
		{
			board.spawnMonster();
			_spawnCounter = _spawnRate;
			_spawnRate--;
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
}
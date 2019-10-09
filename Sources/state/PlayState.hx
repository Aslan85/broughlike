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
	
	public function new()
	{
		super();
		startLevel(_startingPlayerHp);
	}

	override public function update()
	{
		super.update();

		player.update();

		Delta.step(1/60);
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);

		board.render(canvas);
		player.render(canvas);
		for(m in board.monsters)
			m.render(canvas);
	}

	public function startLevel(hpPlayer:Int):Void
	{
		_spawnRate = 15;
		_spawnCounter = _spawnRate;
	
		board = new Board(_nbRows, _nbColums, this);
		board.generateLevel();
		player = new Player(board.randomPassableTile(), hpPlayer, this);
		board.generateMonsters(level);

		var exitTile = board.randomPassableTile();
		board.replaceByExit(exitTile);
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
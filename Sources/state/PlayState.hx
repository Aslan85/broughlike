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

	public static var board:Board;
	public static var player:Player;
	public static var level:Int = 1;
	
	public function new()
	{
		super();
	
		board = new Board(_nbRows, _nbColums);
		board.generateLevel();
		board.generateMonsters(level);

		player = new Player(board.randomPassableTile());
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
	}

	override public function onKeyDown(keyCode:KeyCode):Void
	{
		player.onKeyDown(keyCode);
		switch (keyCode)
		{
			//case F: setRunState();
		default: return;
		}
	}

	override public function onKeyUp(keyCode:KeyCode):Void
	{
		player.onKeyUp(keyCode);
	}
}
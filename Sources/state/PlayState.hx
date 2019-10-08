package state;

import kha.math.Random;
import raccoon.tmx.TiledMap;
import kha.Canvas;
import kha.input.KeyCode;
import kha.Assets;

import raccoon.Raccoon;
import raccoon.State;

import asset.ScoreManager;
import char.Player;
import world.Board;

class PlayState extends State
{
	var _nbColums = 11;
	var _nbRows = 11;

	public static var board:Board;
	public static var player:Player;
	
	public function new()
	{
		super();
	
		board = new Board(_nbRows, _nbColums);
		board.generateLevel();

		var startTile = board.randomPassableTile();
		player = new Player(startTile.row *startTile.tileSize, startTile.column*startTile.tileSize);
	}

	override public function update()
	{
		super.update();

		player.update();	
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);

		board.render(canvas);
		player.render(canvas);
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
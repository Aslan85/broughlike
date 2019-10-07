package state;

import kha.Canvas;
import kha.input.KeyCode;
import kha.Assets;

import raccoon.Raccoon;
import raccoon.State;

import asset.ScoreManager;
import char.Player;

class PlayState extends State
{
	var _tileSize = 64;
	var _numTiles = 9;
	var _uiWidth = 4;
	
	public static var player:Player;

	public function new()
	{
		super();

		player = new Player(Raccoon.BUFFERWIDTH / 2, Raccoon.BUFFERHEIGHT / 2);
	}

	override public function update()
	{
		super.update();

		player.update();	
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);

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
package char;

import kha.Canvas;
import kha.input.KeyCode;
import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;

import world.BoardTile;

class Player extends Monster
{
	public function new(bT:BoardTile)
	{
		super('knight', bT, 3);
		isPlayer = true;
	}

	public function onKeyDown(keyCode:KeyCode):Void
	{
		switch (keyCode)
		{
			case W: tryMove(0, -1);
			case S: tryMove(0, 1);
			case A: tryMove(-1, 0);
			case D: tryMove(1, 0);
		default: return;
		}
	}

	public function onKeyUp(keyCode:KeyCode):Void
	{
		switch (keyCode)
		{
			//case F: flap = false;
		default: return;
		}
	}
}
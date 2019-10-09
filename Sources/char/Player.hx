package char;

import kha.Canvas;
import kha.input.KeyCode;
import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;

import state.PlayState;
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
			case W: tryMove(0, -1); PlayState.tick();
			case S: tryMove(0, 1); PlayState.tick();
			case A: tryMove(-1, 0); PlayState.tick();
			case D: tryMove(1, 0); PlayState.tick();
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
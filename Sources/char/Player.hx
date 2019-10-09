package char;

import kha.Canvas;
import kha.input.KeyCode;

import raccoon.Raccoon;
import raccoon.State;
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
			case W: if(!dead) { tryMove(0, -1); PlayState.tick(); }
			case S: if(!dead) { tryMove(0, 1); PlayState.tick(); }
			case A: if(!dead) { tryMove(-1, 0); PlayState.tick(); }
			case D: if(!dead) { tryMove(1, 0); PlayState.tick(); }
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
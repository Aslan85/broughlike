package char;

import kha.Canvas;
import kha.input.KeyCode;
import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;

class Player extends Sprite
{
	//public var animFlap:Animation;
	public var animIdle:Animation;
	public var animDie:Animation;

	var _playerSize = 64;

	public function new(x:Float, y:Float)
	{
		super('knight', x, y, _playerSize, _playerSize);
		//animWalk = Animation.createRange(0, 2, 4);
		animIdle = Animation.create(0);
		animDie = Animation.create(1);

		reset();
	}

	override public function update()
	{
		super.update();
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
	}

	public function onKeyDown(keyCode:KeyCode):Void
	{
		var x = 0;
		var y = 0;
		switch (keyCode)
		{
			case W: y--;
			case S: y++;
			case A: x--;
			case D: x++;
		default: return;
		}
		position.x += x *_playerSize;
		position.y += y *_playerSize;
	}

	public function onKeyUp(keyCode:KeyCode):Void
	{
		switch (keyCode)
		{
			//case F: flap = false;
		default: return;
		}
	}

	public function reset()
	{
		flip.x = false;
		setAnimation(animIdle);
	}
}
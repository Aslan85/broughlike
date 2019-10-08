package char;

import kha.Canvas;
import kha.input.KeyCode;
import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;

import world.BoardTile;

class Monster extends Sprite
{
	public var hp:Int;
	public var isPlayer:Bool = false;

	var _boardTile:BoardTile;
	var _animIdle:Animation;
	var _animDie:Animation;
	var _spriteSize = 64;

	public function new(sprite:String, bT:BoardTile, h:Int)
	{
		super(sprite, bT.row *_spriteSize, bT.column *_spriteSize, _spriteSize, _spriteSize);
		
		hp = h;
		_boardTile = bT;
		_boardTile.monster = this;

		_animIdle = Animation.create(0);
		_animDie = Animation.create(1);
		setAnimation(_animIdle);
	}

	override public function update()
	{
		super.update();
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
	}

	public function tryMove(dx, dy):Bool
	{
		var newTile = _boardTile.getNeighbor(dx,dy);
        if(newTile.passable)
		{
            if(newTile.monster == null)
			{
            	move(newTile);
            }
			return true;
		}
		return false;
	}

    function move(tile:BoardTile):Void
	{
        _boardTile.monster = null;

        _boardTile = tile;
        _boardTile.monster = this;
		this.position.x = _boardTile.row * _spriteSize;
		this.position.y = _boardTile.column * _spriteSize;
    }
}

class Bird extends Monster
{
	public function new(bT:BoardTile)
	{
		super('bird', bT, 1);
	}
}

class Crow extends Monster
{
	public function new(bT:BoardTile)
	{
		super('crow', bT, 2);
	}
}

class Rat extends Monster
{
	public function new(bT:BoardTile)
	{
		super('rat', bT, 2);
	}
}

class Troll extends Monster
{
	public function new(bT:BoardTile)
	{
		super('troll', bT, 3);
	}
}

class Dragon extends Monster
{
	public function new(bT:BoardTile)
	{
		super('dragon', bT, 3);
	}
}


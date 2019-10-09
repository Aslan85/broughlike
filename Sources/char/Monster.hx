package char;

import kha.Canvas;
import kha.input.KeyCode;
import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;

import state.PlayState;
import world.BoardTile;

class Monster extends Sprite
{
	public var hp:Int;
	public var dead:Bool;
	public var boardTile:BoardTile;
	public var isPlayer:Bool = false;
	
	var _animIdle:Animation;
	var _animDie:Animation;
	var _spriteSize = 64;

	public function new(sprite:String, bT:BoardTile, h:Int)
	{
		super(sprite, bT.row *_spriteSize, bT.column *_spriteSize, _spriteSize, _spriteSize);
		
		hp = h;
		dead = false;
		boardTile = bT;
		boardTile.monster = this;

		_animIdle = Animation.create(0);
		_animDie = Animation.create(1);
		setAnimation(_animIdle);
	}

	override public function update()
	{
		super.update();

		if(!isPlayer)
			doStuff();
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
	}

	function doStuff()
	{
		var neighbors = boardTile.getAdjacentPassableNeighbors();
		neighbors = neighbors.filter(function (t) return (t.monster == null || t.monster.isPlayer));
		if(neighbors.length > 0)
		{
			neighbors.sort(function(a, b) return Std.int(a.dist(PlayState.player.boardTile)) - Std.int(b.dist(PlayState.player.boardTile)));
			var newTile = neighbors[0];
			tryMove(newTile.row - boardTile.row, newTile.column - boardTile.column);
		}
	}

	public function tryMove(dx, dy):Bool
	{
		var newTile = boardTile.getNeighbor(dx,dy);
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
        boardTile.monster = null;

        boardTile = tile;
        boardTile.monster = this;
		this.position.x = boardTile.row * _spriteSize;
		this.position.y = boardTile.column * _spriteSize;
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


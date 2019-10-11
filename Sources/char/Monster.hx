package char;

import kha.Canvas;
import kha.input.KeyCode;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;
import raccoon.tool.Util;

import state.PlayState;
import world.Board;
import world.BoardTile;

class Monster extends Sprite
{
	public var isPlayer:Bool = false;
	public var hp:Float;
	public var dead:Bool = false;
	public var boardTile:BoardTile;
	
	var _playState:PlayState;
	var _maxHp:Float = 6;
	var _animIdle:Animation;
	var _animDie:Animation;
	var _animWarp:Animation;
	var _tileSize = 64;
	var _spriteSize = 16;
	var _lifes = new List<Life>();

	var _attackedThisTurn:Bool = false;
	var _stunned:Bool = false;
	var _warpCounter:Int = 2;

	public function new(sprite:String, bT:BoardTile, h:Int, ps:PlayState)
	{
		super(sprite, bT.row *_tileSize, bT.column *_tileSize, _spriteSize, _spriteSize);
		setScale(4.0, 4.0);

		hp = h;
		dead = false;
		_playState = ps;
		boardTile = bT;
		boardTile.monster = this;

		_animIdle = Animation.create(0);
		_animDie = Animation.create(1);
		setAnimation(_animIdle);
	}

	override public function update()
	{
		super.update();

		_warpCounter--;
		if(_stunned || _warpCounter > 0)
		{
			_stunned = false;
			return;
		}
		else
		{
			if(!dead)
				setAnimation(_animIdle);
		}

		if(!isPlayer)
			doStuff();
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
		if(_warpCounter <= 0) drawHp();
		for(l in _lifes)
			l.render(canvas);
	}

	function drawHp()
	{
		_lifes.clear();
		for(i in 0 ... Std.int(hp))
		{
			var l = new Life((boardTile.row*_tileSize) + (i%3)*(5/16)*_tileSize, (boardTile.column*_tileSize) -Math.floor(i/3)*(5/16)*_tileSize);
			_lifes.add(l);
		}
	}

	public function doStuff():Void
	{
		var neighbors = boardTile.getAdjacentPassableNeighbors();
		neighbors = neighbors.filter(function (t) return (t.monster == null || t.monster.isPlayer));
		if(neighbors.length > 0)
		{
			neighbors.sort(function(a, b) return Std.int(a.dist(_playState.player.boardTile)) - Std.int(b.dist(_playState.player.boardTile)));
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
			else 
			{
				if(isPlayer != newTile.monster.isPlayer)
				{
					_attackedThisTurn = true;
					newTile.monster._stunned = true;
					newTile.monster.hit(1);
				}
			}
			return true;
		}
		return false;
	}

	public function heal(value:Float):Void
	{
		hp = Math.min(_maxHp, hp+value);
	}

	public function hit(damage:Float):Void
	{
		if(_warpCounter > 0)
			return;

		hp -= damage;
		if(hp <= 0)
			die();
	}

	function die():Void
	{
		dead = true;
		if(!isPlayer) boardTile.monster = null;
		setAnimation(_animDie);
	}

    function move(tile:BoardTile):Void
	{
        boardTile.monster = null;

        boardTile = tile;
        boardTile.monster = this;
		this.position.x = boardTile.row * _tileSize;
		this.position.y = boardTile.column * _tileSize;

		stepOn();
    }

	function stepOn():Void
	{
		if(isPlayer)
		{
			if(boardTile.isExit)
			{
				if(_playState.level == _playState.maxLevel)
				{
					State.set('win');
				}
				else
				{
					_playState.level++;
					_playState.startLevel(Std.int(Math.min(_maxHp, hp+1)));
				}
			}
			if(boardTile.isTreasure)
			{
				_playState.score.up(1);
				_playState.board.replaceByFloor(boardTile);
			}
		}
	}
}

class Bird extends Monster
{
	public function new(bT:BoardTile, ps:PlayState)
	{
		super('bird', bT, 1, ps);
	}
}

class Crow extends Monster
{
	public function new(bT:BoardTile, ps:PlayState)
	{
		super('crow', bT, 2, ps);
	}

	override public function doStuff():Void
	{
		_attackedThisTurn = false;
		super.doStuff();

		if(!_attackedThisTurn)
			super.doStuff();
	}
}

class Rat extends Monster
{
	public function new(bT:BoardTile, ps:PlayState)
	{
		super('rat', bT, 2, ps);
	}

	override public function doStuff():Void
	{
		var neighbors = boardTile.getAdjacentPassableNeighbors();
		if(neighbors.length > 0)
		{
			var r = Util.randomInt(neighbors.length);
			tryMove(neighbors[r].row - boardTile.row, neighbors[r].column - boardTile.column);
		}
	}
}

class Troll extends Monster
{
	public function new(bT:BoardTile, ps:PlayState)
	{
		super('troll', bT, 3, ps);
	}

	override public function update()
	{
		var startStunned = _stunned;
		super.update();

		if(!startStunned)
		{
			_stunned = true;
		}
	}
}

class Dragon extends Monster
{
	public function new(bT:BoardTile, ps:PlayState)
	{
		super('dragon', bT, 3, ps);
	}

	override public function doStuff():Void
	{
		var neighbors = boardTile.getAdjacentNeighbors().filter(function (t) return !t.passable && _playState.board.inBounds(t.row, t.column));
		if(neighbors.length > 0)
		{
			_playState.board.replaceByFloor(neighbors[0]);
			heal(0.5);
		}
		else 
		{
			super.doStuff();
		}
	}
}

class Life extends  Sprite
{
	public function new(x:Float, y:Float)
	{
		super('life', x, y, 64, 64);
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
	}
}


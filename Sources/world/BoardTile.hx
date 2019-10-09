package world;

import kha.Canvas;
import kha.input.KeyCode;

import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;

import state.PlayState;
import char.Monster;

class BoardTile extends Sprite
{
	public var tileSize = 64;
	public var row:Int;
	public var column:Int;
	public var passable:Bool;
	public var monster:Monster;
	var _attachedBoard:Board;

	public function new(sprite:String, b:Board, x:Int, y:Int, p:Bool)
	{
		super(sprite, x*tileSize, y*tileSize, tileSize, tileSize);

		_attachedBoard = b;
		row = x;
		column = y;
		passable = p;
	}

	override public function update()
	{
		super.update();
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
	}

	public function dist(other:BoardTile):Float
	{
        return Math.abs(row-other.row) + Math.abs(column-other.column);
    }

	public function getNeighbor(dx, dy):BoardTile
	{
		return _attachedBoard.getTile(row+dx, column+dy);
	}

	function getAdjacentNeighbors():Array<BoardTile>
	{
		var adjacentTiles = new Array<BoardTile>();
		adjacentTiles = [getNeighbor(0, -1), getNeighbor(0, 1), getNeighbor(-1, 0), getNeighbor(1, 0)];
		return adjacentTiles;
	}

	public function getAdjacentPassableNeighbors():Array<BoardTile>
	{
		return getAdjacentNeighbors().filter(function (t) return t.passable);
	}

	public function getAdjacentNonPassableNeighbors():Array<BoardTile>
	{
		return getAdjacentNeighbors().filter(function (t) return !t.passable && PlayState.board.inBounds(t.row, t.column));
	}

	public function getConnectedTiles():Array<BoardTile>
	{
		var connectedTiles = [this];
		var frontier = [this];

		while(frontier.length > 0)
		{
			var neighbors = frontier.pop()
							.getAdjacentPassableNeighbors();
			
			for(element in connectedTiles)
			{
				var i = neighbors.length;
				while(--i >= 0)
					if(neighbors[i] == element) neighbors.splice(i, 1);
			}

			connectedTiles = connectedTiles.concat(neighbors);
			frontier = frontier.concat(neighbors);
		}
		return connectedTiles;
	}
}

class Floor extends BoardTile
{
	public function new(b:Board, x:Int, y:Int)
	{
		super('floorTile', b, x, y, true);
	}
}

class Wall extends BoardTile
{
	public function new(b:Board, x:Int, y:Int)
	{
		super('wallTile', b, x, y, false);
	}
}
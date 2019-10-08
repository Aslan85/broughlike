package world;

import raccoon.Object;
import kha.Canvas;
import kha.input.KeyCode;

import raccoon.Raccoon;
import raccoon.anim.Sprite;
import raccoon.anim.Animation;
import raccoon.tool.Util;

import world.BoardTile;

class Board extends Object
{
	var _nbRows:Int;
	var _nbColums:Int;
	var _tiles = new Array<Array<BoardTile>>();

	public function new(rows:Int, colums:Int)
	{
		super();
		_nbRows = rows;
		_nbColums = colums;
	}

	override public function update()
	{
		super.update();
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
		for (i in 0..._nbRows) 
			for (j in 0..._nbColums)
			{
				getTile(i, j).render(canvas);
			}
	}

	public function generateLevel():Void
	{	
		var b = 0;
		do
		{
			b = generateTiles();
		} while(b != randomPassableTile().getConnectedTiles().length);
	}

	function generateTiles():Int
	{
		var passableTiles = 0;
		for (i in 0..._nbRows) { _tiles[i] = []; _tiles[i][_nbColums] = null; }
		for (i in 0..._nbRows)
		{
			for (j in 0..._nbColums)
			{
				if(Util.randomFloat(1) < 0.3  || !inBounds(i,j))
				{
					_tiles[i][j] = new Wall(this, i, j);
				}
				else
				{
					_tiles[i][j] = new Floor(this, i, j);
					passableTiles++;	
				}
			}
		}
		return passableTiles;
	}

	function inBounds(x:Int, y:Int):Bool
	{
		return x>0 && y>0 && x < _nbRows-1 && y < _nbColums-1;
	}

	public function getTile(x:Int, y:Int):BoardTile
	{
		if(inBounds(x,y))
			return _tiles[x][y];
    	else
			return new Wall(this, x, y);
	}

	public function randomPassableTile():BoardTile
	{
		var t:BoardTile;
		do
		{
			t = getTile(Util.randomInt(_nbRows), Util.randomInt(_nbColums));
		} while(!t.passable && !t.monster);
			
		return t;
	}	
}
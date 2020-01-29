package;

import flixel.FlxG;
import Tile.Wall;
import Tile.Floor;

class Level
{
    public var tiles = new Array<Array<Tile>>();

    public function new()
    {
        generateLevel();
    }

    function generateLevel():Void
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
        for (i in 0...Const.NUMTILES) { tiles[i] = []; tiles[i][Const.NUMTILES] = null; }
		for (i in 0...Const.NUMTILES)
		{
			for (j in 0...Const.NUMTILES)
			{
				if(FlxG.random.float() < 0.3 || !inBounds(i, j))
				{
					tiles[i][j] = new Wall(i, j, this);
				}
				else
				{
                    tiles[i][j] = new Floor(i, j, this);
                    passableTiles++;
				}
			}
		}
		return passableTiles;
    }

	public function inBounds(x:Int, y:Int):Bool
	{
		return x>0 && y>0 && x < Const.NUMTILES-1 && y < Const.NUMTILES-1;
	}

	public function getTile(x:Int, y:Int):Tile
	{
		if(inBounds(x,y))
			return tiles[x][y];
    	else
			return new Wall(x, y, this);
    }

	public function randomPassableTile():Tile
	{
		var t:Tile;
		do
		{
			t = getTile(FlxG.random.int(0, Const.NUMTILES), FlxG.random.int(0, Const.NUMTILES));
		} while(!t.passable || t.monster != null);
			
		return t;
	}
}

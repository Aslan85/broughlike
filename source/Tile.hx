package;

import flixel.FlxSprite;

class Tile extends FlxSprite
{
    public var passable = false;
    public var monster:Monster = null;
	public var level:Level;

    public var _row:Int;
	public var _column:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?path:String=AssetPaths.floor__png, ?p:Bool=false, ?l:Level)
    {
        super(X*Const.TILESIZE, Y*Const.TILESIZE);
        
        passable = p;
        level = l;

        _row = Std.int(X);
        _column = Std.int(Y);
        
        loadGraphic(path, true, Const.TILESIZE, Const.TILESIZE);
    }

    //manhattan distance
	public function dist(other:Tile):Float
    {
        return Math.abs(_row-other._row) + Math.abs(_column-other._column);
    }
    

	public function getNeighbor(dx:Int, dy:Int):Tile
	{
		return level.getTile(this._row + dx, this._column + dy);
	}

	function getAdjacentNeighbors():Array<Tile>
	{
		var adjacentTiles = new Array<Tile>();
		adjacentTiles = [getNeighbor(0, -1), getNeighbor(0, 1), getNeighbor(-1, 0), getNeighbor(1, 0)];
		return adjacentTiles;
	}

	public function getAdjacentPassableNeighbors():Array<Tile>
	{
		return getAdjacentNeighbors().filter(function (t) return t.passable);
	}

    public function getConnectedTiles():Array<Tile>
    {
        var connectedTiles = [this];
        var frontier = [this];

        while(frontier.length > 0)
        {
            var neighbors = frontier.pop().getAdjacentPassableNeighbors();
            
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

class Floor extends Tile
{
    public function new(?X:Float=0, ?Y:Float=0, ?level:Level)
    {
        super(X, Y, AssetPaths.floor__png, true, level);
    }
}

class Wall extends Tile
{
    public function new(?X:Float=0, ?Y:Float=0, ?level:Level)
    {
        super(X, Y, AssetPaths.wall__png, false, level);
    }
}
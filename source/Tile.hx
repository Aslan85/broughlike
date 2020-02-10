package;

import flixel.FlxG;
import flixel.FlxSprite;

class Tile extends FlxSprite
{
    public var passable = false;
    public var monster:Monster = null;
    public var hasTreasure:Treasure = null;
    public var level:Level;
    public var row:Int;
	public var column:Int;

    public function new(?X:Float=0, ?Y:Float=0, ?path:String=AssetPaths.floor__png, ?p:Bool=false, ?l:Level)
    {
        super(X*Const.TILESIZE, Y*Const.TILESIZE);
        
        passable = p;
        level = l;

        row = Std.int(X);
        column = Std.int(Y);
        
        loadGraphic(path, true, Const.TILESIZE, Const.TILESIZE);
    }

    public function stepOn(monster:Monster):Void
    {
    }

    //manhattan distance
	public function dist(other:Tile):Float
    {
        return Math.abs(row-other.row) + Math.abs(column-other.column);
    }
    
	public function getNeighbor(dx:Int, dy:Int):Tile
	{
		return level.getTile(this.row + dx, this.column + dy);
	}

	public function getAdjacentNeighbors():Array<Tile>
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

    override function stepOn(monster:Monster):Void
    {
        if(monster.isPlayer)
        {
            if(hasTreasure != null)
            {
                hasTreasure.kill();
                hasTreasure = null;

                level.spawnMonster();

                level.playState.addScore(Const.POINTSBYTREASURE);
            }
        }
    }
}

class Wall extends Tile
{
    public function new(?X:Float=0, ?Y:Float=0, ?level:Level)
    {
        super(X, Y, AssetPaths.wall__png, false, level);
    }
}

class Exit extends Tile
{
    public function new(?X:Float=0, ?Y:Float=0, ?level:Level)
    {
        super(X, Y, AssetPaths.exit__png, true, level);
    }

    override function stepOn(monster:Monster):Void
    {
        if(monster.isPlayer)
        {
            if(level.playState.difficulty == Const.MAXLEVELS)
            {
                // Return to home title
                // TODO : Game End Screen
                FlxG.switchState(new MenuState());
            }
            else
            {
                // Increase level
                level.playState.addLevel();
                level.playState.addScore(Const.POINTSBYLEVELING);
                var lifeUp:Float = Math.min(Const.MAXHP, monster.hp +1);
                level.playState.startLevel(lifeUp);
            }
        }
    }
}
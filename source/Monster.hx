package;

import flixel.FlxSprite;

class Monster extends FlxSprite
{
    var _hp:Int;
    var _isDead = false;
    var _tile:Tile;
    var _isPlayer = false;

    public function new(?path:String=AssetPaths.floor__png, ?tile:Tile, ?hp:Int=1, ?player = false)
    {
        _hp = hp;
        _tile = tile;
        _isPlayer = player;
        move(_tile);
        super(_tile.x, _tile.y);

        loadGraphic(path, true, Const.TILESIZE, Const.TILESIZE);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    public function aiMove()
    {
        if(!_isPlayer)
            doStuff();
    }

	function doStuff():Void
	{
		var neighbors = _tile.getAdjacentPassableNeighbors();
        neighbors = neighbors.filter(function (t) return (t.monster == null || t.monster._isPlayer));
        var playerTile = getPlayerTile();
        if(neighbors.length > 0 && playerTile != null)
		{
			neighbors.sort(function(a, b) return Std.int(a.dist(playerTile)) - Std.int(b.dist(playerTile)));
			var newTile = neighbors[0];
			tryMove(newTile._row - _tile._row, newTile._column - _tile._column);
		}
    }
    
    function getPlayerTile():Tile
    {
        if(_tile.level.player != null)
            return _tile.level.player._tile;
        else
            return null;
    }

    function tryMove(dx:Int, dy:Int):Bool
    {
        var newTile = _tile.getNeighbor(dx, dy);
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

    function move(tile:Tile):Void
    {
        if(_tile != null)
        {
            _tile.monster = null;
        }
        _tile = tile;
        tile.monster = this;

        x = _tile.x;
        y = _tile.y;
    }

	function tick()
	{
		var total = _tile.level.monsters.length;
		var i = total;
		while(i >= 0)
		{
            if(_tile.level.monsters[i] != null)
            {
                if(!_tile.level.monsters[i]._isDead)
				    _tile.level.monsters[i].aiMove();
			    else
				    _tile.level.monsters.splice(i, 1);
            }
			i --;
		}
	}
}

class Bird extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.bird__png, tile, 3);
    }
}

class Snake extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.snake__png, tile, 1);
    }
}

class Blobby extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.blobby__png, tile, 2);
    }
}

class Eater extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.eater__png, tile, 1);
    }
}

class Jester extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.jester__png, tile, 2);
    }
}
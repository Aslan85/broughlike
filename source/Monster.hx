package;

import flixel.FlxSprite;

class Monster extends FlxSprite
{
    var _hp:Int;
    var _tile:Tile;

    public function new(?path:String=AssetPaths.floor__png, ?tile:Tile, ?hp:Int=1)
    {
        _hp = hp;
        _tile = tile;
        super(_tile.x, _tile.y);

        loadGraphic(path, true, Const.TILESIZE, Const.TILESIZE);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
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
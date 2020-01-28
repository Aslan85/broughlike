package;

import flixel.FlxSprite;

class Tile extends FlxSprite
{
    public var passable = false;

    var _spriteSize = Const.TILESIZE;

    public function new(?X:Float=0, ?Y:Float=0, ?path:String=AssetPaths.floor__png, ?passable:Bool=false)
    {
        super(X, Y);

        this.passable = passable;
        loadGraphic(path, true, _spriteSize, _spriteSize);
    }
}

class Floor extends Tile
{
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y, AssetPaths.floor__png, true);
    }
}

class Wall extends Tile
{
    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y, AssetPaths.wall__png, false);
    }
}
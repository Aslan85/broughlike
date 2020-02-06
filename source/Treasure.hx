package;

import flixel.FlxSprite;

class Treasure extends FlxSprite
{
    public function new(?tile:Tile)
    {
        super(tile.x, tile.y);

        loadGraphic(AssetPaths.treasure__png, true, Const.TILESIZE, Const.TILESIZE);
    }
}
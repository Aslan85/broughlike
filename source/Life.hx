package;

import flixel.FlxSprite;

class Life extends FlxSprite
{
    var _lifePos:Int;
    var _target:Monster;

    public function new(?target:Monster, ?pos:Int=0)
    {
        _lifePos = pos;
        _target = target;
        super(x, y);

        loadGraphic(AssetPaths.life__png, true, Const.TILESIZE, Const.TILESIZE);
    }

    override public function update(elapsed:Float):Void
    {
        x = _target.x + (_lifePos%3)*(5/Const.TILESIZE)*Const.TILESIZE;
        y = _target.y - Math.floor(_lifePos/3)*(5/Const.TILESIZE)*Const.TILESIZE;

        super.update(elapsed);
    }
}
package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
    var _spriteSize = Const.TILESIZE;

    public function new(?X:Float=0, ?Y:Float=0)
    {
        super(X, Y);

        loadGraphic(AssetPaths.player__png, true, _spriteSize, _spriteSize);
    }

    override public function update(elapsed:Float):Void
    {
        movement();

        super.update(elapsed);
    }

    function movement():Void
    {
        if(FlxG.keys.anyJustPressed([UP,W]))
        {
            if(y > 0)
                y -= _spriteSize;
        } 
        if(FlxG.keys.anyJustPressed([DOWN,S]))
        {
            if(y < Const.TILESIZE*(Const.NUMTILES-1))
                y += _spriteSize;
        } 
        if(FlxG.keys.anyJustPressed([LEFT,A]))
        {
            if(x > 0)
                x -= _spriteSize;
        } 
        if(FlxG.keys.anyJustPressed([RIGHT,D]))
        {
            if(x < Const.TILESIZE*(Const.NUMTILES-1))
                x += _spriteSize;
        } 
    }
}
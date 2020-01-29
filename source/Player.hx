package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.player__png, tile, 1);
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
            tryMove(0, -1);
        } 
        if(FlxG.keys.anyJustPressed([DOWN,S]))
        {
            tryMove(0, 1);
        } 
        if(FlxG.keys.anyJustPressed([LEFT,A]))
        {
            tryMove(-1, 0);
        } 
        if(FlxG.keys.anyJustPressed([RIGHT,D]))
        {
            tryMove(1, 0);
        } 
    }
}
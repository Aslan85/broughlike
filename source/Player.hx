package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends Monster
{
    public function new(?tile:Tile)
    {
        super(AssetPaths.player__png, tile, 1, true);
    }

    override public function update(elapsed:Float):Void
    {
        movement();

        super.update(elapsed);
    }

    function movement():Void
    {
        var didMove = false;
        if(FlxG.keys.anyJustPressed([UP,W]))
        {
            didMove = tryMove(0, -1);
        } 
        if(FlxG.keys.anyJustPressed([DOWN,S]))
        {
            didMove = tryMove(0, 1);
        } 
        if(FlxG.keys.anyJustPressed([LEFT,A]))
        {
            didMove = tryMove(-1, 0);
        } 
        if(FlxG.keys.anyJustPressed([RIGHT,D]))
        {
            didMove = tryMove(1, 0);
        }

        if(didMove)
            tick();
    }
}
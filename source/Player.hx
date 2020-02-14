package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends Monster
{
    public function new(?tile:Tile, ?life:Float)
    {
        super(AssetPaths.player__png, tile, life, true);
    }

    override public function update(elapsed:Float):Void
    {
        if(!_isDead && _tile.level.playerTurn)
            movement();

        super.update(elapsed);
    }

    function movement():Void
    {
        if(FlxG.keys.anyJustPressed([UP,W]))
        {
            tryMove(0, -1, function(){ tick(); });
        } 
        if(FlxG.keys.anyJustPressed([DOWN,S]))
        {
            tryMove(0, 1, function(){ tick(); });
        } 
        if(FlxG.keys.anyJustPressed([LEFT,A]))
        {
            tryMove(-1, 0, function(){ tick(); });
        } 
        if(FlxG.keys.anyJustPressed([RIGHT,D]))
        {
            tryMove(1, 0, function(){ tick(); });
        }
    }
}
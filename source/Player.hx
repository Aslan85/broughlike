package;

import flixel.FlxG;

class Player extends Monster
{
    public function new(?tile:Tile, ?life:Float)
    {
        super(AssetPaths.player__png, tile, life, true);
        
        addSpell();
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

        if(FlxG.keys.anyJustPressed([ONE,TWO,THREE,FOUR,FIVE,SIX,SEVEN,EIGHT,NINE]))
        {
            var idx = FlxG.keys.firstJustPressed() - 49;
            if(idx < spells.length)
                castSpell(idx, function(){ tick(); });
            else
                return;

            _tile.level.playState.updateSpellsHud();
        }
    }
}
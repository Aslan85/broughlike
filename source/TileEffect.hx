package;

import flixel.FlxSprite;
import Enums.EffectName;

class TileEffect extends FlxSprite
{
    var lifeTimer:Float;
    var originTimer:Float;

    public function new(effectName:EffectName, tile:Tile, time:Float)
    {
        lifeTimer = time;
        originTimer = lifeTimer;

        super(tile.x, tile.y);

        var path:String;
        switch(effectName)
        {
            case EffectName.heal : path = AssetPaths.healEffect__png;
            case EffectName.explosion : path = AssetPaths.explosionEffect__png;
            case EffectName.hBoltEffect : path = AssetPaths.hBoltEffect__png;
            case EffectName.vBoltEffect : path = AssetPaths.vBoltEffect__png;
        }
        loadGraphic(path, true, Const.TILESIZE, Const.TILESIZE);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);

        lifeTimer--;
        this.alpha = lifeTimer/originTimer;
        if(lifeTimer < 0)
            this.kill();
    }
}
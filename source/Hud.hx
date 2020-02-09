package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Hud extends FlxTypedGroup<FlxSprite>
{
    var _txtDifficulty:FlxText;
    var _txtScore:FlxText;

    public function new()
    {
        super();

        var xPos:Float = Const.NUMTILES * Const.TILESIZE;

        _txtDifficulty = new FlxText(xPos, 0, 0, "Level : 1", 8);
        _txtDifficulty.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        add(_txtDifficulty);

        _txtScore = new FlxText(xPos, 10, 0, "Score : 0", 8);
        _txtScore.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        add(_txtScore);
    }

    public function updateHUD(difficulty:Int = 0, score:Int = 0):Void
    {
        _txtDifficulty.text = "Level : " +Std.string(difficulty);
        _txtScore.text = "Score : " +Std.string(score);
    }
}
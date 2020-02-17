package;

import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class Hud extends FlxTypedGroup<FlxSprite>
{
    var _xPos:Float;
    var _txtDifficulty:FlxText;
    var _txtScore:FlxText;
    var _txtSpells:Array<FlxText>;

    public function new()
    {
        super();

        _xPos = Const.NUMTILES * Const.TILESIZE;

        _txtDifficulty = new FlxText(_xPos, 0, 0, "Level : 1", 8);
        _txtDifficulty.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        add(_txtDifficulty);

        _txtScore = new FlxText(_xPos, 10, 0, "Score : 0", 8);
        _txtScore.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        add(_txtScore);
    }

    public function updateHUD(difficulty:Int = 0, score:Int = 0):Void
    {
        _txtDifficulty.text = "Level : " +Std.string(difficulty);
        _txtScore.text = "Score : " +Std.string(score);
    }

    public function updateSpellsHUD(spells:Array<Enums.SpellName>):Void
    {
        if(_txtSpells != null)
        {
            for(i in 0 ... _txtSpells.length)
            {
                _txtSpells[i].kill();
            }
            _txtSpells = [];
        }
        
        _txtSpells = new Array<FlxText>();
        for(i in 0 ... spells.length)
        {
            _txtSpells[i] = new FlxText(_xPos, 30 + 10*i, 0, "" +(i+1) +" : " +spells[i], 6);
            add(_txtSpells[i]);
        } 
    }
}
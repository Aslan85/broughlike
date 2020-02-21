package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import flixel.effects.FlxFlicker;
import haxe.Serializer;
import haxe.Unserializer;

class GameOverHud extends FlxTypedGroup<FlxSprite>
{	
    public function new()
    {
        super();

        var _sprBack = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        _sprBack.alpha = 0.75;
		_sprBack.screenCenter();
        add(_sprBack);

        var _txtTitle = new FlxText(0, 10, 0, "Game Over", 16);
        _txtTitle.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(X);
        add(_txtTitle);
        

        var _txtRestart = new FlxText(0, 0, 0, "Press 'R' to restart", 8);
        _txtRestart.alignment = CENTER;
        _txtRestart.screenCenter(X);
        _txtRestart.y = FlxG.height - _txtRestart.height;
        FlxFlicker.flicker(_txtRestart, 0, 0.5);
        add(_txtRestart);

        active = false;
        visible = false;
    }

    public function showGameOver():Void
    {
        drawScores();
        var timer:FlxTimer = new FlxTimer();
        timer.start(2, function(_){ visible = true; });
    }

    function drawScores():Void
    {
        var scores:Array<UserSaveData> = getScore();
        if(scores != null)
        {
            var _txtScoresTitle = new FlxText(0, 40, 0, rightPad(["RUN", "SCORE", "TOTAL"]), 8);
            _txtScoresTitle.alignment = CENTER;
            _txtScoresTitle.screenCenter(X);
            add(_txtScoresTitle);

            var newestScore = scores.pop();
            scores.sort(function(a, b) return b.totalScore - a.totalScore);
            scores.unshift(newestScore);

            var minScores = FlxMath.minInt(Const.SHOWMAXSCORES, scores.length);
            for(i in 0 ... minScores)
            {
                var _txtScore = new FlxText(0, 50+i*10, 0, rightPad([""+scores[i].run, ""+scores[i].score, ""+scores[i].totalScore]), 8);
                _txtScore.alignment = CENTER;
                _txtScore.screenCenter(X);
                if(i == 0)
                    _txtScore.color = FlxColor.MAGENTA;
                add(_txtScore);
            }
        }
    }

    function rightPad(textArray:Array<String>):String
    {
        var _finalText:String = "";
        for (text in textArray)
        {
            text += "";
            var txtSixe:Int = Math.round((10 - text.length)/2);
            for(i in 0...txtSixe)
            {
                var oldText = text;
                text = " "+oldText;
            }
            for(i in 0...txtSixe)
            {
                text += " ";
            }
            _finalText += text;
        }
        return _finalText;
    }
    
    public function addScore(score:Int, won:Bool):Void
    {
        var scores:Array<UserSaveData> = getScore();
        var scoreObject:UserSaveData = new UserSaveData(score, 1, score, won);
        var lastScore:UserSaveData = null;
        if(scores != null)
        {
            lastScore = scores.pop();
        }

        if(lastScore != null)
        {
            if(lastScore.active)
            {
                scoreObject.run += lastScore.run;
                scoreObject.totalScore += lastScore.totalScore;
            }
            else
            {
                scores.push(lastScore);
            }
        }
        scores.push(scoreObject);

        var serializer = new Serializer();
        serializer.serialize(scores);
        var s = serializer.toString();
        
        var _save:FlxSave = new FlxSave();
        _save.bind("broughlike");
        _save.data.scores = s;
        _save.close();
    }

    function getScore():Array<UserSaveData> 
    {
        var _save:FlxSave = new FlxSave();
        if (_save.bind("broughlike"))
        {
            if (_save.data.scores != null)
            {
                var unserializer = new Unserializer(_save.data.scores);
                return unserializer.unserialize();
            }
        }
        return new Array<UserSaveData>();
    }
}

class UserSaveData
{
    public var score:Int;
    public var run:Int;
    public var totalScore:Int;
    public var active:Bool;

    public function new(score, run, totalScore, active)
    {
        this.score = score;
        this.run = run;
        this.totalScore = totalScore;
        this.active = active;
    }
}
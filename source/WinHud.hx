package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.ui.FlxButton;

class WinHud extends FlxTypedGroup<FlxSprite>
{	
    public function new()
    {
        super();

        var _sprBack = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        _sprBack.alpha = 0.75;
		_sprBack.screenCenter();
        add(_sprBack);

        var _txtTitle = new FlxText(0, 20, 0, "Congratulations!!", 18);
        _txtTitle.color = FlxColor.YELLOW;
        _txtTitle.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(X);
        add(_txtTitle);
    
        var _txtSubTitle = new FlxText(0, 56, 0, "You are finished this run\nPress continue\nto reach your best score", 8);
        _txtSubTitle.alignment = CENTER;
        _txtSubTitle.screenCenter();
        add(_txtSubTitle);

        // Continue Button
        var _btnContinue = new FlxButton(0, 0, "Continue", clickContinue);
        _btnContinue.screenCenter(X);
        _btnContinue.y = FlxG.height - _btnContinue.height - 20;
        add(_btnContinue);

        visible = false;
    }
    
    function clickContinue()
    {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
        {
            FlxG.switchState(new PlayState());
        });
    }

    public function showWin():Void
    {
        var timer:FlxTimer = new FlxTimer();
        timer.start(1, function(_){ visible = true; });
    }
}
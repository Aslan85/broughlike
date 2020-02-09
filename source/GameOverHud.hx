package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class GameOverHud extends FlxTypedGroup<FlxSprite>
{	
    var _sprBack:FlxSprite;
    var _txtTitle:FlxText;

    public function new()
    {
        super();

        _sprBack = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        _sprBack.alpha = 0.75;
		_sprBack.screenCenter();
        add(_sprBack);

        _txtTitle = new FlxText(20, 0, 0, "Game Over", 16);
        _txtTitle.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter();
        add(_txtTitle);

        active = false;
        visible = false;
    }

    public function showGameOver():Void
    {
        visible = true;
    }
}
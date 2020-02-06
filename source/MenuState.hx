package;

import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;

class MenuState extends FlxState
{
    var _txtTitle:FlxText;
    var _btnPlay:FlxButton;

	override public function create():Void
	{
        // Title
        _txtTitle = new FlxText(20, 0, 0, "BroughLike", 22);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(X);
        add(_txtTitle);

        // Play Button
        _btnPlay = new FlxButton(0, 0, "Play", clickPlay);
        _btnPlay.screenCenter(X);
        _btnPlay.y = FlxG.height - _btnPlay.height - 10;
        add(_btnPlay);

		super.create();
    }
    
    function clickPlay()
    {
        FlxG.switchState(new PlayState());
    }
}

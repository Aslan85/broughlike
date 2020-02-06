package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
    var _txtTitle:FlxText;
    var _btnPlay:FlxButton;

	override public function create():Void
	{
		// Color background camera
        FlxG.camera.bgColor = FlxColor.fromRGB(68, 71, 89);
        
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

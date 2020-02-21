package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

class MenuState extends FlxState
{
	override public function create():Void
	{
		// Color background camera
        FlxG.camera.bgColor = FlxColor.fromRGB(68, 71, 89);
        
        // Title
        var _txtTitle = new FlxText(0, 24, 0, "Super\nBrough Bros.", 16);
        _txtTitle.setBorderStyle(SHADOW, FlxColor.GRAY, 1, 1);
        _txtTitle.alignment = CENTER;
        _txtTitle.screenCenter(X);
        add(_txtTitle);

        // Play Button
        var _btnPlay = new FlxButton(0, 0, "Play", clickPlay);
        _btnPlay.screenCenter(X);
        _btnPlay.y = FlxG.height - _btnPlay.height - 20;
        add(_btnPlay);

        // Comments
        var _txtComment = new FlxText(0, 20, 0, "Brouglike tutorial in Haxeflixel", 8);
        _txtComment.alignment = CENTER;
        _txtComment.screenCenter(X);
        _txtComment.y = FlxG.height - _txtComment.height;
        add(_txtComment);

		super.create();
    }
    
    function clickPlay()
    {
        FlxG.camera.fade(FlxColor.BLACK, .33, false, function()
        {
            FlxG.switchState(new PlayState());
        });
    }
}

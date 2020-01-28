package;

import flixel.ui.FlxButton;
import flixel.FlxG;
import flixel.FlxState;

class MenuState extends FlxState
{
    var _btnPlay:FlxButton;

	override public function create():Void
	{
        _btnPlay = new FlxButton(0, 0, "Play", clickPlay);
        _btnPlay.screenCenter();
        add(_btnPlay);

		super.create();
    }
    
    function clickPlay()
    {
        FlxG.switchState(new PlayState());
    }
}

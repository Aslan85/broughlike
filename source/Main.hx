package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		addChild(new FlxGame(Const.TILESIZE*(Const.NUMTILES+Const.UIWIDTH), Const.TILESIZE*Const.NUMTILES, MenuState));
	}
}

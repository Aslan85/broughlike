package;

import raccoon.Raccoon;
import kha.Color;

class Main
{
	public static function main()
	{
		Raccoon.setup({app:Project, title:'BroughLike', width:1280, height: 720, backgroundcolor: Color.fromString('#2b0082'), fps: 60});
	}
}
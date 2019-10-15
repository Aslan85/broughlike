package state;

import kha.Canvas;
import kha.Color;
import kha.Assets;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.Texture;
import raccoon.ui.ButtonText;
import raccoon.ui.Text;
import raccoon.audio.Sfx;

class RetryState extends State
{
	var _btnRetry:ButtonText;
	var _btnQuit:ButtonText;
	var _txtGameOver:Text;
	var _txtScore:Text;

	public function new()
	{
		super();

		_btnRetry = new ButtonText('_8bit', 'RETRY', 0, Raccoon.BUFFERHEIGHT -256, 36);
		_btnRetry.position.x = Raccoon.BUFFERWIDTH / 2 - _btnRetry.width / 2 -100;
		_btnRetry.colorOn = Color.fromFloats(0.8, 0.8, 0.8);
		_btnRetry.colorOff = Color.fromFloats(0.3, 0.3, 0.3);
		_btnRetry.onClick = setPlayState;
		add(_btnRetry);

		_btnQuit = new ButtonText('_8bit', 'QUIT', 0, Raccoon.BUFFERHEIGHT -256, 36);
		_btnQuit.position.x = Raccoon.BUFFERWIDTH / 2 - _btnQuit.width / 2 +100;
		_btnQuit.colorOn = Color.fromFloats(0.8, 0.8, 0.8);
		_btnQuit.colorOff = Color.fromFloats(0.3, 0.3, 0.3);
		_btnQuit.onClick = setMenuState;
		add(_btnQuit);

		_txtGameOver = new Text('_8bit', 'GAME OVER', 0, 24, 48);
		_txtGameOver.position.x = Raccoon.BUFFERWIDTH /2 - _txtGameOver.width /2;
		add(_txtGameOver);

		_txtScore = new Text('_8bit', 'Score: ' +PlayState.score.score, 0, 256, 36);
		_txtScore.position.x = Raccoon.BUFFERWIDTH /2 - _txtScore.width /2;
		add(_txtScore);
	}

	override public function update()
	{
		super.update();

		_txtScore.string = 'Score: ' +PlayState.score.score;
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
	}

	override public function onMouseDown(button:Int, x:Int, y:Int)
	{
		if(button == 0)
		{
			_btnRetry.onButtonDown(x, y);
			_btnQuit.onButtonDown(x, y);
		}
	}

	function setPlayState()
	{
		PlayState.score.reset();
		PlayState.reset();
		State.set('play');
	}

	function setMenuState()
	{
		PlayState.score.reset();
		PlayState.reset();
		State.set('menu');
	}
}
package state;

import kha.graphics2.truetype.StbTruetype.Stbtt__point;
import kha.Canvas;
import kha.Color;
import kha.Assets;
import kha.audio1.Audio;
import kha.audio1.AudioChannel;

import raccoon.Raccoon;
import raccoon.State;
import raccoon.ui.Text;
import raccoon.ui.ButtonText;
import raccoon.ui.ToggleText;
import raccoon.Texture;
import raccoon.audio.Sfx;

import tween.Delta;
import tween.easing.Sine;
import tween.easing.Bounce;

class MenuState extends State
{
	var _txtHeader:Text;
	var _txtWebsite:Text;
	var _btnPlay:ButtonText;

	public function new()
	{
		super();

		_txtHeader = new Text('_8bit', 'Brough Like', 0, -42, 72);
		_txtHeader.position.x = Raccoon.BUFFERWIDTH / 2 - _txtHeader.width / 2;
		add(_txtHeader);

		_txtWebsite = new Text('_8bit', 'ChickenMelody.com', 0, Raccoon.BUFFERHEIGHT - 24, 16);
		_txtWebsite.position.x = Raccoon.BUFFERWIDTH / 2 - _txtWebsite.width / 2;
		add(_txtWebsite);

		_btnPlay = new ButtonText('_8bit', 'PLAY', 0, Raccoon.BUFFERHEIGHT +8, 36);
		_btnPlay.position.x = Raccoon.BUFFERWIDTH / 2 - _btnPlay.width / 2;
		_btnPlay.colorOn = Color.fromFloats(0.8, 0.8, 0.8);
		_btnPlay.colorOff = Color.fromFloats(0.3, 0.3, 0.3);
		_btnPlay.onClick = setPlayState;
		add(_btnPlay);

		Delta.tween(_txtHeader.position).prop('y', 256, 1.0).ease(Bounce.easeOut).onActionComplete(tweenButton);
	}

	override public function update()
	{
		super.update();
		Delta.step(1 /60);
	}

	override public function render(canvas:Canvas)
	{
		super.render(canvas);
	}

	override public function onMouseDown(button:Int, x:Int, y:Int):Void
	{
		if(button == 0)
		{
			_btnPlay.onButtonDown(x, y);
		}
	}

	function setPlayState()
	{
		State.set('play');
	}

	function tweenButton()
	{
		Delta.tween(_btnPlay.position).prop('y', Raccoon.BUFFERHEIGHT -256, 1.0).ease(Sine.easeInOut);
	}
}
package com.bloodline 
{
	import org.flixel.*;
	import util.TimeNotifier;
	public class Fader extends FlxSprite
	{
		private var _fadeTimer:TimeNotifier = new TimeNotifier(2);
		public function Fader(X:Number, Y:Number, wid:Number, hei:Number, col:uint) 
		{
			super(X, Y);
			makeGraphic(wid, hei, col);
			_fadeTimer.NotifyMe();
		}
		
		override public function update():void 
		{
			super.update();
			if (_fadeTimer.TimerFraction < 1) {
				this.alpha = 1 - _fadeTimer.TimerFraction;
			} else {
				this.kill();
			}
		}
	}
}
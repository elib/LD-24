package com.bloodline 
{
	import org.flixel.*;
	public class HealthBar extends FlxGroup
	{
		private var backSprite:FlxSprite;
		private var frontSprite:FlxSprite;
		
		private var _fullWidth:int;
		private var _originalLeft:int;
		
		public function HealthBar(which:int, X:Number, Y:Number, wid:Number, hei:Number) 
		{
			super();
			var color:uint;
			switch(which) {
				case 0:
					color = 0xffff0000;
					break;
				case 1:
					color = 0xff0000ff;
					break;
				case 2:
					color = 0xff00ff00;
					break;
			}
			
			backSprite = new FlxSprite(X, Y);
			backSprite.makeGraphic(wid, hei, color);
			backSprite.alpha = 0.3;
			
			frontSprite = new FlxSprite(X+1, Y+1);
			frontSprite.makeGraphic(1, hei - 2, color);
			_originalLeft = frontSprite.x;
			_fullWidth = wid - 2;
			
			this.add(backSprite);
			this.add(frontSprite);
		}
		
		public function set Amount(val:Number):void {
			frontSprite.scale.x = int(val * _fullWidth);
			frontSprite.x = _originalLeft + frontSprite.scale.x / 2;
		}
		
		public function Flicker():void {
			//frontSprite.flicker();
			backSprite.flicker();
		}
	}
}
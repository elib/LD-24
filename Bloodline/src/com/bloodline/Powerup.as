package com.bloodline 
{
	import org.flixel.*;
	
	public class Powerup extends FlxSprite
	{
		[Embed(source = '../../../../Assets/Powerup1.png')] private static var ImgPowerup1:Class;
		[Embed(source = '../../../../Assets/Powerup2.png')] private static var ImgPowerup2:Class;
		[Embed(source = '../../../../Assets/Powerup3.png')] private static var ImgPowerup3:Class;
		
		private static var theGraphics:Array = [ ImgPowerup1, ImgPowerup2, ImgPowerup3 ];
		
		public function InitFalling(X:Number, Y:Number):void {
			x = X - this.width / 2;
			y = Y - this.height;
			this.solid = false;
		}
		
		public function Powerup(powerupType:uint)
		{
			super();
			
			loadGraphic(theGraphics[powerupType], true, true, 16, 16);
			addAnimation("symbol", [1]);
			addAnimation("artifact", [0]);
		}
	}
}
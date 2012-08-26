package com.bloodline 
{
	import flash.geom.Point;
	import org.flixel.*;
	
	public class Powerup extends FlxSprite
	{
		[Embed(source = '../../../../Assets/Powerup1.png')] private static var ImgPowerup1:Class;
		[Embed(source = '../../../../Assets/Powerup2.png')] private static var ImgPowerup2:Class;
		[Embed(source = '../../../../Assets/Powerup3.png')] private static var ImgPowerup3:Class;
		[Embed(source = '../../../../Assets/infinity.png')] private static var ImgPowerup4:Class;
		
		private static var theGraphics:Array = [ ImgPowerup1, ImgPowerup2, ImgPowerup3 ];
		
		private var _targetY : int;
		private var _originalY: int;
		
		public function InitFalling(point:Point):void {
			x = point.x - this.width / 2;
			y = 0 - this.height;
			_targetY = point.y;
			_originalY = y;
			this.solid = false;
		}
		
		public function Powerup(powerupType:uint)
		{
			super();
			
			loadGraphic(theGraphics[powerupType], true, true, 16, 16);
			addAnimation("symbol", [1]);
			addAnimation("artifact", [0]);
		}
		
		public function DoAnim(fraction:Number):void {
			y = _originalY + (_targetY - _originalY) * fraction;
		}
	}
}
package com.bloodline 
{
	import flash.geom.Point;
	import org.flixel.*;
	public class Player extends FlxSprite
	{
		private static const ACCEL_RATE:Number = 500;
		private static const DRAG_RATE:Number = 500;
		private static const MAX_VEL:Number = 100;
		
		public function Player() 
		{
			super();
			
			makeGraphic(16, 16, 0xffff0000);
			
			drag.x = drag.y = DRAG_RATE;
			maxVelocity.x = maxVelocity.y = MAX_VEL;
		}
		
		override public function update():void 
		{
			super.update();
			
			var dir:Point = new Point(0, 0);
			
			if (FlxG.keys.LEFT || FlxG.keys.A) {
				dir.x = -1;
			} else if (FlxG.keys.RIGHT || FlxG.keys.D) {
				dir.x = 1;
			}
			
			if (FlxG.keys.UP || FlxG.keys.W) {
				dir.y = -1;
			} else if (FlxG.keys.DOWN || FlxG.keys.S) {
				dir.y = 1;
			}
			
			if(dir.length > 0) {
				dir.normalize(1);
				this.acceleration.x = dir.x * ACCEL_RATE;
				this.acceleration.y = dir.y * ACCEL_RATE;
			} else {
				this.acceleration.x = this.acceleration.y = 0;
			}
			
		}
	}
}
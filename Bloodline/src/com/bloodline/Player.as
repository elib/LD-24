package com.bloodline 
{
	import flash.geom.Point;
	import org.flixel.*;
	public class Player extends FlxSprite
	{
		private static const ACCEL_RATE:Number = 10000;
		private static const DRAG_RATE:Number = 300;
		private static const MAX_VEL:Number = 100;
		
		public function set InterActive(shouldBeActive:Boolean) : void {
			if (shouldBeActive != _interActive) {
				_interActive = shouldBeActive;
			}
		}
		
		private var _interActive:Boolean = false;
		
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
			
			if (!_interActive) {
				this.acceleration.x = this.acceleration.y = 0;
				return;
			}
			
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
				this.acceleration.x = dir.x * ACCEL_RATE * FlxG.elapsed;
				this.acceleration.y = dir.y * ACCEL_RATE * FlxG.elapsed;
			} else {
				this.acceleration.x = this.acceleration.y = 0;
			}
			
		}
	}
}
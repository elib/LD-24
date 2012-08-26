package com.bloodline 
{
	import adobe.utils.CustomActions;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import org.flixel.*;
	import util.ColorUtil;
	import util.TimeNotifier;
	
	public class Player extends FlxSprite
	{
		[Embed(source = '../../../../Assets/Sounds/attack.mp3')] private static var SndAttack:Class;
		[Embed(source = '../../../../Assets/Sounds/attack_fail.mp3')] private static var SndAttackFail:Class;
		[Embed(source = '../../../../Assets/Sounds/ready.mp3')] private static var SndReady:Class;
		[Embed(source = '../../../../Assets/Sounds/player_hurt.mp3')] private static var SndHurt:Class;
		
		private static const ACCEL_RATE:Number = 10000;
		private static const DRAG_RATE:Number = 300;
		private static const MAX_VEL:Number = 100;
		
		public function set InterActive(shouldBeActive:Boolean) : void {
			if (shouldBeActive != _interActive) {
				_interActive = shouldBeActive;
			}
		}
		
		private var _interActive:Boolean = false;
		
		private var _reloadTimer:TimeNotifier = new TimeNotifier();
		private var _isShotReady:Boolean = true;
		
		public function Player() 
		{
			super();
			
			health = FlxG.scores[Bloodline.HITPOINT_PLACE];
			
			ColorSprite();
			
			drag.x = drag.y = DRAG_RATE;
			maxVelocity.x = maxVelocity.y = MAX_VEL;
		}
		
		public function ColorSprite():void {
			var col:uint = getColor();
			makeGraphic(16, 16, col);
		}
		
		private function getColor():uint {
			var r:Number = 255 * (FlxG.scores[Bloodline.STRENGTH_PLACE] / Bloodline.MAX_GENERATIONS_FLOAT);
			var b:Number = 255 * (FlxG.scores[Bloodline.DEFENSE_PLACE] / Bloodline.MAX_GENERATIONS_FLOAT);
			var g:Number = 255 * (FlxG.scores[Bloodline.SPEED_PLACE] / Bloodline.MAX_GENERATIONS_FLOAT);
			
			
			var hsl:Array = ColorUtil.rgbToHsl(r, g, b);
			hsl[2] = 0.5 + (Bloodline.MAX_GENERATIONS_FLOAT - FlxG.scores[Bloodline.GENERATION_PLACE]) / (2*Bloodline.MAX_GENERATIONS_FLOAT);
			var rgb:Array = ColorUtil.hslToRgb(hsl[0], hsl[1], hsl[2]);
			var t:ColorTransform = new ColorTransform(1.0, 1.0, 1.0, 1.0, rgb[0], rgb[1], rgb[2]);
			var color:uint = t.color;
			return color + 0xff000000;
		}
		
		override public function update():void 
		{
			super.update();
			
			if (!_interActive) {
				this.acceleration.x = this.acceleration.y = 0;
				return;
			}
			
			if (_reloadTimer.Notify) {
				_isShotReady = true;
				//play RELOAD sound
				FlxG.play(SndReady);
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
			
			if (FlxG.keys.justPressed("X")) {
				if (!_isShotReady) {
					//play CLICK sound!
					FlxG.play(SndAttackFail);
				} else {
					//"attack"
					FlxG.play(SndAttack);
					(FlxG.state as Room).Attack();
					_isShotReady = false;
					var time:Number = 2 * (1 - FlxG.scores[Bloodline.SPEED_PLACE] / Bloodline.MAX_GENERATIONS_FLOAT);
					_reloadTimer.NotifyMe(time);
				}
			}
			
			if(dir.length > 0) {
				dir.normalize(1);
				this.acceleration.x = dir.x * ACCEL_RATE * FlxG.elapsed;
				this.acceleration.y = dir.y * ACCEL_RATE * FlxG.elapsed;
			} else {
				this.acceleration.x = this.acceleration.y = 0;
			}
		}
		
		override public function hurt(Damage:Number):void 
		{
			super.hurt(Damage);
			FlxG.scores[Bloodline.HITPOINT_PLACE] = health;
			FlxG.play(SndHurt);
			this.flicker();
		}
	}
}
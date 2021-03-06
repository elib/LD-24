package com.bloodline 
{
	import flash.display.GraphicsPath;
	import flash.geom.Point;
	import org.flixel.*;
	import util.TimeNotifier;
	
	public class Monster extends FlxSprite
	{
		[Embed(source = '../../../../Assets/Monsters.png')] private static var ImgMonsters:Class;
		
		[Embed(source = '../../../../Assets/Sounds/bidi-med.mp3')] private static var SndBidi1:Class;
		[Embed(source = '../../../../Assets/Sounds/bidi-high.mp3')] private static var SndBidi2:Class;
		[Embed(source = '../../../../Assets/Sounds/bidi-low.mp3')] private static var SndBidi3:Class;
		[Embed(source = '../../../../Assets/Sounds/ugh-med.mp3')] private static var SndUgh1:Class;
		[Embed(source = '../../../../Assets/Sounds/ugh-high.mp3')] private static var SndUgh2:Class;
		[Embed(source = '../../../../Assets/Sounds/ugh-low.mp3')] private static var SndUgh3:Class;
		
		private static var ugh:Array = [SndUgh1, SndUgh2, SndUgh3];
		private static var bidi:Array = [SndBidi1, SndBidi2, SndBidi3];
		
		public static const SPEED_MODIFIER:Number = 12;
		
		public static const MONSTER_NORMAL:uint = 0;
		public static const MONSTER_FAST:uint = 1;
		public static const MONSTER_SLOW:uint = 2;
		
		private static const SPD:uint = 0;
		private static const STR:uint = 2;
		private static const HP:uint = 4;
		private static const ANIMATION:uint = 6;
		private static const BBX:uint = 7;
		private static const BBY:uint = 8;
		
		public static const Waves:Array = 
			[
				[0, 0, 0], //0
				[2, 0, 0],
				[3, 0, 0],
				[2, 2, 0],
				[2, 4, 0],
				[0, 6, 0], //5
				[0, 0, 1], 
				[2, 0, 1],
				[0, 0, 2],
				[0, 5, 2],
				[0, 10, 0], //5
				[1, 0, 0],
				[5, 0, 0],
				[0, 0, 4],
				[3, 10, 3],
				[0, 0, 5] //15
			];
		
		private static const MonsterAttributes:Array = 
			[
				//"normal" monster, low and high values
				[2, 3,
				1, 2,
				2, 2,
				"normal",
				16, 16],
				//"fast" monster, low and high values
				[4, 6,
				1, 1,
				1, 1,
				"fast",
				8, 8],
				//"slow" monster, low and high values
				[1, 1,
				3, 6,
				4, 6,
				"slow",
				32, 32]
			];
			
		public var strength:int = 0;
		public var speed:int = 0;
		private var _type:int;
		private var _updatePathNotifier:TimeNotifier = new TimeNotifier(0.5 + FlxG.random() * 0.5);
		
		public var canHurt:Boolean = false;
		
		public function Monster(type:uint, p:Point) 
		{
			super(p.x, p.y);
			
			_type = type;
			
			loadGraphic(ImgMonsters, true, true, 32, 32);
			addAnimation("normal", [0]);
			addAnimation("fast", [1]);
			addAnimation("slow", [2]);
			addAnimation("dead", [3]);
			
			setType(type);
			updatePath(false);
			
			_updatePathNotifier.NotifyMe();
		}
		
		private function getRandBetweenInclusive(a:int, b:int):int {
			if (a == b) return a;
			var range:int = b - a + 1;
			var val: int = a + int(FlxG.random() * range);
			return val;
		}
		
		private function setType(type:uint) :void {
			var info:Array = MonsterAttributes[type] as Array;
			strength = getRandBetweenInclusive(info[STR], info[STR + 1]);
			speed = getRandBetweenInclusive(info[SPD], info[SPD + 1]);
			health = getRandBetweenInclusive(info[HP], info[HP + 1]);
			play(info[ANIMATION]);
			width = info[BBX];
			height = info[BBY];
			offset.x = 16 - info[BBX] / 2;
			offset.y = 16 - info[BBY] / 2;
		}
		
		override public function update():void 
		{
			super.update();
			if (alive) {
				if (health <= 0) {
					alive = false;
				}
				
				if (_updatePathNotifier.Notify) {
					updatePath();
					_updatePathNotifier.NotifyMe();
				}
			} else {
				play("dead");
			}
		}
		
		private function updatePath(doSound:Boolean = true):void {
			var player:Player = (FlxG.state as Room)._player;
			var nodes:Array = [new FlxPoint(player.x, player.y)];
			if (path) {
				stopFollowingPath(true);
			}
			
			followPath(new FlxPath(nodes), speed * SPEED_MODIFIER, PATH_FORWARD, true);
			if(doSound && FlxG.random() < 0.15) {
				FlxG.play(bidi[_type] as Class);
			}
			
			canHurt = true;
		}
		
		override public function hurt(Damage:Number):void 
		{
			super.hurt(Damage);
			FlxG.play(ugh[_type] as Class);
			flicker();
		}
	}
}
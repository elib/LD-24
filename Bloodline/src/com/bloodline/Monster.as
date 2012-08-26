package com.bloodline 
{
	import flash.geom.Point;
	import org.flixel.*;
	
	public class Monster extends FlxSprite
	{
		[Embed(source = '../../../../Assets/Monsters.png')] private static var ImgMonsters:Class;
		
		public static const MONSTER_NORMAL:uint = 0;
		public static const MONSTER_FAST:uint = 1;
		public static const MONSTER_SLOW:uint = 2;
		
		private static const SPD:uint = 0;
		private static const STR:uint = 2;
		private static const HP:uint = 4;
		private static const ANIMATION:uint = 6;
		private static const BBX:uint = 7;
		private static const BBY:uint = 8;
		
		private static const MonsterAttributes:Array = 
			[
				//"normal" monster, low and high values
				[1, 2,
				1, 2,
				1, 2,
				"normal",
				16, 16],
				//"fast" monster, low and high values
				[4, 6,
				1, 1,
				1, 2,
				"fast",
				8, 8],
				//"slow" monster, low and high values
				[1, 1,
				3, 6,
				2, 4,
				"slow",
				32, 32]
			];
			
		private var	strength:int = 0;
		private var	speed:int = 0;
		
		
		public function Monster(type:uint, p:Point) 
		{
			super(p.x, p.y);
			
			loadGraphic(ImgMonsters, true, true, 32, 32);
			addAnimation("normal", [0]);
			addAnimation("fast", [1]);
			addAnimation("slow", [2]);
			
			setType(type);
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
		}
	}
}
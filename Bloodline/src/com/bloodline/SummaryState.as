package com.bloodline 
{
	import org.flixel.*;
	
	public class SummaryState extends FlxState
	{
		private var _good:Boolean;
		public function SummaryState(good:Boolean) 
		{
			super();
			
			_good = good;
		}
		
		override public function create():void 
		{
			super.create();
			
			var lineage:Lineage = new Lineage(_good);
			this.add(lineage);
			
			var txt:FlxText = new FlxText(0, FlxG.height / 2 - 30, 100);
			txt.setFormat(null, 8, 0xffdc5151, "left");
			this.add(txt);
			
			if (_good) {
				txt.text = "This bloodline has proven itself a viable one! " + generateDescriptionText();
			} else {
				txt.text = "This bloodline has been lost. However, other mutations may have led to more successful descendants.";
			}
			
			txt.text += "\r\nPress x to try another bloodline.";
		}
		
		private function generateDescriptionText():String {
			var str:int = FlxG.scores[Bloodline.STRENGTH_PLACE];
			var def:int = FlxG.scores[Bloodline.DEFENSE_PLACE];
			var spd:int = FlxG.scores[Bloodline.SPEED_PLACE];
			if (str >= 2 * Bloodline.MAX_GENERATIONS / 3) {
				return "By focusing on raw attack strength, the individuals of each population could fend off their enemies easily.";
			}
			if (def >= 2 * Bloodline.MAX_GENERATIONS / 3) {
				return "By growing thick skins, the population could withstand even the deadliest onslaught.";
			}
			if (spd >= 2 * Bloodline.MAX_GENERATIONS / 3) {
				return "By honing their reflexes and cunning, this quick species was able to attack fast enough to survive.";
			}
			
			if (str < 1 * Bloodline.MAX_GENERATIONS / 3) {
				return "This species evolved into quick creatures with tough skins. They withstood the enemies just long enough to finish them off.";
			}
			
			if (def < 1 * Bloodline.MAX_GENERATIONS / 3) {
				return "With sharp claw and sharper wit, these creatures devestated their enemies in short flurries of blitz attacks."
			}
			
			if (spd < 1 * Bloodline.MAX_GENERATIONS / 3) {
				return "These slow, cumbersome beasts could withstand punishing blows, and could return the favor thricefold.";
			}
			
			return "Taking advantage of equal parts strength, defensive measures, and battle-cunning, these jacks-of-all-trade fended off foe of all kind.";
		}
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.any()) {
				Bloodline.InitNewGame();
				FlxG.switchState(new StartingRoom());
			}
		}
	}
}
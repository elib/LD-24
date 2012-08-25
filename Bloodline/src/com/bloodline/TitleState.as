package com.bloodline 
{
	import org.flixel.*;
	public class TitleState extends FlxState
	{
		public function TitleState() 
		{
			super();
		}
		
		private function initNewGame():void {
			FlxG.scores[Bloodline.GENERATION_PLACE] = 0;
			FlxG.scores[Bloodline.STRENGTH_PLACE] = 0;
			FlxG.scores[Bloodline.SPEED_PLACE] = 0;
			FlxG.scores[Bloodline.DEFENSE_PLACE] = 0;
			FlxG.scores[Bloodline.HITPOINT_PLACE] = Bloodline.STARTING_HITPOINTS;
			
			if (FlxG.scores[Bloodline.HISTORY_PLACE] == null) {
				FlxG.log("Starting new game from scratch");
				//if no histories, init to blank
				FlxG.scores[Bloodline.HISTORY_PLACE] = new Array();
			}
			
			//add new history entry
			var lastDecision:DecisionData = new DecisionData();
			var newLength:int = (FlxG.scores[Bloodline.HISTORY_PLACE] as Array).push(lastDecision);
			FlxG.scores[Bloodline.LATEST_NODE_PLACE] = lastDecision;
			FlxG.log("Now beginning: parallel generation #" + newLength);
		}
		
		override public function create():void 
		{
			super.create();
			var txt:FlxText = new FlxText(0, FlxG.height / 2 - 32, FlxG.width, "Bloodline");
			txt.setFormat(null, 32, 0xffffff, "center");
			this.add(txt);
			
			initNewGame();
		}
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.any()) {
				FlxG.switchState(new StartingRoom());
			}
		}
	}
}
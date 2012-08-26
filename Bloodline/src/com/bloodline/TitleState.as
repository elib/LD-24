package com.bloodline 
{
	import org.flixel.*;
	public class TitleState extends FlxState
	{
		[Embed(source = '../../../../Assets/titlescreen.png')] private static var ImgTitle:Class;
		
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
			
			initNewGame();
			
			var bg:FlxSprite = new FlxSprite(0, 0, ImgTitle);
			this.add(bg);
			
			var txt:FlxText = new FlxText(0, FlxG.height / 2 - 8, 100, "press x to begin");
			if ((FlxG.scores[Bloodline.HISTORY_PLACE] as Array).length > 1) {
				txt.text += " another bloodline";
			}
			txt.setFormat(null, 8, 0xffffff, "left");
			this.add(txt);
			
			
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
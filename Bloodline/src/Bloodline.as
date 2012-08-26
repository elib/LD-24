package  
{
	import org.flixel.*;
	import com.bloodline.*;
	import util.TimeNotifier;
	
	[SWF(width = "640", height = "512", backgroundColor = "#000000")]
	[Frame(factoryClass = "Preloader")]
 
	public class Bloodline extends FlxGame
	{		
		public static const TILESIZE:int = 32;
		
		public static const GENERATION_PLACE:int = 0;
		public static const STRENGTH_PLACE:int = 1;
		public static const DEFENSE_PLACE:int = 2;
		public static const SPEED_PLACE:int = 3;
		public static const HITPOINT_PLACE:int = 4;
		
		public static const HISTORY_PLACE:int = 15;
		public static const LATEST_NODE_PLACE:int = 16;
		public static const LISTS_PLACE:int = 17;
		
		public static const STARTING_HITPOINTS:int = 10;
		
		public static const MAX_GENERATIONS:int = 15;
		public static const MAX_GENERATIONS_FLOAT:Number = MAX_GENERATIONS;
		
		public function Bloodline()
		{
			super(320, 256, TitleState, 2);
		}
		
		override protected function update():void 
		{
			super.update();
			TimeNotifier.update();
		}
		
		public static function InitNewGame():void {
			FlxG.scores[Bloodline.GENERATION_PLACE] = 0;
			FlxG.scores[Bloodline.STRENGTH_PLACE] = 0;
			FlxG.scores[Bloodline.SPEED_PLACE] = 0;
			FlxG.scores[Bloodline.DEFENSE_PLACE] = 0;
			FlxG.scores[Bloodline.HITPOINT_PLACE] = Bloodline.STARTING_HITPOINTS;
			
			if (FlxG.scores[Bloodline.HISTORY_PLACE] == null) {
				FlxG.log("Starting new game from scratch");
				//if no histories, init to blank
				FlxG.scores[Bloodline.HISTORY_PLACE] = new Array();
				
				FlxG.scores[Bloodline.LISTS_PLACE] = new Array();
			}
			
			//add new history entry
			var lastDecision:DecisionData = new DecisionData();
			var newLength:int = (FlxG.scores[Bloodline.HISTORY_PLACE] as Array).push(lastDecision);
			FlxG.scores[Bloodline.LATEST_NODE_PLACE] = lastDecision;
			FlxG.log("Now beginning: parallel generation #" + newLength);
			
			((FlxG.scores[Bloodline.LISTS_PLACE]) as Array).push(new Array());
		}
	}
}
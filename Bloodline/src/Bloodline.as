package  
{
	import org.flixel.*;
	import com.bloodline.*;
	[SWF(width = "640", height = "512", backgroundColor = "#000000")]
	[Frame(factoryClass = "Preloader")]
 
	public class Bloodline extends FlxGame
	{		
		public static const TILESIZE:int = 16;
		
		public static const GENERATION_PLACE:int = 0;
		public static const STRENGTH_PLACE:int = 1;
		public static const DEFENSE_PLACE:int = 2;
		public static const SPEED_PLACE:int = 3;
		public static const HITPOINT_PLACE:int = 4;
		public static const HISTORY_PLACE:int = 15;
		
		public static const STARTING_HITPOINTS:int = 10;
		
		public function Bloodline()
		{			
			
			
			super(320, 256, TitleState, 2);
			
			
		}
	}
}
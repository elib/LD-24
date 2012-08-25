package  
{

	import org.flixel.system.FlxPreloader;
	
	public class Preloader extends FlxPreloader
	{
		
		public function Preloader() :void 
		{
			className = "Bloodline";
			super();
			this.minDisplayTime = 2;
		}
		
	}
}
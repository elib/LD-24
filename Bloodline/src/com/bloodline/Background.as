package com.bloodline 
{
	import org.flixel.*;
	
	public class Background extends FlxSprite
	{
		[Embed(source = '../../../../Assets/bground.png')] private static var ImgBground:Class;
		[Embed(source = '../../../../Assets/bground-upsidedown.png')] private static var ImgBgroundUpsideDown:Class;
		
		public function Background() 
		{
			super();
			
			if (FlxG.random() > 0.5) {
				loadGraphic(ImgBground, false, true);
			} else {
				loadGraphic(ImgBgroundUpsideDown, false, true);
			}
			
			if (FlxG.random() > 0.5) {
				this.facing = LEFT;
			} else {
				this.facing = RIGHT;
			}
			
		}
		
	}

}
package com.bloodline 
{
	import org.flixel.*;
	
	public class WinThing extends FlxSprite
	{
		[Embed(source = '../../../../Assets/infinity.png')] public static var ImgWin:Class;
		
		public function WinThing() 
		{
			super();
			loadGraphic(ImgWin);
			immovable = true;
		}
	}
}
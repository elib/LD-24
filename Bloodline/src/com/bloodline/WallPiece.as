package com.bloodline 
{
	import org.flixel.*;
	
	public class WallPiece extends FlxSprite
	{
		
		[Embed(source = '../../../../Assets/tall.png')] private static var ImgTall:Class;
		[Embed(source = '../../../../Assets/wide.png')] private static var ImgWide:Class;
		
		public function WallPiece(X:Number, Y:Number, wid:Number, hei:Number)
		{
			super(X, Y);
			
			if (wid > hei) {
				loadGraphic(ImgWide);
			} else {
				loadGraphic(ImgTall);
			}
			
			this.immovable = true;
		}
	}
}
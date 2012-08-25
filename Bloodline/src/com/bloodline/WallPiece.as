package com.bloodline 
{
	import org.flixel.*;
	
	public class WallPiece extends FlxSprite
	{
		public function WallPiece(X:Number, Y:Number, wid:Number, hei:Number)
		{
			super(X, Y);
			this.makeGraphic(wid, hei);
			
			this.immovable = true;
		}
	}
}
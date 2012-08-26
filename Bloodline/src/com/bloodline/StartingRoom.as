package com.bloodline 
{
	import org.flixel.*;
	
	public class StartingRoom extends Room
	{
		[Embed(source = '../../../../Assets/aleph.png')] private static var ImgAleph:Class;
		
		public function StartingRoom() 
		{
			super(Room.DIR_NORTH, DecisionData.NO_CHOICE);
		}
		
		override public function create():void 
		{
			super.create();
			
			var aleph:FlxSprite
			for (var i:int = 2; i <= 7; i++ ){
				aleph = new FlxSprite(i * Bloodline.TILESIZE, 0, ImgAleph);
				this.add(aleph);
			}
			
		}
	}
}
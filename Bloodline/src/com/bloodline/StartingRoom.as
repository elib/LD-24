package com.bloodline 
{
	import org.flixel.*;
	
	public class StartingRoom extends Room
	{
		public function StartingRoom() 
		{
			super(Room.DIR_NORTH, DecisionData.NO_CHOICE);
		}
		
		override public function create():void 
		{
			super.create();
			
			
		}
	}
}
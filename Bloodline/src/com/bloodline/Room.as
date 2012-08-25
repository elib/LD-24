package com.bloodline 
{
	import org.flixel.*;
	public class Room extends FlxState
	{
		private var _genTxt:FlxText = new FlxText(0, 0, 50);
		
		public function Room() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
			
			_genTxt.text = "GEN " + FlxG.scores[Bloodline.GENERATION_PLACE];
			_genTxt.setFormat(null, 8);
			this.add(_genTxt);
		}
	}
}
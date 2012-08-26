package com.bloodline 
{
	import org.flixel.*;
	
	public class SummaryState extends FlxState
	{
		private var _good:Boolean;
		public function SummaryState(good:Boolean) 
		{
			super();
			
			_good = good;
		}
		
		override public function create():void 
		{
			super.create();
			
			var lineage:Lineage = new Lineage(_good);
			this.add(lineage);
			
			var txt:FlxText = new FlxText(0, FlxG.height / 2 - 8, 100);
			txt.setFormat(null, 8, 0xffdc5151, "left");
			this.add(txt);
			
			if (_good) {
				txt.text = "AMAZING";
			} else {
				txt.text = "This bloodline has been lost. However, other mutations may have led to more successful descendants.\r\nPress x to begin afresh.";
			}
			
		}
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.any()) {
				Bloodline.InitNewGame();
				FlxG.switchState(new StartingRoom());
			}
		}
	}
}
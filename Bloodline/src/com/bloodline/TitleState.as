package com.bloodline 
{
	import org.flixel.*;
	public class TitleState extends FlxState
	{
		[Embed(source = '../../../../Assets/titlescreen.png')] private static var ImgTitle:Class;
		
		public function TitleState() 
		{
			super();
		}
		
		override public function create():void 
		{
			super.create();
			
			Bloodline.InitNewGame();
			
			var bg:FlxSprite = new FlxSprite(0, 0, ImgTitle);
			this.add(bg);
			
			var txt:FlxText = new FlxText(0, FlxG.height / 2 - 8, 100, "press x to begin");
			if ((FlxG.scores[Bloodline.HISTORY_PLACE] as Array).length > 1) {
				txt.text += " another bloodline";
			}
			txt.setFormat(null, 8, 0xffdc5151, "left");
			this.add(txt);
			
		}
		
		override public function update():void 
		{
			super.update();
			if (FlxG.keys.any()) {
				FlxG.switchState(new StartingRoom());
			}
		}
	}
}
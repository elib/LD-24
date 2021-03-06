package com.bloodline 
{
	import org.flixel.*;
	public class Lineage extends FlxGroup
	{
		[Embed(source = '../../../../Assets/skull.png')] private static var ImgSkull:Class;
		
		public function Lineage(successful:Boolean)
		{
			super();
			
			var Y:int = 2;
			
			var listOfLists:Array = (FlxG.scores[Bloodline.LISTS_PLACE] as Array);
			var listOfPlayers:Array = (listOfLists[listOfLists.length - 1] as Array);
			var i:int;
			for (i = 1; i < listOfPlayers.length; i++) {
				var attr:Array = listOfPlayers[i] as Array;
				var col:uint = Player.GetColor(attr[0],
									attr[1],
									attr[2],
									i); 
				
				var p:FlxSprite = new FlxSprite(2 + 20 * i, Y);
				p.makeGraphic(16, 16, col);
				this.add(p);
			}
			
			var aleph:FlxSprite = new FlxSprite(2, Y, StartingRoom.ImgAleph);
			aleph.scale.x = aleph.scale.y = .5;
			aleph.x -= 8;
			aleph.y -= 8;
			this.add(aleph);
			
			if (!successful) {
				// add SKULL
				var skull:FlxSprite = new FlxSprite(2 + 20 * i, Y, ImgSkull);
				this.add(skull);
			} else {
				// add INFINITY
				var infinity:FlxSprite = new FlxSprite(2 + 20 * i, Y, WinThing.ImgWin);
				this.add(infinity);
			}
		}
	}
}
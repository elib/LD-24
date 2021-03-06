package com.bloodline 
{
	import org.flixel.*;
	public class Doorway extends FlxSprite
	{
		
		[Embed(source = '../../../../Assets/door_tall.png')] private static var ImgTall:Class;
		[Embed(source = '../../../../Assets/door_wide.png')] private static var ImgWide:Class;
		
		private var _isOpen:Boolean = false;
		
		public function set Open(open:Boolean):void {
			if (open != _isOpen) {
				_isOpen = open;
				this.visible = !open;
				this.solid = this.visible;
			}
		}
		
		public function Doorway(direction:uint)
		{
			super();
			immovable = true;
			init(direction);
			Open = true;
		}
		
		private function init(direction:uint) :void {
			var wid:int = 0;
			var hei:int = 0;
			
			switch(direction) {
				case Room.DIR_NORTH:
				case Room.DIR_SOUTH:
					wid = 2 * Bloodline.TILESIZE;
					hei = Bloodline.TILESIZE;
					break;
				case Room.DIR_EAST:
				case Room.DIR_WEST:
					wid = Bloodline.TILESIZE;
					hei = 2 * Bloodline.TILESIZE;
					break;
			}
			
			switch(direction) {
				case Room.DIR_NORTH:
					x = 4 * Bloodline.TILESIZE;
					y = 0;
					break;
				case Room.DIR_SOUTH:
					x = 4 * Bloodline.TILESIZE;
					y = 7 * Bloodline.TILESIZE;
					break;
				case Room.DIR_WEST:
					x = 0;
					y = 3 * Bloodline.TILESIZE;
					break;
				case Room.DIR_EAST:
					x = 9 * Bloodline.TILESIZE;
					y = 3 * Bloodline.TILESIZE;
					break;
			}
			
			if (wid > hei) {
				loadGraphic(ImgWide);
			} else {
				loadGraphic(ImgTall);
			}
		}
		
	}

}
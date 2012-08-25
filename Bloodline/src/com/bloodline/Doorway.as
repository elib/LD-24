package com.bloodline 
{
	import org.flixel.*;
	public class Doorway extends FlxSprite
	{
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
				case Room.DIR_EAST:
					x = 0;
					y = 3 * Bloodline.TILESIZE;
					break;
				case Room.DIR_WEST:
					x = 9 * Bloodline.TILESIZE;
					y = 3 * Bloodline.TILESIZE;
					break;
			}
			
			makeGraphic(wid, hei, 0xffaf7c5d);
		}
		
	}

}
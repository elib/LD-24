package com.bloodline 
{
	import org.flixel.*;
	public class Room extends FlxState
	{
		public static const DIR_NORTH:uint 		= 0;
		public static const DIR_EAST:uint 		= 1;
		public static const DIR_WEST:uint 		= 2;
		public static const DIR_SOUTH:uint 		= 3;
		
		private var _genTxt:FlxText = new FlxText(0, 0, 50);
		
		//room setup
		private var _entranceDir:uint;
		private var _latestChoice:uint;
		
		private var _doorGroup:FlxGroup = new FlxGroup();
		private var _wallGroup:FlxGroup = new FlxGroup();
		
		private var _player:Player = new Player();
		
		public function Room(initialDir:uint, lastChoice:uint) 
		{
			super();
			_entranceDir = initialDir;
			_latestChoice = lastChoice;
		}
		
		override public function create():void 
		{
			super.create();
			
			calculateGeneration();
			
			setRoomPieces();
			spawn();
			
			_genTxt.text = "GEN " + FlxG.scores[Bloodline.GENERATION_PLACE];
			_genTxt.setFormat(null, 8, 0xff000000);
			this.add(_genTxt);
			
			this.add(_player);
		}
		
		private function spawn():void {
			switch(_entranceDir) {
				case DIR_NORTH:
					_player.x = FlxG.width / 2;
					_player.y = 1.5 * Bloodline.TILESIZE;
					break;
				case DIR_SOUTH:
					_player.x = FlxG.width / 2;
					_player.y = FlxG.height - 1.5 * Bloodline.TILESIZE;
					break;
				case DIR_EAST:
					_player.x = FlxG.width - 1.5 * Bloodline.TILESIZE;
					_player.y = FlxG.height / 2;
					break;
				case DIR_WEST:
					_player.x = 1.5 * Bloodline.TILESIZE;
					_player.y = FlxG.height / 2;
					break;
			}
		}
		
		private function calculateGeneration() : void {
			if (_latestChoice != DecisionData.NO_CHOICE) {
				//update tree
				var newDec:DecisionData = new DecisionData();
				(FlxG.scores[Bloodline.LATEST_NODE_PLACE] as DecisionData).decision[_latestChoice] = newDec;
				FlxG.scores[Bloodline.LATEST_NODE_PLACE] = newDec;
				
				FlxG.scores[Bloodline.GENERATION_PLACE] += 1;
			}
		}
		
		private function setRoomPieces() :void {
			//top left
			var wallPiece:WallPiece = new WallPiece(0, 0, 4 * Bloodline.TILESIZE, Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			wallPiece = new WallPiece(0, Bloodline.TILESIZE, Bloodline.TILESIZE, 2 * Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			
			//top right
			wallPiece = new WallPiece(6 * Bloodline.TILESIZE, 0, 4 * Bloodline.TILESIZE, Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			wallPiece = new WallPiece(9 * Bloodline.TILESIZE, Bloodline.TILESIZE, Bloodline.TILESIZE, 2*Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			
			//bottom left
			wallPiece = new WallPiece(0, 7 * Bloodline.TILESIZE, 4 * Bloodline.TILESIZE, Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			wallPiece = new WallPiece(0, 5 * Bloodline.TILESIZE, Bloodline.TILESIZE, 3 * Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			
			//bottom right
			wallPiece = new WallPiece(6 * Bloodline.TILESIZE, 7 * Bloodline.TILESIZE, 4 * Bloodline.TILESIZE, Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			wallPiece = new WallPiece(9 * Bloodline.TILESIZE, 5 * Bloodline.TILESIZE, Bloodline.TILESIZE, 2*Bloodline.TILESIZE);
			_wallGroup.add(wallPiece);
			
			for (var i:uint = 0; i < 4; i++) {
				var door:Doorway = new Doorway(i);
				_doorGroup.add(door);
			}
			
			this.add(_wallGroup);
			this.add(_doorGroup);
		}
		
		override public function update():void 
		{
			super.update();
			FlxG.collide(_wallGroup, _player);
			FlxG.collide(_doorGroup, _player);
		}
	}
}
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
			
			_genTxt.text = "GEN " + FlxG.scores[Bloodline.GENERATION_PLACE];
			_genTxt.setFormat(null, 8);
			this.add(_genTxt);
			
			setRoomPieces();
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
			this.add(wallPiece);
			wallPiece = new WallPiece(0, Bloodline.TILESIZE, Bloodline.TILESIZE, 2 * Bloodline.TILESIZE);
			this.add(wallPiece);
			
			//top right
			wallPiece = new WallPiece(6 * Bloodline.TILESIZE, 0, 4 * Bloodline.TILESIZE, Bloodline.TILESIZE);
			this.add(wallPiece);
			wallPiece = new WallPiece(9 * Bloodline.TILESIZE, Bloodline.TILESIZE, Bloodline.TILESIZE, 2*Bloodline.TILESIZE);
			this.add(wallPiece);
			
			//bottom left
			wallPiece = new WallPiece(0, 7 * Bloodline.TILESIZE, 4 * Bloodline.TILESIZE, Bloodline.TILESIZE);
			this.add(wallPiece);
			wallPiece = new WallPiece(0, 5 * Bloodline.TILESIZE, Bloodline.TILESIZE, 3 * Bloodline.TILESIZE);
			this.add(wallPiece);
			
			//bottom right
			wallPiece = new WallPiece(6 * Bloodline.TILESIZE, 7 * Bloodline.TILESIZE, 4 * Bloodline.TILESIZE, Bloodline.TILESIZE);
			this.add(wallPiece);
			wallPiece = new WallPiece(9 * Bloodline.TILESIZE, 5 * Bloodline.TILESIZE, Bloodline.TILESIZE, 2*Bloodline.TILESIZE);
			this.add(wallPiece);
		}
	}
}
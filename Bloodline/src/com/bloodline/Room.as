package com.bloodline 
{
	import org.flixel.*;
	import util.TimeNotifier;
	public class Room extends FlxState
	{
		public static const DIR_NORTH:uint 		= 0;
		public static const DIR_EAST:uint 		= 1;
		public static const DIR_SOUTH:uint 		= 2;
		public static const DIR_WEST:uint 		= 3;
		
		public static const ENTRANCE_STATE:uint 	= 0;
		public static const COMBAT_STATE:uint 		= 1;
		public static const POWERUP_STATE:uint 		= 2;
		public static const COLLECT_STATE:uint 		= 3;
		public static const OPEN_DOOR_STATE:uint 	= 4;
		public static const EXIT_STATE:uint 		= 5;
		public static const DEATH_STATE:uint		= 6;
		
		private var _state:uint = ENTRANCE_STATE;
		
		private var _genTxt:FlxText = new FlxText(0, 0, 50);
		
		//room setup
		private var _entranceDir:uint;
		private var _latestChoice:uint;
		
		private var _doorGroup:FlxGroup = new FlxGroup();
		private var _wallGroup:FlxGroup = new FlxGroup();
		private var _enemyGroup:FlxGroup = new FlxGroup();
		private var _powerupGroup:FlxGroup = new FlxGroup();
		
		private var _doorsOpenTimer:TimeNotifier = new TimeNotifier(1);
		private var _powerupFallTimer:TimeNotifier = new TimeNotifier(1);
		
		private var _player:Player = new Player();
		
		private function set allDoorsOpen(shouldOpen:Boolean) : void {
			for (var i:uint = 0; i < 4; i++) {
				(_doorGroup.members[i] as Doorway).Open = shouldOpen;
			}
			
			(_doorGroup.members[_entranceDir] as Doorway).Open = false;
			
			//PLAY SOUND HERE KTHX
		}
		
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
			
			_doorsOpenTimer.NotifyMe(0, true);
			allDoorsOpen = true;
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
			
			_player.x -= _player.width / 2;
			_player.y -= _player.height / 2 ;
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
			var wasState:uint = _state;
			
			switch(_state) {
				case ENTRANCE_STATE:
					if (_doorsOpenTimer.Notify) {
						_state = COMBAT_STATE;
						allDoorsOpen = false;
						_player.InterActive = true;
					}
					break;
				case COMBAT_STATE:
					if (_enemyGroup.countLiving() <= 0) {
						//win, move on
						_state = POWERUP_STATE;
						_powerupFallTimer.NotifyMe(0, true);
						_player.InterActive = false;
					} else if (!_player.alive){
						_state = DEATH_STATE;
					}
					break;
				case POWERUP_STATE:
					if (_powerupFallTimer.Notify) {
						_state = COLLECT_STATE;
						_player.InterActive = true;
					}
					break;
				case COLLECT_STATE:
					if (_powerupGroup.countLiving() <= 0) {
						_state = OPEN_DOOR_STATE;
						_doorsOpenTimer.NotifyMe(0, true);
						_player.InterActive = false;
					}
					break;
				case OPEN_DOOR_STATE:
					if (_doorsOpenTimer.Notify) {
						_state = EXIT_STATE;
						allDoorsOpen = true;
						_player.InterActive = true;
					}
					break;
				case EXIT_STATE:
					determineNextRoomAndGo();
					break;
				case DEATH_STATE:
					break;
			}
			
			FlxG.collide(_wallGroup, _player);
			FlxG.collide(_doorGroup, _player);
			
			if (wasState != _state) {
				FlxG.log("State changed to: " + _state);
			}
		}
		
		private function determineNextRoomAndGo():void {
			var room:Room = null;
			if (_player.x <= 0) {
				room = new Room(DIR_EAST, DecisionData.NO_CHOICE);
			} else if (_player.x + _player.width >= FlxG.width) {
				room = new Room(DIR_WEST, DecisionData.NO_CHOICE);
			} else if (_player.y <= 0) {
				room = new Room(DIR_SOUTH, DecisionData.NO_CHOICE);
			} else if (_player.y + _player.height >= FlxG.height) {
				room = new Room(DIR_NORTH, DecisionData.NO_CHOICE);
			}
			
			if (room) {
				FlxG.switchState(room);
			}
		}
	}
}
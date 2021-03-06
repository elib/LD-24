package com.bloodline 
{
	import adobe.utils.CustomActions;
	import flash.geom.Point;
	import flash.text.engine.BreakOpportunity;
	import org.flixel.*;
	import util.TimeNotifier;
	public class Room extends FlxState
	{
		[Embed(source = '../../../../Assets/Sounds/door_open.mp3')] private static var SndDoorOpen:Class;
		[Embed(source = '../../../../Assets/Sounds/door_close.mp3')] private static var SndDoorClose:Class;
		[Embed(source = '../../../../Assets/Sounds/powerup_get.mp3')] private static var SndPowerupGet:Class;
		
		private const margin:int = 10;
		
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
		private var _popTxt:FlxText = new FlxText(0, 0, 50);
		
		//room setup
		private var _entranceDir:uint;
		private var _latestChoice:uint;
		
		private var _doorGroup:FlxGroup = new FlxGroup();
		private var _wallGroup:FlxGroup = new FlxGroup();
		private var _enemyGroup:FlxGroup = new FlxGroup();
		private var _powerupGroup:FlxGroup = new FlxGroup();
		private var _symbolGroup:FlxGroup = new FlxGroup();
		private var _hudGroup:FlxGroup = new FlxGroup();
		
		private var _doorsOpenTimer:TimeNotifier = new TimeNotifier(1);
		private var _powerupFallTimer:TimeNotifier = new TimeNotifier(1);
		
		private var _powerup:Powerup = null;
		
		private var _directionChoices:Array;
		
		public var _player:Player = new Player();
		
		private var _flashGroup:FlxGroup = new FlxGroup();
		
		private var _metersGroup:FlxGroup = new FlxGroup();
		
		public var _chargeWeapon:HealthBar = new HealthBar(2, 1, FlxG.height - 16, 30, 14);
		
		private function set allDoorsOpen(shouldOpen:Boolean) : void {
			for (var i:uint = 0; i < 4; i++) {
				(_doorGroup.members[i] as Doorway).Open = shouldOpen;
			}
			
			(_doorGroup.members[_entranceDir] as Doorway).Open = false;
			
			if (shouldOpen) {
				FlxG.play(SndDoorOpen);
			} else {
				FlxG.play(SndDoorClose);
			}
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
			
			setupHud();
			
			setupEnemies();
			
			var bgsprite:Background = new Background();
			this.add(bgsprite);
			
			this.add(_flashGroup);
			this.add(_wallGroup);
			this.add(_symbolGroup);
			this.add(_doorGroup);
			if (FlxG.scores[Bloodline.GENERATION_PLACE] == Bloodline.MAX_GENERATIONS) {
				_symbolGroup.visible = false;
			}
			
			this.add(_enemyGroup);
			this.add(_player);
			this.add(_powerupGroup);
			this.add(_hudGroup);
			this.add(_chargeWeapon);
			_chargeWeapon.visible = false;
			
			_doorsOpenTimer.NotifyMe(0, true);
			//allDoorsOpen = true;
		}
		
		private function setupEnemies():void {
			//determine difficulty
			var gen:int = FlxG.scores[Bloodline.GENERATION_PLACE];
			var wave:Array = Monster.Waves[gen];
			for (var i:int = 0; i < 3; i++) { //for each type
				spawnEnemies(i, wave[i]);
			}
			
			_enemyGroup.active = false;
		}
		
		private function spawnEnemies(type:int, number:int):void {
			for (var i:int = 0; i < number; i++) {
				var p:Point = getFarFromPlayer();
				var m:Monster = new Monster(type, p);
				_enemyGroup.add(m);
			}
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
				
				var newPop:int = FlxG.scores[Bloodline.HITPOINT_PLACE] + 1;
				newPop = Math.min(newPop, Bloodline.STARTING_HITPOINTS);
				FlxG.scores[Bloodline.HITPOINT_PLACE] = newPop;
				_player.health = FlxG.scores[Bloodline.HITPOINT_PLACE];
				
				var listOfLists:Array = (FlxG.scores[Bloodline.LISTS_PLACE] as Array);
				(listOfLists[listOfLists.length - 1] as Array).push(
					[
						FlxG.scores[Bloodline.STRENGTH_PLACE], 
						FlxG.scores[Bloodline.DEFENSE_PLACE],
						FlxG.scores[Bloodline.SPEED_PLACE],
					]
				);
			}
			
			_directionChoices = [DecisionData.DEF_CHOICE, DecisionData.SPD_CHOICE, DecisionData.STR_CHOICE];
			FlxU.shuffle(_directionChoices, 12);
			_directionChoices.splice(_entranceDir, 0, DecisionData.NO_CHOICE);
			
			for (var i:uint = 0; i < 4; i++ ) {
				if (_directionChoices[i] != DecisionData.NO_CHOICE) {
					var p:Powerup = new Powerup(_directionChoices[i]);
					switch(i) {
						case DIR_NORTH: 
							p.x = 7 * Bloodline.TILESIZE;
							p.y = 0;
							break;
						case DIR_EAST: 
							p.x = 9 * Bloodline.TILESIZE;
							p.y = 5 * Bloodline.TILESIZE;;
							break;
						case DIR_SOUTH: 
							p.x = 3 * Bloodline.TILESIZE;
							p.y = 7 * Bloodline.TILESIZE;;
							break;
						case DIR_WEST: 
							p.x = 0;
							p.y = 2 * Bloodline.TILESIZE;;
							break;
					}
					p.play("symbol");
					p.x += 8;
					p.y += 8;
					_symbolGroup.add(p);
				}
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
			wallPiece = new WallPiece(0, 5 * Bloodline.TILESIZE, Bloodline.TILESIZE, 2 * Bloodline.TILESIZE);
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
		}
		
		private function GoToSummary():void {
			FlxG.switchState(new SummaryState(_player.health > 0));
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
						_enemyGroup.active = true;
					}
					break;
				case COMBAT_STATE:
					if (_player.health <= 0) {
						FlxG.fade(0xff000000, 2, GoToSummary, false);
					}
					if (_enemyGroup.countLiving() <= 0) {
						//win, move on
						_state = POWERUP_STATE;
						startPowerup();
						_powerupFallTimer.NotifyMe(0, true);
						_player.InterActive = false;
					} else if (!_player.alive){
						_state = DEATH_STATE;
					}
					break;
				case POWERUP_STATE:
					if (_powerupFallTimer.Notify) {
						_state = COLLECT_STATE;
						if (_powerup) {
							_powerup.solid = true;
						}
						_player.InterActive = true;
					} else {
						if (_powerup) {
							_powerup.DoAnim(_powerupFallTimer.TimerFraction);
						}
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
			FlxG.collide(_enemyGroup, _player, enemyHitPlayer);
			FlxG.collide(_enemyGroup, _enemyGroup);
			//FlxG.collide(_wallGroup, _enemyGroup);
			//FlxG.collide(_doorGroup, _enemyGroup);
			FlxG.collide(_powerupGroup, _player, powerupHitPlayer);
			
			if (wasState != _state) {
				//FlxG.log("State changed to: " + _state);
			}
		}
		
		private function enemyHitPlayer(enemyObj:FlxObject, playerObj:FlxObject):void {
			var en:Monster = enemyObj as Monster;
			if (en.canHurt) {
				if (!playerObj.flickering) {
					//use the chance dictated by the blue power
					if (FlxG.random() < FlxG.scores[Bloodline.DEFENSE_PLACE] / Bloodline.MAX_GENERATIONS_FLOAT) {
						//fire a cool event
						var dummy:Fader =  new Fader(_player.x - margin, _player.y - margin, _player.width + 2 * margin, _player.height + 2 * margin, 0xff0000ff);
						_flashGroup.add(dummy);
					} else {
						playerObj.hurt(en.strength);
					}
				}
				en.canHurt = false;
			}
			setTexts();
		}
		
		private function powerupHitPlayer(powerupObj:FlxObject, playerObj:FlxObject):void {
			FlxG.play(SndPowerupGet);
			
			if (powerupObj is WinThing) {
				FlxG.fade(0xffffffff, 2, GoToSummary);
				powerupObj.solid = false;
				return;
			}
			
			powerupObj.kill();
			
			FlxG.scores[Bloodline.STRENGTH_PLACE + _latestChoice] += 1;
			(_metersGroup.members[_latestChoice] as HealthBar).Amount = FlxG.scores[Bloodline.STRENGTH_PLACE + _latestChoice] / Bloodline.MAX_GENERATIONS_FLOAT;
			(_metersGroup.members[_latestChoice] as HealthBar).Flicker();
			_player.ColorSprite();
			FlxG.log("Attribute " + _latestChoice + " increased by 1 and is now " + FlxG.scores[Bloodline.STRENGTH_PLACE + _latestChoice]);
		}
		
		private function determineNextRoomAndGo():void {
			var room:Room = null;
			if (_player.x <= 0) {
				room = new Room(DIR_EAST, _directionChoices[DIR_WEST]);
			} else if (_player.x + _player.width >= FlxG.width) {
				room = new Room(DIR_WEST, _directionChoices[DIR_EAST]);
			} else if (_player.y <= 0) {
				room = new Room(DIR_SOUTH, _directionChoices[DIR_NORTH]);
			} else if (_player.y + _player.height >= FlxG.height) {
				room = new Room(DIR_NORTH, _directionChoices[DIR_SOUTH]);
			}
			
			if (room) {
				FlxG.switchState(room);
			}
		}
		
		private function startPowerup():void {
			if (FlxG.scores[Bloodline.GENERATION_PLACE] == Bloodline.MAX_GENERATIONS) {
				var winthing:WinThing = new WinThing();
				var pt:Point = getFarFromPlayer();
				winthing.x = pt.x;
				winthing.y = pt.y;
				_powerupGroup.add(winthing);
			} else {
				if(_latestChoice != DecisionData.NO_CHOICE){
					_powerup = new Powerup(_latestChoice);
					_powerup.play("artifact");
					_powerup.InitFalling(getFarFromPlayer());
					_powerupGroup.add(_powerup);
				}
			}
		}
		
		private function setTexts():void {
			_genTxt.text = "GEN " + FlxG.scores[Bloodline.GENERATION_PLACE];
			_popTxt.text = "POP " + FlxG.scores[Bloodline.HITPOINT_PLACE];
		}
		
		private function getFarFromPlayer():Point {
			var isTooClose:Boolean = true;
			var thePoint:Point;
			while (isTooClose) {
				var x:int = int((1 + FlxG.random() * 7) * Bloodline.TILESIZE);
				var y:int = int((1 + FlxG.random() * 5) * Bloodline.TILESIZE);
				thePoint = new Point(x, y);
				//test closeness to player
				var testPoint:Point = new Point(_player.x + _player.width / 2 - x,
					_player.y + _player.height / 2 - y);
				var lng:Number = testPoint.length;
				if (lng > 3*Bloodline.TILESIZE) {
					isTooClose = false;
				}
			}
			return thePoint;
		}
		
		private function setupHud() : void {
			setTexts();
			
			_genTxt.setFormat(null, 8, 0xff000000);
			_popTxt.setFormat(null, 8, 0xff000000);
			_popTxt.y = _genTxt.y + _genTxt.height;
			var top:int = _popTxt.y + _popTxt.height;
			
			top = 32;
			
			for (var i:int = 0; i < 3; i++) {
				var healthbar:HealthBar = new HealthBar(i, 1, top, 30, 5);
				top += 6;
				healthbar.Amount = FlxG.scores[Bloodline.STRENGTH_PLACE + i] / Bloodline.MAX_GENERATIONS_FLOAT;
				_metersGroup.add(healthbar);
			}
			
			_hudGroup.add(_genTxt);
			_hudGroup.add(_popTxt);
			_hudGroup.add(_metersGroup);
		}
		
		private var onlyOne:Boolean;
		public function Attack() :void {
			var dummy:Fader =  new Fader(_player.x - margin, _player.y - margin, _player.width + 2 * margin, _player.height + 2 * margin, 0xffff0000);
			_flashGroup.add(dummy);
			onlyOne = true;
			FlxG.overlap(_enemyGroup, dummy, attackHitEnemy);
		}
		
		private function attackHitEnemy(obj:FlxObject, dummy:FlxObject) :void {
			if (onlyOne) {
				var power:int = int((10 * FlxG.scores[Bloodline.STRENGTH_PLACE] / Bloodline.MAX_GENERATIONS_FLOAT) + 1);
				obj.hurt(power);
				onlyOne = false;
			}
		}
	}
}
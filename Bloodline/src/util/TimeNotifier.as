package util 
{
	import org.flixel.*;
	
	public class TimeNotifier 
	{
		private static var _totalTime:Number = 0;
		public static function update() : void {
			_totalTime += FlxG.elapsed;
		}
		
		private var _notificationTime:Number = 0;
		private var _hasNotified:Boolean = false;
		private var _currentTimerLength:Number = 0;
		private var _defaultTimerTime:Number = 0;
		
		public function TimeNotifier(defaultTime:Number = 0)
		{
			_defaultTimerTime = defaultTime;
		}
		
        public function NotifyMe(howLong:Number = 0, overwritePrevious:Boolean = false) :Boolean
        {
			if (howLong == 0) {
				howLong = _defaultTimerTime;
			}
			
            if (_notificationTime == 0 || (hasTimeElapsed() && _hasNotified) || overwritePrevious)
            {
                //either:
                // no notification set yet
                // or timer has already elapsed AND we have already sent notification
                // or "overwrite" specified
                setTimer(howLong);
                return true;
            }

            return false;
        }
		
		private function hasTimeElapsed():Boolean
        {
            if (_notificationTime > 0 && _notificationTime <= _totalTime)
            {
                return true;
            }

            return false;
        }
		
		private function setTimer(howLong:Number):void {
			if (howLong <= 0)
            {
                //blat
            }
			
            _notificationTime = _totalTime + howLong;
            _currentTimerLength = howLong;
            _hasNotified = false;
		}
		
		public function get Notify():Boolean
        {
			if (hasTimeElapsed() && !_hasNotified)
			{
				_hasNotified = true;
				return true;
			}
			
			return false;
        }

	}
}
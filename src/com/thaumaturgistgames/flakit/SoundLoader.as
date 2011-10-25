package com.thaumaturgistgames.flakit
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.net.URLRequest;

	public class SoundLoader
    {
		private var filename:String;
		private var sndStream:URLRequest;
		private var sound:Sound;
		
		/**
		 * Load sound from file location
		 * @param	soundURL	The name of the file to load
		 */
		public function SoundLoader(soundURL:String)
        {
			sndStream = new URLRequest("../lib/" + soundURL);
			sound = new Sound(sndStream);
			sound.addEventListener(Event.COMPLETE, soundHandler);
			this.filename = soundURL;
        }

		private function soundHandler(e:Event):void
        {
			sound.removeEventListener(Event.COMPLETE, soundHandler);
			Library.addSound(this.filename.split("/").join("."), sound);
        }
    }
}

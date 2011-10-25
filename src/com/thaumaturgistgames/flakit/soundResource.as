package com.thaumaturgistgames.flakit
{
	import flash.media.Sound;
	
	/**
	 * Helper class to store a string/sound pair
	 */
	public class soundResource 
	{
		public var sound:Sound;
		public var name:String;
		
		public function soundResource(sound:Sound, name:String) 
		{
			this.sound = sound;
			this.name = name;
		}
		
	}

}
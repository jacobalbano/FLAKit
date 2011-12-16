package com.thaumaturgistgames.flakit
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.thaumaturgistgames.utils.Input;
	
	/**
	 * FLAKit bootloader
	 * @author Jake Albano
	 */
	
	public class Engine extends MovieClip
	{
		public function Engine():void 
		{
			if (stage) load();
			else addEventListener(Event.ADDED_TO_STAGE, load);
		}
		
		private function load(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, load);
			addEventListener(Event.ENTER_FRAME, loadLibrary);
			
			Library.init(stage, Library.IMAGE | Library.AUDIO);
			
			Input.init(stage);
		}
		
		private function loadLibrary(e:Event):void 
		{
			beginLoadingScreen();
			
			if (Library.loaded)
			{
				removeEventListener(Event.ENTER_FRAME, loadLibrary);
				init();
			}
		}
		
		public function init():void
		{
			endLoadingScreen();
			
			//	Entry point
		}
		
		public function beginLoadingScreen():void 
		{
			//	Override this
		}
		
		
		public function endLoadingScreen():void 
		{
			//	Override this
		}
		
	}
	
}
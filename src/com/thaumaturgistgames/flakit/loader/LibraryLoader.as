package com.thaumaturgistgames.flakit.loader
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
    public class LibraryLoader
    {
        private var loader:URLLoader;
		
		public var XMLData:XML;
		private var listener:Function;
    
        public function LibraryLoader(listener:Function)
        {
			this.listener = listener;
			
			loader = new URLLoader(new URLRequest("../lib/library.xml"));
            loader.addEventListener(Event.COMPLETE, onComplete);
			loader.addEventListener("xmlLoaded", listener);
        }
    
        private function onComplete(event:Event):void
        {
			XMLData = new XML(loader.data);
			loader.removeEventListener(Event.COMPLETE, onComplete);
			loader.dispatchEvent(new Event("xmlLoaded"));
			loader.removeEventListener("xmlLoaded", listener);
        }
    }
}
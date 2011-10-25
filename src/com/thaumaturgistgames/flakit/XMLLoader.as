package com.thaumaturgistgames.flakit
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
    public class XMLLoader
    {
        private var loader:URLLoader = new URLLoader(new URLRequest("../lib/library.xml"));
		
		public var XMLData:XML;
		public var loaded:Boolean;
    
        public function XMLLoader()
        {
            loader.addEventListener(Event.ACTIVATE, onActivated);
            loader.addEventListener(Event.COMPLETE, onComplete);
            loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
        }
    
        private function onActivated(event:Event):void
        {
            //trace("Load of XML library initialized.");
        }
    
        private function onComplete(event:Event):void
        {
            //trace("Load of XML library complete.");
						
			XMLData = new XML(loader.data);
			loaded = true;
        }
    
        private function onProgress(event:Event):void
        {
            //trace("Load of XML library progress:", loader.bytesLoaded, "out of", loader.bytesTotal, "bytes.");
        }
    }
}
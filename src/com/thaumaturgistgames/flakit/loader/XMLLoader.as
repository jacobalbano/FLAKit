package com.thaumaturgistgames.flakit.loader
{
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import com.thaumaturgistgames.flakit.Library;
	
    public class XMLLoader
    {
        private var loader:URLLoader;
		private var filename:String;
		public var xml:XML;
    
        /**
		 * Load xml from file location
		 * @param	xmlURL	The name of the file to load
		 */
		public function XMLLoader(xmlURL:String)
        {			
			loader = new URLLoader(new URLRequest("../lib/" + xmlURL));
            loader.addEventListener(Event.COMPLETE, onComplete);
			
			this.filename = xmlURL;
        }
    
        private function onComplete(event:Event):void
        {
            //trace("Load of XML library complete.");
			xml = new XML(loader.data);
			loader.removeEventListener(Event.COMPLETE, onComplete);
			Library.addXML(filename, xml);
        }
    }
}
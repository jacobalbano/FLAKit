package com.thaumaturgistgames.flakit
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	import XML;
	
	public class Library 
	{
		public static const EmbedMode:int = 1;
		public static const DynamicMode:int = 0;
		
		/**
		 * Whether loading logs should be traced to the console.
		 */
		public var traceLogs:Boolean = false;
		
		/**
		 * The function to call when loading/reloading is finished.
		 */
		public var onLoadComplete:Function;
		
		private var images:Dictionary;
		private var sounds:Dictionary;
		private var xmldocs:Dictionary;
		
		private var loaders:Array;
		
		private var mode:int;
		private var path:String;
		private var loading:Boolean;
		
		/**
		 * Constructor.
		 * @param	path The folder containing your assets, relative to the SWF output directory.
		 * @param	mode Either Library.EmbedMode or Library.DynamicMode
		 * @param	onLoadComplete A function to call the first time the library has finished loading its assets.
		 */
		public function Library(path:String, mode:int, onLoadComplete:Function = null)
		{
			this.path = path || "";
			this.mode = mode;
			this.onLoadComplete = onLoadComplete;
			
			if (this.path.length > 0 && this.path.charAt(this.path.length - 1) != "/")
				this.path += "/";
			
			images = new Dictionary;
			sounds = new Dictionary;
			xmldocs = new Dictionary;
			
			reload();
		}
		
		public function reload():void
		{
			if (loading) return;
			
			if (mode == Library.DynamicMode)
			{
				loading = true;
				function onComplete(e:Event):void {
					loader.removeEventListener(Event.COMPLETE, onComplete);
					xmlLoaded(new XML(loader.data));
					loading = false;
				}
				
				if (path.length > 0 && path.charAt(path.length - 1) != "/")
					path += "/";
					
				var loader:URLLoader = new URLLoader(new URLRequest(path + "Library.xml"));
				loader.addEventListener(Event.COMPLETE, onComplete);
			}
		}
		
		/**
		 * Retrive an XML document
		 * @param	name	The filename of the xml file to load
		 * @return			The document
		 */
		public function getXML(name:String):XML
		{
			var xml:XML = xmldocs[name];
			if (xml)
			{
				return xml;
			}
			
			throw new Error("The document \"" + name + "\" does not exist in the library.");
		}
		
		/**
		 * Retrive an image loaded at runtine
		 * @param	name	The filename of the image to load
		 * @return			The loaded image
		 */
		public function getImage(name:String):Bitmap
		{
			var image:Bitmap = images[name];
			if (image)
			{
				return image;
			}
			
			throw new Error("The image \"" + name + "\" does not exist in the library.");
		}
		
		public function getSound(name:String):Sound
		{
			var sound:Sound = sounds[name];
			if (sound)
			{
				return sound;
			}
			
			throw new Error("The sound \"" + name + "\" does not exist in the library.");
		}
		
		public function loadEmbedded(embeddedAssets:EmbeddedAssets):void 
		{
			for (var x:String in embeddedAssets.xml)
				xmldocs[x] = embeddedAssets.xml[x];
				
			for (var b:String in embeddedAssets.images)
				images[b] = embeddedAssets.images[b];
				
			for (var s:String in embeddedAssets.sounds)
				sounds[s] = embeddedAssets.sounds[s];
				
			if (onLoadComplete != null)
				onLoadComplete();
		}
		
		private function removeLoader(type:String, loader:Object):void 
		{
			var i:int = loaders.indexOf(loader);
			if (i >= 0)
			{
				loaders.splice(i, 1);
				log("removed", type + " loader,", "loader count is now", loaders.length);
			}
			else
			{
				log("error removing loader", loader);
			}
			
			if (loaders.length == 0 && onLoadComplete != null)
				onLoadComplete();
		}
		
		private function log(...args):void 
		{
			if (traceLogs) trace.apply(null, args);
		}
		
		private function xmlLoaded(xml:XML):void
		{
			loaders = [];
			
			for each (var imagename:String in xml.images.image)
			{
				var imgStream:Loader = new Loader();
				loaders[loaders.length] = imgStream;
				
				imgStream.contentLoaderInfo.addEventListener(Event.COMPLETE, makeImageHandler(imagename, imgStream));
				imgStream.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, makeIOErrorHandler(imagename));
				imgStream.load(new URLRequest(path + imagename));
				log("added image loader for", imagename, "-- count is now", loaders.length);
			}
			
			for each (var soundname:String in xml.sounds.sound)
			{
				var sndStream:URLRequest = new URLRequest(path + soundname);
				loaders[loaders.length] = sndStream;
				
				var sound:Sound = new Sound(sndStream);
				sound.addEventListener(Event.COMPLETE, makeSoundHandler(soundname, sound, sndStream));
				sound.addEventListener(IOErrorEvent.IO_ERROR, makeIOErrorHandler(soundname));
				log("added sound loader for", soundname, "-- count is now", loaders.length);
			}
			
			for each (var docname:String in xml.xmls.xml)
			{
				var xmlStream:URLLoader = new URLLoader(new URLRequest(path + docname));
				loaders[loaders.length] = xmlStream;
				
				xmlStream.addEventListener(Event.COMPLETE, makeXmlHandler(docname, xmlStream));
				xmlStream.addEventListener(IOErrorEvent.IO_ERROR, makeIOErrorHandler(docname));
				log("added xml loader for", docname, "-- count is now", loaders.length);
			}
			
			if (loaders.length == 0 && onLoadComplete != null)
				onLoadComplete();
		}
		
		private function makeIOErrorHandler(name:String):Function
		{
			return function(e:IOErrorEvent):void
			{
				throw new Error("Failed to load asset '" + name + "'");
			}
		}
		
		private function makeImageHandler(imagename:String, imgStream:Loader):Function
		{
			var handler:Function = function (e:Event):void {
				e.target.removeEventListener(Event.COMPLETE, handler);
				images[imagename] = Bitmap(e.target.content);
				removeLoader("image", imgStream);
			}
			
			return handler;
		}
		
		private function makeSoundHandler(soundname:String, sound:Sound, sndStream:URLRequest):Function
		{
			var handler:Function = function (e:Event):void {
				sound.removeEventListener(Event.COMPLETE, handler);
				sound[soundname] = sound;
				removeLoader("sound", sndStream);
			}
			
			return handler;
		}
		
		private function makeXmlHandler(docname:String, xmlStream:URLLoader):Function
		{
			var handler:Function = function (e:Event):void {
				xmlStream.removeEventListener(Event.COMPLETE, handler);
				xmldocs[docname] = new XML(xmlStream.data);
				removeLoader("xml", xmlStream);
			}
			
			return handler;
		}
	}

}
package com.thaumaturgistgames.flakit
{
	import flash.display.Bitmap;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.media.Sound;
	import XML;
	
	public class Library 
	{
		
		private static var loadFlags:int;
		private static var totalImages:uint;
		private static var totalSounds:uint;
		private static var loadedImages:uint;
		private static var loadedSounds:uint;
		private static var _loaded:Boolean = false;
		private static var imageResources:Vector.<imageResource>;
		private static var soundResources:Vector.<soundResource>;
		private static var isInitialized:Boolean;
		private static var stage:Stage;
		private static var loader:XMLLoader;
		
		public function Library() 
		{
			//	Pure static classes cannot be created as objects
			throw new Error("Cannot instantiate the Library class!");
		}
		
		/**
		 * Initialize the Library so it can be accessed
		 * @param	s		A reference to the stage, for internal event management
		 * @param	flags	Which components to initialize
		 */
		public static function init(s:Stage, flags:int):void
		{
			stage = s;
			
			imageResources = new Vector.<imageResource>;
			soundResources = new Vector.<soundResource>;
			
			totalImages = 0;
			loadedImages = 0;
			
			totalSounds = 0;
			loadedSounds = 0;
			
			loadFlags = flags;
			
			stage.addEventListener(Event.ENTER_FRAME, xmlLoaded);
			
			loader = new XMLLoader;
			
			isInitialized = true;
		}
		
		/**
		 * Add a new image to the library
		 * @param	name	The image identifier
		 * @param	image	The Bitmap to add
		 */
		public static function addImage(name:String, image:Bitmap):void
		{
			checkInit();
			
			imageResources.push(new imageResource(image, name));
			loadedImages++;
		}
		
		/**
		 * Add a new sound to the library
		 * @param	name	The sound identifier
		 * @param	sound	The sound to add
		 */
		public static function addSound(name:String, sound:Sound):void
		{
			checkInit();
			
			soundResources.push(new soundResource(sound, name));
			loadedSounds++;
		}
		
		/**
		 * Retrive an image loaded at runtine
		 * @param	name	The filename of the image to load
		 * @return			A bitmap object loaded at runtime
		 */
		public static function IMG(name:String):Bitmap
		{
			checkInit();
			
			for each (var item:imageResource in imageResources) 
			{
				if (item.name == name) return item.image;
			}
			
			throw new Error("The image \"" + name + "\" does not exist in the library.");
		}
		
		public static function SND(name:String):Sound
		{
			checkInit();
			
			for each (var item:soundResource in soundResources) 
			{
				if (item.name == name) return item.sound;
			}
			
			throw new Error("The image \"" + name + "\" does not exist in the library.");
		}
		
		/**
		 * Whether all media has been loaded into the Library
		 */
		public static function get loaded():Boolean
		{
			checkInit();
			
			return _loaded;
		}
		
		/**
		 * The load status of the Library, for loading screens
		 */
		public static function get loadPercentage():Number
		{
			checkInit();
			
			var result:Number = loadedImages + loadedSounds / totalImages + totalSounds * 100;
			return isNaN(result) ? 0 : result;
		}
		
		public static const IMAGE:int = 2;
		public static const AUDIO:int = 4;
		
		//	Listeners
		static private function imagesLoaded(e:Event):void 
		{
			_loaded = (totalImages == imageResources.length && totalSounds == soundResources.length);
		}
		
		private static function xmlLoaded(e:Event):void
		{
			if (loader.loaded)
			{
				stage.removeEventListener(Event.ENTER_FRAME, xmlLoaded);
				
				if ((loadFlags & IMAGE) > 0)
				{
					for each (var imagename:XML in loader.XMLData.images.image) 
					{
						new ImageLoader(imagename);
						totalImages++;
					}
				}
				
				if ((loadFlags & AUDIO) > 0)
				{
					for each (var soundname:XML in loader.XMLData.sounds.sound) 
					{
						new SoundLoader(soundname);
						totalSounds++;
					}
				}
				
				stage.addEventListener(Event.ENTER_FRAME, imagesLoaded);
			}
		}
		
		//	Make sure Library.init(stage) has been called already
		private static function checkInit():void
		{
			
			if (!isInitialized)		throw new Error("Library hasn't been initialized!");
		}
		
	}

}
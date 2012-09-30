package com.thaumaturgistgames.flakit
{
	import flash.display.Bitmap;
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
		private static var imageResources:Vector.<imageResource>;
		private static var soundResources:Vector.<soundResource>;
		private static var isInitialized:Boolean;
		private static var engine:Engine;
		private static var loader:XMLLoader;
		
		public static const USE_IMAGES:int = 2;
		public static const USE_AUDIO:int = 4;
		public static const USE_EMBEDDED:uint = 8;
		public static const USE_ALL:uint = USE_AUDIO | USE_IMAGES;
		
		public function Library() 
		{
			//	Pure static classes cannot be created as objects
			throw new Error("Cannot instantiate the Library class!");
		}
		
		/**
		 * Initialize the Library so it can be accessed
		 * @param	engine	A reference to the document class, for event tracking
		 * @param	flags	Which components to initialize
		 */
		public static function init(parent:Engine, flags:int):void
		{
			engine = parent;
			
			imageResources = new Vector.<imageResource>;
			soundResources = new Vector.<soundResource>;
			
			if (flags & Library.USE_EMBEDDED)
			{
				isInitialized = true;
				return;
			}
			
			totalImages = 0;
			loadedImages = 0;
			
			totalSounds = 0;
			loadedSounds = 0;
			
			loadFlags = flags;
			
			loader = new XMLLoader(xmlLoaded);
			
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
			if (++loadedImages >= totalImages && loadedSounds >= totalSounds)
			{
				engine.dispatchEvent(new Event("libraryLoaded"));
			}
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
			
			if (++loadedSounds >= totalSounds && loadedImages >= totalImages)
			{
				engine.dispatchEvent(new Event("libraryLoaded"));
			}
		}
		
		/**
		 * Retrive an image loaded at runtine
		 * @param	name	The filename of the image to load
		 * @return			A bitmap object loaded at runtime
		 */
		public static function getImage(name:String):Bitmap
		{
			checkInit();
			
			for each (var item:imageResource in imageResources) 
			{
				if (item.name == name) return new Bitmap(item.image.bitmapData);
			}
			
			throw new Error("The image \"" + name + "\" does not exist in the library.");
		}
		
		public static function getSound(name:String):Sound
		{
			checkInit();
			
			for each (var item:soundResource in soundResources) 
			{
				if (item.name == name) return item.sound;
			}
			
			throw new Error("The sound \"" + name + "\" does not exist in the library.");
		}
		
		private static function xmlLoaded(e:Event):void
		{
			if ((loadFlags & USE_IMAGES) > 0)
			{
				for each (var imagename:XML in loader.XMLData.images.image) 
				{
					new ImageLoader(imagename);
					totalImages++;
				}
			}
			
			if ((loadFlags & USE_AUDIO) > 0)
			{
				for each (var soundname:XML in loader.XMLData.sounds.sound) 
				{
					new SoundLoader(soundname);
					totalSounds++;
				}
			}
		}
		
		/**
		 * Make sure Library.init() has been called already
		 */
		private static function checkInit():void
		{
			
			if (!isInitialized)		throw new Error("Library hasn't been initialized!");
		}
		
	}

}
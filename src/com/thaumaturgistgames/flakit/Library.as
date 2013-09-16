﻿package com.thaumaturgistgames.flakit
{
	import com.thaumaturgistgames.display.Sprite;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.media.Sound;
	import com.thaumaturgistgames.flakit.loader.*;
	import flash.utils.Dictionary;
	import XML;
	
	public class Library 
	{
		
		private static var loadFlags:Boolean;
		
		public static var totalImages:uint;
		public static var totalSounds:uint;
		public static var totalXMLs:uint;
		
		private static var loadedImages:uint;
		private static var loadedSounds:uint;
		private static var loadedXMLs:uint;
		
		private static var imageResources:Dictionary;
		private static var soundResources:Dictionary;
		private static var XMLResources:Dictionary;
		
		private static var isInitialized:Boolean;
		private static var engine:Engine;
		private static var loader:LibraryLoader;
		
		public static const USE_EMBEDDED:Boolean = true;
		public static const USE_XML:Boolean = false;
		
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
		public static function init(parent:Engine, flags:Boolean):void
		{
			if (!isInitialized)
			{
				engine = parent;
				
				imageResources = new Dictionary;
				soundResources = new Dictionary;
				XMLResources = new Dictionary;
				
				totalImages = 0;
				loadedImages = 0;
				
				totalSounds = 0;
				loadedSounds = 0;
				
				totalXMLs = 0;
				loadedXMLs = 0;
				
				loadFlags = flags;
				
				if ((flags == Library.USE_EMBEDDED))
				{
					isInitialized = true;
					return;
				}
				
				loader = new LibraryLoader(xmlLoaded);
				
				isInitialized = true;	
			}
			else
			{
				if (flags == Library.USE_XML)
				{
					totalImages = 0;
					loadedImages = 0;
					
					totalSounds = 0;
					loadedSounds = 0;
					
					totalXMLs = 0;
					loadedXMLs = 0;
					
					loadFlags = flags;
					
					loader = new LibraryLoader(xmlLoaded);
				}
			}
		}
		
		/**
		 * Add a new XML document to the library
		 * @param	name	The XML identifier
		 * @param	xml		The XML to add
		 */
		public static function addXML(name:String, xml:XML):void
		{
			checkInit();
			
			XMLResources[name] = xml;
			
			if (++loadedXMLs >= totalXMLs && loadedImages >= totalImages && loadedSounds >= totalSounds)
			{
				notifyLoaded();
			}
		}
		
		/**
		 * Add a new image to the library
		 * @param	name	The image identifier
		 * @param	image	The Bitmap to add
		 */
		public static function addImage(name:String, image:Bitmap):void
		{
			checkInit();
			
			imageResources[name] = image;
			
			if (++loadedImages >= totalImages && loadedSounds >= totalSounds && loadedXMLs >= totalXMLs)
			{
				notifyLoaded();
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
			
			soundResources[name] = sound;
			
			if (++loadedSounds >= totalSounds && loadedImages >= totalImages && loadedXMLs >= totalXMLs)
			{
				notifyLoaded();
			}
		}
		
		static private function notifyLoaded():void 
		{
			checkInit();
			
			if (loadFlags == Library.USE_EMBEDDED)
			{
				return;
			}
			
			engine.dispatchEvent(new Event("libraryLoaded"));
		}
		
		/**
		 * Retrive a sprite containing image loaded at runtine
		 * @param	name	The filename of the image to load
		 * @return			A sprite containing the image
		 */
		public static function getSprite(name:String):Sprite
		{
			checkInit();
			
			var bmp:Bitmap = getImage(name);
			var image:Sprite = new Sprite(bmp);
			image.filename = name;
			
			return image;
		}
		
		/**
		 * Retrive an image loaded at runtine
		 * @param	name	The filename of the image to load
		 * @return			The loaded image
		 */
		public static function getXML(name:String):XML
		{
			checkInit();
			
			var xml:XML = XMLResources[name];
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
		public static function getImage(name:String):Bitmap
		{
			checkInit();
			
			var image:Bitmap = imageResources[name];
			if (image)
			{
				return image;
			}
			
			throw new Error("The image \"" + name + "\" does not exist in the library.");
		}
		
		public static function getSound(name:String):Sound
		{
			checkInit();
			
			var sound:Sound = soundResources[name];
			if (sound)
			{
				return sound;
			}
			
			throw new Error("The sound \"" + name + "\" does not exist in the library.");
		}
		
		private static function xmlLoaded(e:Event):void
		{
			for each (var imagename:XML in loader.XMLData.images.image) 
			{
				new ImageLoader(imagename);
				totalImages++;
			}
			
			for each (var soundname:XML in loader.XMLData.sounds.sound) 
			{
				new SoundLoader(soundname);
				totalSounds++;
			}
			
			for each (var docname:XML in loader.XMLData.xmls.xml) 
			{
				new XMLLoader(docname);
				totalXMLs++;
			}
			
			if (!(totalImages || totalSounds || totalXMLs))
			{
				notifyLoaded();
			}
		}
		
		/**
		 * Make sure Library.init() has been called already
		 */
		private static function checkInit():void
		{
			if (!isInitialized)
			{
				throw new Error("Library hasn't been initialized!");
			}
		}
		
	}

}
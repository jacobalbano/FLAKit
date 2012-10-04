package com.thaumaturgistgames.flakit
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.thaumaturgistgames.utils.Input;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	/**
	 * FLAKit bootloader
	 * @author Jake Albano
	 */
	
	public class Engine extends MovieClip
	{
		private var flags:uint;
		private var isInitialized:Boolean;
		public var console:Console;
		public static var game:Game;
		public static var engine:Engine;
		
		/**
		 * Creates a new engine base
		 * @param	flags	Behavior flags for the Library class
		 * @param	resourceClass	Optionally, you can pass in a class type containing embedded assets, like the one generated by
		 * the EmbeddedLibraryBuilder tool. In order for this to work, the flag must be set to Library.USE_EMBEDDED. Not compatible
		 * with Flash Professional unless the Flex SDK is installed
		 */
		public function Engine(flags:uint = 0, resourceClass:Class = null)
		{
			isInitialized = false;
			
			game = (this as Game);
			engine = this;
			
			this.flags = flags;
			console = new Console();
			addChild(console);
			
			console.slang.addFunction("reload", reloadLibrary, [], this, "Reloads library assets");
			
			addEventListener(KeyboardEvent.KEY_UP, refresh);
			
			if ((this.flags & Library.USE_EMBEDDED) && resourceClass)
			{
				Library.init(this, flags);
				
				new resourceClass;
				
				Input.init(this);
				
				init();
			}
			else
			{
				if ((this.flags & Library.USE_AUDIO) || (this.flags & Library.USE_IMAGES))
				{
					if (stage) load();
					else addEventListener(Event.ADDED_TO_STAGE, load);
				}
				else
				{
					init();
				}
			}
			
		}
		
		private function refresh(event:KeyboardEvent):void
		{
			if (event.keyCode == Keyboard.F5)
			{
				console.slang.doLine("reload");
			}
		}
		
		private function reloadLibrary():void 
		{
			Library.init(this, flags);
		}
		
		private function load(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, load);
			this.addEventListener("libraryLoaded", loaded);
			
			Library.init(this, flags);
			
			Input.init(this);
		}
		
		private function loaded(event:Event):void
		{
			console.print("Library loaded:", Library.totalImages, Library.totalImages == 1 ? "image," : "images,", Library.totalSounds, Library.totalSounds == 1 ? "sound," : "sounds,", Library.totalXMLs, "xml", Library.totalXMLs == 1 ? "file" : "files");
			
			if (!isInitialized)
			{
				isInitialized = true;
				init();
			}
		}
		
		public function init():void
		{
			//	Entry point
		}
	}
	
}
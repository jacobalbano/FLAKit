package com.thaumaturgistgames.display 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.flakit.Engine;
	
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class Sprite extends flash.display.Sprite 
	{
		public var filename:String;
		protected var bitmap:Bitmap;
		
		public function Sprite(bmp:Bitmap = null) 
		{
			if (bmp)
			{
				bitmap = new Bitmap(bmp.bitmapData.clone());
				addChild(bitmap);
			}
			
			Engine.engine.addEventListener("libraryLoaded", reloadEvent)
		}
		
		public function get image():Bitmap
		{
			return bitmap;
		}
		
		public function onReloaded():void
		{
			if (bitmap && bitmap.parent)
			{
				removeChild(bitmap);
			}
			
			bitmap = Library.getImage(filename);
			addChild(bitmap);
		}
		
		public function reloadEvent(event:Event):void
		{
			onReloaded();
		}
	}

}
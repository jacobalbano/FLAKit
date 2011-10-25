package com.thaumaturgistgames.flakit
{
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLRequest;

	public class ImageLoader
    {
		private var filename:String;
		private var imgStream:Loader;
		
		/**
		 * Load image from file location
		 * @param	imageURL	The name of the file to load
		 */
		public function ImageLoader(imageURL:String)
        {
			imgStream = new Loader();
			imgStream.contentLoaderInfo.addEventListener(Event.COMPLETE, imageHandler);
			imgStream.load(new URLRequest("../lib/" + imageURL));
			this.filename = imageURL;
        }

		private function imageHandler(e:Event):void
        {
			imgStream.removeEventListener(Event.COMPLETE, imageHandler);
			Library.addImage(this.filename.split("/").join("."), e.target.content);
        }
    }
}

package com.thaumaturgistgames.flakit.resource
{
	import flash.display.Bitmap;
	
	/**
	 * Helper class to store a string/bitmap pair
	 */
	public class imageResource 
	{
		public var image:Bitmap;
		public var name:String;
		
		public function imageResource(image:Bitmap, name:String) 
		{
			this.image = image;
			this.name = name;
		}
		
	}

}
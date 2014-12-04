package
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Bitmap;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	* Generated with LibraryBuilder for FLAKit
	* http://www.thaumaturgistgames.com/FLAKit
	*/
	public class EmbeddedAssets
	{
		[Embed(source = "../lib/Library.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1371418527:Class;
		
		public function EmbeddedAssets()
		{
			xml = new Dictionary;
			images = new Dictionary;
			sounds = new Dictionary;
			addXML("Library.xml", getXML(FLAKIT_ASSET$_1371418527));
		}
		private function getXML(c:Class):XML{var d:ByteArray = new c;var s:String = d.readUTFBytes(d.length);return new XML(s);}
		private function addXML(f:String, x:XML):void { xml[f] = x; }
		private function addImage(f:String, b:Bitmap):void { images[f] = b; }
		private function addSound(f:String, s:Sound):void { sounds[f] = s; }
		
		public var xml:Dictionary, images:Dictionary, sounds:Dictionary;
	}
}

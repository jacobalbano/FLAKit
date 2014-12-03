package
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width = "800", height = "600")]
	public class Game extends Sprite 
	{
		public static var library:Library;
		
		public function Game()
		{
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, initLibrary);
		}
		
		public function initLibrary(e:Event):void
		{
			library = new Library("../lib", Library.DynamicMode, init);
		}
		
		public function init():void 
		{
			//	Entry point
			trace("initialized");
		}
	}

}
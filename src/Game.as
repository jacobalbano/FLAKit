package
{
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.flakit.Engine;
	
	[SWF(width = "800", height = "600")]
	public class Game extends Engine 
	{
		
		public function Game()
		{
			//	Initialize library
			super(Library.USE_ALL);
		}
		
		override public function beginLoadingScreen():void 
		{
			//	Your loading screen goes here
		}
		
		override public function endLoadingScreen():void 
		{
			//	Remove your loading screen if you added one
		}
		
		override public function init():void 
		{
			super.init();			
			//	Entry point
		}
		
	}

}
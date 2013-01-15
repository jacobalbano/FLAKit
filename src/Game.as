package
{
	import com.thaumaturgistgames.flakit.Library;
	import com.thaumaturgistgames.flakit.Engine;
	import com.jacobalbano.slang.*;
	
	[SWF(width = "800", height = "600")]
	public class Game extends Engine 
	{
		public function Game()
		{
			//	Initialize library
			super(Library.USE_XML);
		}
		
		override public function init():void 
		{
			super.init();
			//	Entry point
			
			console.slang.addFunction(new SlangFunction("print", print).paramCount(1).self(this));
		}
		
		private function print(s:String):void
		{
			console.print(s);
		}
	}

}
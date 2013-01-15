package com.jacobalbano.slang 
{
	/**
	 * ...
	 * @author Jake Albano
	 */
	public class SlangSTD 
	{
		
		public function SlangSTD() 
		{
		}
		
		public static function sIf(b:Boolean, s:Scope):void
		{
			if (b)
			{
				s.execute();
			}
		}
		
		public static function sIfElse(b:Boolean, s1:Scope, s2:Scope):void
		{
			if (b)
			{
				s1.execute();
			}
			else
			{
				s2.execute();
			}
		}
		
		public static function sNot(b:Boolean):Boolean
		{
			return !b;
		}
		
	}

}
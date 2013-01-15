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
		
		public static function sAnd(b1:Boolean, b2:Boolean):Boolean
		{
			return b1 && b2;
		}
		
		public static function sOr(b1:Boolean, b2:Boolean):Boolean
		{
			return b1 || b2;
		}
		
	}

}
package com.thaumaturgistgames.flakit.resource
{
	
	import XML;
	
	/**
	 * Helper class to store a string/xml pair
	 */
	public class XMLResource 
	{
		public var xml:XML;
		public var name:String;
		
		public function XMLResource(xml:XML, name:String) 
		{
			this.xml = xml;
			this.name = name;
		}
		
	}

}
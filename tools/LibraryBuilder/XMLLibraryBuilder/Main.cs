using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Data.SqlClient;

/// <summary>
/// Recursively searches a directory and generates an XML file to load image and sound assets
/// </summary>
class Program
{

	public static void Main ()
	{
		XmlWriterSettings settings = new XmlWriterSettings ();
		settings.Indent = true;
		settings.IndentChars = "    ";
		List<string> images = RecursiveAssetIterator.GetImages(@".");
		List<string> sounds = RecursiveAssetIterator.GetSounds(@".");
		
		using (XmlWriter writer = XmlWriter.Create("Library.xml", settings))
		{
			writer.WriteComment ("Created with LibraryBuilder for FLAkit ");
			writer.WriteComment ("http://www.thaumaturgistgames.com/FLAkit");
			writer.WriteStartElement ("library");
			
			writer.WriteStartElement ("images");
			
			foreach (string i in images)
			{
				string rem = i.Replace ('\\', '/');
				rem = rem.Remove(0, 2);
				writer.WriteElementString ("image", rem);
			}
			
			writer.WriteEndElement();
			writer.WriteStartElement ("sounds");
			
			foreach (string s in sounds)
			{
				string rem = s.Replace ('\\', '/');
				rem = rem.Remove(0, 2);
				writer.WriteElementString ("sound", rem);
			}
			
			writer.WriteEndElement ();
			writer.Flush ();
			
		}
	}
};
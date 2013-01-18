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

	public static void Main (string[] args)
	{
		XmlWriterSettings settings = new XmlWriterSettings ();
		settings.Indent = true;
		settings.IndentChars = "    ";
		
		List<string> images = RecursiveAssetIterator.GetImages(@".");
		List<string> sounds = RecursiveAssetIterator.GetSounds(@".");
		List<string> xmls = RecursiveAssetIterator.GetXMLFiles(@".");
		
		string outPath = "Library.xml";
		
		if (args.Length == 1)
		{
			string path = args[0];
			
			path.Replace('\\', '/');
			
			if (!path.EndsWith("/"))
			{
				path += "/";
			}
			
			outPath = path + outPath;
		}
		
		using (XmlWriter writer = XmlWriter.Create(outPath, settings))
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
			
			writer.WriteStartElement ("xmls");
			
			foreach (string s in xmls)
			{
				string rem = s.Replace ('\\', '/');
				rem = rem.Remove(0, 2);
				writer.WriteElementString ("xml", rem);
			}
			
			writer.WriteEndElement ();
			
			writer.Flush ();
			
		}
	}
};
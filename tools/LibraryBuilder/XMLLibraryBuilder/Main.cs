using System;
using System.Collections.Generic;
using System.Text;
using System.IO;
using System.Xml;
using System.Data.SqlClient;

class Program
{

	public static void Main ()
	{
		XmlWriterSettings settings = new XmlWriterSettings ();
		settings.Indent = true;
		settings.IndentChars = "    ";
		List<string> images = GetImages (@".");
		List<string> sounds = GetSounds (@".");
		List<string> fonts  = GetFonts  (@".");
		
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
//			writer.WriteStartElement("fonts");
			
//			foreach (string f in fonts)
//			{
//				string rem = f.Replace ('\\', '/');
//				rem = rem.Remove(0, 2);
//				writer.WriteElementString ("font", rem);
//			}
			
//			writer.WriteEndElement ();
			writer.Flush ();
			
		}
	}
	
	public static List<string> GetImages (string directory)
	{
		List<string> result = new List<string> ();
		Stack<string> stack = new Stack<string> ();

		stack.Push (directory);

		while (stack.Count > 0)
		{
			string dir = stack.Pop ();

			try
			{
				result.AddRange (Directory.GetFiles (dir, "*.png"));
				result.AddRange (Directory.GetFiles (dir, "*.jpg"));
				result.AddRange (Directory.GetFiles (dir, "*.jpeg"));
				result.AddRange (Directory.GetFiles (dir, "*.bmp"));
				result.AddRange (Directory.GetFiles (dir, "*.gif"));

				foreach (string name in Directory.GetDirectories(dir))
				{
					stack.Push (name);
				}
			}
			catch
			{
				// Could not open the directory
			}
		}
		
		return result;
	}
	
	public static List<string> GetSounds (string b)
	{
		List<string> result = new List<string> ();
		Stack<string> stack = new Stack<string> ();

		stack.Push (b);

		while (stack.Count > 0)
		{
			string dir = stack.Pop ();

			try
			{
				result.AddRange (Directory.GetFiles (dir, "*.mp3"));
				result.AddRange (Directory.GetFiles (dir, "*.wav"));
				result.AddRange (Directory.GetFiles (dir, "*.aac"));
				result.AddRange (Directory.GetFiles (dir, "*.m4a"));

				foreach (string dn in Directory.GetDirectories(dir))
				{
					stack.Push (dn);
				}
			}
			catch
			{
				// Could not open the directorectory
			}
		}
		
		return result;
	}
	
	public static List<string> GetFonts (string b)
	{
		List<string> result = new List<string> ();
		Stack<string> stack = new Stack<string> ();

		stack.Push (b);

		while (stack.Count > 0)
		{
			string dir = stack.Pop ();

			try
			{
				result.AddRange (Directory.GetFiles (dir, "*.ttf"));

				foreach (string dn in Directory.GetDirectories(dir))
				{
					stack.Push (dn);
				}
			}
			catch
			{
				// Could not open the directorectory
			}
		}
		
		return result;
	}
};
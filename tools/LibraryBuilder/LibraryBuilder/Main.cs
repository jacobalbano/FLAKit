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
	static List<string> images = GetImages(@".");
	static List<string> sounds = GetSounds(@".");
	static List<string> xmls = GetXMLFiles(@".");
	
	private static string GetPath(string path)
	{
		path.Replace('\\', '/');
			
		if (!path.EndsWith("/"))
			path += "/";
		
		return path;
	}
	
	private static void ShowHelp()
	{
		var help = @"
Switches:
	--help		Show this screen and exit
	--as3 <path> 	Set output folder for the generated as3 class file
	--xml <path>	Set output folder for the generated xml file";
		Console.WriteLine(help);
	}
	
	public static void Main (string[] args)
	{
		
		string xmlPath = "Library.xml";
		string as3Path = "EmbeddedAssets.as";
		
		if (args.Length > 0)
		{
			for (int i = 0; i < args.Length; i++) {
				if (args[i] == "--help")
				{
					ShowHelp();
					return;
				}
				else if (args[i] == "--as3")
				{
					if (i + 1 < args.Length)
						as3Path = GetPath(args[i + 1]) + as3Path;
					++i;
				}
				else if (args[i] == "--xml")
				{
					if (i + 1 < args.Length)
						xmlPath = GetPath(args[i + 1]) + xmlPath;
					++i;
				}
			}
		}
		
		WriteXML(xmlPath);
		WriteAS3(as3Path);
	}
	
	private static void WriteAS3(string outPath)
	{
		Dictionary<string, string> imageAssets = new Dictionary<string, string>();
		Dictionary<string, string> soundAssets = new Dictionary<string, string>();
		Dictionary<string, string> xmlAssets = new Dictionary<string, string>();
		
		using (System.IO.StreamWriter file = new System.IO.StreamWriter(outPath))
        {
			
			string[] header = 
			{
				"package",
				"{",
				"	import com.thaumaturgistgames.flakit.Library;",
				"	import flash.utils.ByteArray;",
				"	",
				"	/**",
				"	* Generated with LibraryBuilder for FLAKit",
 				"	* http://www.thaumaturgistgames.com/FLAKit",
 				"	*/",
 				"	public class EmbeddedAssets",
 				"	{"
			};
			
			string[] classOutlineBegin = 
			{
				"		",
				"		public function EmbeddedAssets()",
				"		{",
			};
			
			string[] classOutlineEnd = 
			{
				"		}",
 				"		private function getXML(c:Class):XML{var d:ByteArray = new c;var s:String = d.readUTFBytes(d.length);return new XML(s);}",
				"	}",
				"}"
			};
			
			foreach (string line in header)
			{
				file.WriteLine(line);
			}
			
			foreach (string i in images)
			{
				file.WriteLine(GenerateEmbedCode(i, imageAssets));
			}
			
			foreach (string s in sounds)
			{
				file.WriteLine(GenerateEmbedCode(s, soundAssets));
			}
			
			foreach (string x in xmls)
			{
				file.WriteLine(GenerateEmbedCode(x, xmlAssets, true));
			}
			
			foreach (string line in classOutlineBegin)
			{
				file.WriteLine(line);
			}
			
			foreach ( KeyValuePair<string, string> pair in imageAssets)
			{
				string format = "			";
				string addStatementBegin = "Library.addImage(\"";
				string addStatementMiddle = "\", new ";
				string addStatementEnd = ");";
				
				file.WriteLine(format + addStatementBegin + pair.Key + addStatementMiddle + pair.Value + addStatementEnd);
			}
			
			foreach ( KeyValuePair<string, string> pair in soundAssets)
			{
				string format = "			";
				string addStatementBegin = "Library.addSound(\"";
				string addStatementMiddle = "\", new ";
				string addStatementEnd = ");";
				
				file.WriteLine(format + addStatementBegin + pair.Key + addStatementMiddle + pair.Value + addStatementEnd);
			}
			
			foreach ( KeyValuePair<string, string> pair in xmlAssets)
			{
				string format = "			";
				string addStatementBegin = "Library.addXML(\"";
				string addStatementMiddle = "\", getXML(";
				string addStatementEnd = "));";
				
				file.WriteLine(format + addStatementBegin + pair.Key + addStatementMiddle + pair.Value + addStatementEnd);
			}
			
			foreach (string line in classOutlineEnd)
			{
				file.WriteLine(line);
			}
		}
	}
	
	private static void WriteXML(string outPath)
	{
		XmlWriterSettings settings = new XmlWriterSettings ();
		settings.Indent = true;
		settings.IndentChars = "    ";
		
		using (XmlWriter writer = XmlWriter.Create(outPath, settings))
		{
			writer.WriteComment("Created with LibraryBuilder for FLAkit ");
			writer.WriteComment("http://www.thaumaturgistgames.com/FLAkit");
			writer.WriteStartElement("library");
			
			writer.WriteStartElement("images");
			
			foreach (string i in images)
			{
				string rem = i.Replace ('\\', '/');
				rem = rem.Remove(0, 2);
				writer.WriteElementString ("image", rem);
			}
			
			writer.WriteEndElement();
			writer.WriteStartElement("sounds");
			
			foreach (string s in sounds)
			{
				string rem = s.Replace ('\\', '/');
				rem = rem.Remove(0, 2);
				writer.WriteElementString("sound", rem);
			}
			
			writer.WriteEndElement();
			
			writer.WriteStartElement ("xmls");
			
			foreach (string s in xmls)
			{
				string rem = s.Replace ('\\', '/');
				rem = rem.Remove(0, 2);
				writer.WriteElementString("xml", rem);
			}
			
			writer.WriteEndElement();
			writer.Flush();
		}
	}
	
	
	private static string GenerateEmbedCode(string name, Dictionary<string, string> assets, bool isXML = false)
	{
		string format = "		";
		string embedBegin = "[Embed(source = \"../lib/";
		string filename = name.Replace ('\\', '/');
		string embedEnd = isXML ? "\", mimeType = \"application/octet-stream\")] " : "\")] ";
		string declBegin = "private const ";		
		string declEnd = ":Class;";
		
		//	Strip the './' prefix from the files
		filename = filename.Remove(0, 2);
		
		string classname = "FLAKIT_ASSET$" + filename.GetHashCode().ToString();
		classname = classname.Replace('-', '_');
		
		assets.Add(filename, classname);
		
		return format + embedBegin + filename + embedEnd + declBegin + classname + declEnd;
	}
	
	
	/// <summary>
	/// Searches a directory recursively and adds files to a list if they match supplied patterns
	/// </summary>
	/// <param name="directory">The directory to start in</param>
	/// <param name="patterns">Filename masks to include in the result</param>
	/// <returns>A list of filenames</returns>
	private static List<string> GetMatchingFiles(string directory, string[] patterns)
	{
		List<string> result = new List<string> ();
		Stack<string> stack = new Stack<string> ();

		stack.Push (directory);
		
		while (stack.Count > 0)
		{
			string dir = stack.Pop ();

			try
			{
				foreach (string pattern in patterns)
				{
					result.AddRange(Directory.GetFiles(dir, pattern));
				}

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
	
	/// <summary>
	/// Searches a directory recursively and adds all found images to a list
	/// </summary>
	/// <param name="directory">The directory to start in</param>
	/// <returns>A list of filenames</returns>
	public static List<string> GetImages (string directory)
	{
		string[] patterns =
		{
			"*.png",
			"*.jpg",
			"*jpeg",
			"*.bmp",
			"*.gif"
		};
		
		return GetMatchingFiles(directory, patterns);
	}
	
	/// <summary>
	/// Searches a directory recursively and adds all found sound files to a list
	/// </summary>
	/// <param name="directory">The directory to start in</param>
	/// <returns>A list of sound files</returns>
	public static List<string> GetSounds (string directory)
	{
		
		string[] patterns =
		{
			"*.mp3",
			"*.wav",
			"*.aac",
			"*.m4a"
		};
		
		return GetMatchingFiles(directory, patterns);
	}
	
	/// <summary>
	/// Searches a directory recursively and adds all xml files to a list
	/// </summary>
	/// <param name="directory">The directory to start in</param>
	/// <returns>A list of xml files</returns>
	public static List<string> GetXMLFiles (string directory)
	{
		
		string[] patterns =
		{
			"*.xml",
			"*.oel"
		};
		
		return GetMatchingFiles(directory, patterns);
	}
};
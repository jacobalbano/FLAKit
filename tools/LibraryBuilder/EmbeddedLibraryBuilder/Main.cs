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
		List<string> images = GetImages (@".");
		List<string> sounds = GetSounds (@".");
		Dictionary<string, string> imageAssets = new Dictionary<string, string>();
		Dictionary<string, string> soundAssets = new Dictionary<string, string>();
		
		using (System.IO.StreamWriter file = new System.IO.StreamWriter(@"EmbeddedAssets.as"))
        {
			
			string[] header = 
			{
				"package",
				"{",
				"	import com.thaumaturgistgames.flakit.Library;",
				"	",
				"	/**",
				"	* Generated with LibraryBuilder for FLAKit",
 				"	* http://www.thaumaturgistgames.com/FLAKit",
 				"	*/",
 				"	public class EmbeddedAssets",
 				"	{",
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
			
			foreach (string line in classOutlineBegin)
			{
				file.WriteLine(line);
			}
			
			foreach ( KeyValuePair<string, string> pair in imageAssets)
			{
				string format = "			";
				string addStatementBegin = "Library.addImage(String(\"";
				string addStatementMiddle = "\").split(\"/\").join(\".\"), new ";
				string addStatementEnd = ");";
				
				file.WriteLine(format + addStatementBegin + pair.Key + addStatementMiddle + pair.Value + addStatementEnd);
			}
			
			foreach ( KeyValuePair<string, string> pair in soundAssets)
			{
				string format = "			";
				string addStatementBegin = "Library.addSound(String(\"";
				string addStatementMiddle = "\").split(\"/\").join(\".\"), new ";
				string addStatementEnd = ");";
				
				file.WriteLine(format + addStatementBegin + pair.Key + addStatementMiddle + pair.Value + addStatementEnd);
			}
			
			
			foreach (string line in classOutlineEnd)
			{
				file.WriteLine(line);
			}
			
		}
			
	}
	
	public static string GenerateEmbedCode(string name, Dictionary<string, string> assets)
	{
		string format = "		";
		string embedBegin = "[Embed(source = \"../lib/";
		string filename = name.Replace ('\\', '/');
		string embedEnd = "\")] ";
		string declBegin = "private const ";
		string classname = filename.Replace('/', '$');				
		string declEnd = ":Class;";
		
		
		filename = filename.Remove(0, 2);
		classname = classname.Remove(0, 2);
		
		//	Pretty sure this is every character not allowed in a variable name
		//	Basically just replace everything with underscores, and if it causes ambiguity, it's your own fault
		classname = classname.Replace('.', '_');
		classname = classname.Replace(' ', '_');
		classname = classname.Replace('+', '_');
		classname = classname.Replace('=', '_');
		classname = classname.Replace('\'', '_');
		classname = classname.Replace('-', '_');
		classname = classname.Replace('/', '_');
		classname = classname.Replace('?', '_');
		classname = classname.Replace('>', '_');
		classname = classname.Replace('<', '_');
		classname = classname.Replace(',', '_');
		classname = classname.Replace('!', '_');
		classname = classname.Replace('@', '_');
		classname = classname.Replace('#', '_');
		classname = classname.Replace('%', '_');
		classname = classname.Replace('^', '_');
		classname = classname.Replace('&', '_');
		classname = classname.Replace('*', '_');
		classname = classname.Replace('(', '_');
		classname = classname.Replace(')', '_');
		classname = classname.Replace('|', '_');
		classname = classname.Replace('~', '_');
		classname = classname.Replace('`', '_');
		
		
		assets.Add(filename, classname);

		return format + embedBegin + filename + embedEnd + declBegin + classname + declEnd;
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
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

/// <summary>
/// Recursively searches a directory and generates an Actionscript 3 source file to embed image and sound assets
/// </summary>
class Program
{
	
	public static void Main ()
	{
		List<string> images = RecursiveAssetIterator.GetImages (".");
		List<string> sounds = RecursiveAssetIterator.GetSounds (".");
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
		string declEnd = ":Class;";
		
		//	Strip the './' prefix from the files
		filename = filename.Remove(0, 2);
		
		string classname = "FLAKIT_ASSET$" + filename.GetHashCode().ToString();
		classname = classname.Replace('-', '_');
		
		assets.Add(filename, classname);
		
		return format + embedBegin + filename + embedEnd + declBegin + classname + declEnd;
	}
	
};
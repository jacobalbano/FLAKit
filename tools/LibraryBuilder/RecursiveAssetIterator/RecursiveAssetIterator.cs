using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

public class RecursiveAssetIterator
{
	
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
}
/*
 * Created by SharpDevelop.
 * User: Jake
 * Date: 5/4/2012
 * Time: 5:42 PM
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.Text;
using System.IO;

public class RecursiveAssetIterator
{
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
}
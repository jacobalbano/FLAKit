FLAKit is an asset management library for Actionscript 3 with live reloading and automatic asset class generation.

## Setup

Dynamic assets are loaded asynchronously, so a callback function is required.

```actionscript
public class Main extends Sprite
{
	public static var library:Library;
	
    public function Main()
    {
		super();
        addEventListener(Event.ADDED_TO_STAGE, initLibrary);
	}
	
	public function initLibrary(e:Event):void
	{
		library = new Library("../lib", Library.DynamicMode, init);
	}
	
	public function init():void 
	{
		//	Entry point
		trace("initialized");
		library.onLoadComplete = ...; // reset this if you want; it'll run every time assets are reloaded.
	}
}
```

Embedded assets are available instantly, but a callback can still be supplied to run after EmbeddedAssets are loaded.

```actionscript
library = new Library("../lib", Library.EmbedMode, init);
library.loadEmbedded(new EmbeddedAssets());
```

In the lib/ folder in the FLAKit repository, grab LibraryBuilder.exe and put it in your assets folder.
Make sure to pass the appropriate path to the Library constructor.
You'll need to run LibraryBuilder every time you add a new asset.
Library.xml should stay in your assets folder, while EmbeddedAssets.as should be moved alongside your document class.
LibraryBuilder.exe can be called with switches to customize the output folders for each file.

##Retrieving assets

```actionscript
var b:Bitmap = library.getImage("folder/image.png");
var x:XML = library.getXML("doc.xml");
var s:Sound = library.getSound("music.mp3");
```

##License
    Copyright (c) 2011, Jacob Albano (http://www.thaumaturgistgames.com/flakit)

    This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
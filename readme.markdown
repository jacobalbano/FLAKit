## Setup
Extend the FLAKit Engine class to form your document class.
```actionscript
public class Game extends Engine
{
    public function Game()
    {
        //  use XML (runtime) loading for debug mode
        super(Library.USE_XML);
        
        //  pass the generated assets class for release mode
        super(Library.USE_EMBEDDED, EmbeddedAssets);
    }
    
    override public function init():void
    {
        //  entry point
        //  at this point all assets have been loaded and the library can be used
        
        //  optionally, set a callback for when the library is reloaded
        //  a reload can be triggered by pressing F5
        this.onReload = reload;
    }
    
    private function reload():void
    {
        //  this runs after the library has finished loading
        //  you can set this up to update your sprites or rebuild your levels
        trace("loading finished");
    }
}
```

##Retrieving assets
Assets are loaded with the same interface regardless of backend.

```actionscript
var b:Bitmap = Library.getImage("folder/image.png");
var x:XML = Library.getXML("doc.xml");
var s:Sound = Library.getSound("music.mp3");
```

##License
    Copyright (c) 2011, Jacob Albano (http://www.thaumaturgistgames.com/flakit)

    This software is provided 'as-is', without any express or implied warranty. In no event will the authors be held liable for any damages arising from the use of this software.

    Permission is granted to anyone to use this software for any purpose, including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:

    1. The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation would be appreciated but is not required.

    2. Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.

    3. This notice may not be removed or altered from any source distribution.
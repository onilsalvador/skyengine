package;

import cpp.abi.Abi;
import openfl.display.BitmapData;
import openfl.media.Sound;
import lime.graphics.Image;

using StringTools;

class SkyPath 
{
    inline static public function getAppIcon(path:String)
        {
            var icon:Image;
            icon = Image.fromFile(path);
            icon.width = 150;
            return icon;
        }
}
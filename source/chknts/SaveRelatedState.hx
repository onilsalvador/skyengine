package chknts;

import flixel.util.FlxSave;

class SaveRelatedState
{
    public var skylarsave:FlxSave;

    static public var inTutorial:Bool = false;

    public function init()
        {
            skylarsave = new FlxSave();
            skylarsave.bind('skysave', 'onilsalvador');
            skylarsave.flush();
            
            if (skylarsave.data.inTutorial != null)
                inTutorial = skylarsave.data.inTutorial;
        }
    public function save()
        {
            skylarsave.data.inTutorial = inTutorial;
        }
}
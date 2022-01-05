package chknts;

import flixel.*;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import flixel.graphics.frames.FlxAtlasFrames;
import Controls;

class ModOrEdit extends MusicBeatState
{
    var bg:FlxSprite = new FlxSprite().makeGraphic(1280, 720, FlxColor.CYAN);
    var selectstate:Int = 1;
    var modbutton:FlxSprite;
    var editbutton:FlxSprite;
    override public function create() 
    {
        trace('test');
        add(bg);
        modbutton = new FlxSprite();
        modbutton.frames = FlxAtlasFrames.fromSparrow('assets/images/skyengine/menus1.png', 'assets/images/skyengine/menus1.xml');
        modbutton.animation.addByPrefix('button', 'menus1 modmenubutton', 0, false);
        modbutton.animation.play('button');
        editbutton = new FlxSprite();
        editbutton.frames = FlxAtlasFrames.fromSparrow('assets/images/skyengine/menus1.png', 'assets/images/skyengine/menus1.xml');
        editbutton.animation.addByPrefix('button', 'menus1 editmenubutton', 0, false);
        editbutton.animation.play('button');
        editbutton.animation.curAnim.curFrame = 1;
        modbutton.screenCenter();
        modbutton.x -= 300;
        editbutton.screenCenter();
        editbutton.x += 300;
        trace('test');
        add(modbutton);
        add(editbutton);
        trace('test');
        changeselect();

        super.create();

    }
    override public function update(elapsed:Float)
    {
        if(FlxG.keys.justPressed.LEFT)
            changeselect(-1);

        if(FlxG.keys.justPressed.RIGHT)
            changeselect(1);

        if(FlxG.keys.justPressed.ENTER)
        {    
            switch(selectstate)
            {
                case 1: MusicBeatState.switchState(new editors.MasterEditorMenu());
                
                case 0: MusicBeatState.switchState(new modloader.MasterModMenu());
            }
        }

        if (FlxG.keys.justPressed.ESCAPE)
            MusicBeatState.switchState(new MainMenuState());
        super.update(elapsed);
    }

    function changeselect(val:Int = 0)
        {
            selectstate += val;
            if (selectstate < 0)
                selectstate = 1;
            if (selectstate > 1)
                selectstate = 0;
            
            switch (selectstate)
            {
                case 1:
                    {
                        modbutton.animation.curAnim.curFrame = 1;
                        editbutton.animation.curAnim.curFrame = 1;
                    }
                case 0:
                    {
                        modbutton.animation.curAnim.curFrame = 0;
                        editbutton.animation.curAnim.curFrame = 0;
                    }
            }
        }
        
}
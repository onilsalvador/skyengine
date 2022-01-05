package chknts;

import MusicBeatState;
import flixel.*;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;
import flixel.util.FlxColor;
import flixel.input.keyboard.FlxKey;
import lime.app.Application;
import lime.system.System;
import flixel.addons.text.FlxTypeText;

class CheckState extends FlxState
{

    public var rng:FlxRandom = new FlxRandom();
    public static var yourname:String = '';
    var name:String;
    var display:String;
    var devicemodel:String;
    var devicevendor:String;
    var originaltitle:String;
    var titleval:Int;
    var os:String;
    var osver:String;
    var oslabel:String;
    var textcheck:FlxTypeText;
    var date:String;
    var textarray:Array<String>;
    override public function create()
        {
            originaltitle = Application.current.window.title;
            yourname = Sys.environment()["USERNAME"];
            name = yourname;
            name.toUpperCase();
            display = Application.current.window.display.name;
            display.toUpperCase();
            devicemodel = System.deviceModel;
            devicemodel.toUpperCase();
            devicevendor = System.deviceVendor;
            devicevendor.toUpperCase();
            os = System.platformName;
            os.toUpperCase();
            osver = System.platformVersion;
            osver.toUpperCase();
            oslabel = System.platformLabel;
            oslabel.toUpperCase();
            date = DateTools.format(Date.now(), "%F");
            textarray = [
            'mother 3?..', 
            'can you feel the sunshine?..', 
            'hey all, skylar here...', 
            "you're not the only god around here...", 
            'hello, $name...',
            'are you bbpanzu?..'
            ];
            titleval = rng.int(0, textarray.length - 1);

            textcheck = new FlxTypeText(20, 20, 0, 
            
            '
            SKYVM VERSION 0.1.0 | SKYLAR & CO. ALL RIGHTS RESERVED\n
            DATE: $date\n
            USERNAME: $yourname\n
            DEVICE MODEL: $devicemodel\n
            DISPLAY: $devicevendor\n
            OPERATIVE SYSTEM: $os\n
            OPERATIVE SYSTEM LABEL: $oslabel\n
            OPERATIVE SYSTEM VERSION: $osver\n

            CHECKING FILES AND BIOS...
            
            
            
            
            
            
            '
            , 10);
            
            add(textcheck);

            
            super.create();

            Application.current.window.title = 'INITIALIZATION...';
            textcheck.start(0.05, false, false, null, startall);
        }
    
    override public function update(elapsed:Float)
        {
            super.update(elapsed);
            if (FlxG.keys.justPressed.S)
                {
                    FlxG.switchState(new oldfunkin.TitleState());
                }
        }

    function startall()
        {
            new FlxTimer().start(2, function(timer:FlxTimer)
                {
                    Application.current.window.title = textarray[titleval];
                    
                    new FlxTimer().start(3, function(timer:FlxTimer)
                    {
                        FlxG.switchState(new TitleState());
                    });
                });
        }
}
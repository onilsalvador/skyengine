package modloader;

import flixel.text.FlxText;
import haxe.macro.Type.AbstractType;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import MusicBeatState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import sys.io.File;
import sys.FileSystem;
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.display.BitmapData;

using StringTools;

typedef ModJson = {
    var name:String; 
    var version:String;
    var icon:String;
    var author:String;
    var description:String;
    var fullmod:Bool;
}

class ModMenu extends MusicBeatState
{
    var bg:FlxSprite;
    var modIcon:FlxSprite;
    var modName:FlxText;
    var modVersion:FlxText;
    var modAuthor:FlxText;
    var modDescrip:FlxText;
    public var selectedMod:Int = 0;
    public var modList:Array<String> = ["TESTMOD"];
    public var name:String = "test"; 
    public var version:String = "3.3.3";
    public var icon:String = 'icon.png';
    public var author:String = "onilwifeforever";
    public var description:String = "haha hey all skylar here";
    public var fullmod:Bool = true;
    static public var curmodfolder:String = "mods/TESTMOD/";

    override public function create()
    {
        bg = new FlxSprite(0, 0);
        bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.YELLOW);
        add(bg);

        super.create();

        for (file in FileSystem.readDirectory("mods/"))
            {
                if (file == 'readme.txt') continue;
                modList.push(file);
            }


        modName = new FlxText();
        modName.screenCenter();

        modVersion = new FlxText(modName.x, modName.y - 40);
        modIcon = new FlxSprite(0, 0);

        modIcon.screenCenter();
        modIcon.x -= 500;

        loadmodjson();

        add(modIcon);
        add(modName);
        add(modVersion);
    }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (FlxG.keys.justPressed.ESCAPE) MusicBeatState.switchState(new MainMenuState());
        if (controls.UI_UP_P) {
            changecurmod(-1);
            loadmodjson();
            trace(modList[selectedMod] + name);
        }
        if (controls.UI_DOWN_P) {
            changecurmod(1);
            loadmodjson();
            trace(modList[selectedMod] + name);
        }
        if (controls.ACCEPT) {
            loadmod();
            MusicBeatState.switchState(new MainMenuState());
        }
    }

    function loadmodjson()
    {
        var modPath:String = modList[selectedMod] + "/" + 'mod.json';
            var path:String = "mods/" + modPath;
            if (!FileSystem.exists(path)) {
                path = "mods/" + "TESTMOD/" + 'mod.json';
            }
 
            var rawJson = File.getContent(path);

            var json:ModJson = cast Json.parse(rawJson);

            name = json.name;
            version = json.version;
            icon = json.icon;
            author = json.author;
            description = json.description;
            fullmod = json.fullmod;

            modVersion.text = version;

            modName.text = name;

            var iconPath = "mods/" + modList[selectedMod] + "/" + icon;

            trace (iconPath + " omg sky icon path");

            var iconmodthing:BitmapData = BitmapData.fromFile(iconPath);
            modIcon.loadGraphic(iconmodthing);

        
    }

    function changecurmod(number:Int = 0)
        {
            selectedMod += number;
            if (selectedMod > modList.length - 1)
                selectedMod = modList.length - 1;
            if (selectedMod < 0)
                selectedMod = 0;
            trace("curmodnumber " + selectedMod);
        }

    function loadmod()
        {
            curmodfolder = "mods/" + modList[selectedMod] + "/";
        }
}
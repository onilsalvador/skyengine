package modloader;

import Alphabet;
import openfl.display.Bitmap;
import flixel.FlxState;
import flixel.FlxG;
import haxe.macro.Type.AbstractType;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import MusicBeatState;
import flixel.system.FlxSound;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import sys.io.File;
import Conductor;
import sys.FileSystem;
import openfl.utils.Assets;
import haxe.Json;
import haxe.format.JsonParser;
import openfl.display.BitmapData;
import flash.media.Sound;

using StringTools;

typedef SongJSON = {
    var name:String;
    var composer:String;
    var coverimg:String;
    var discimg:String;
    var bpm:Float;
    var twovocals:Bool;
}

class SoundPlayer extends MusicBeatState
{
    var songname:String = 'a';
    var songcomposer:String = 'a';
    var songcoverimg:String = 'a';
    var discimg:String = 'a';
    var songbpm:Float = 120;
    var songtwovocals:Bool = true;

    var numb:Int = 0;
    var selectedSong:Int = 0;
    public var modList:Array<String> = [];
    public var songList:Array<String> = [];
    public var bg:FlxSprite;
    public var disc:FlxSprite;
    public var musplayer:FlxSprite;
    public var playerneedle:FlxSprite;
    public var inst:FlxSound;
    public var voice:FlxSound;
    public var voice2:FlxSound;

    public var songnametxt:Alphabet;
    public var songcomposertxt:Alphabet;

    override public function create()
    {
        super.create();
        bg = new FlxSprite();
        inst = new FlxSound();
        voice = new FlxSound();
        voice2 = new FlxSound();
        disc = new FlxSprite(0, 0);
        musplayer = new FlxSprite(0, 0);
        playerneedle = new FlxSprite(0, 0);

        bg.makeGraphic(FlxG.width, FlxG.height);
        for (file in FileSystem.readDirectory("mods/"))
            {
                if (file == "readme.txt" || file == "tempdisc.png") continue;
                numb += 1;
                modList.push("mods/" + file + "/");  
                loadsongs(numb);
                trace(modList.toString());    
            }
        
        musplayer.loadGraphic(bitmapthing('assets/images/skyengine/soundplayer/musplayer.png'));
        musplayer.screenCenter();
        playerneedle.loadGraphic(bitmapthing('assets/images/skyengine/soundplayer/playerneedle.png'));
        playerneedle.screenCenter();
        disc.loadGraphic(bitmapthing('assets/images/skyengine/soundplayer/defdisk.png'));
        disc.setPosition(musplayer.x + 268, musplayer.y + 13);

        songnametxt = new Alphabet(musplayer.x + 90, musplayer.y - 120);
        songcomposertxt = new Alphabet(songnametxt.x, musplayer.height + 140);

        loadall();

        add(bg);
        add(musplayer);
        add(disc);
        add(playerneedle);
        add(songnametxt);
        add(songcomposertxt);

        }
    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if (inst.volume < 1)
            inst.volume = 1;
        if (voice.volume < 1)
            voice.volume = 1;

        Conductor.songPosition = inst.time;
        if (inst.playing)
        disc.angle += songbpm * 0.01;

        if(disc.angle >= 360)
            disc.angle = 0;

        if (controls.BACK)
        {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
        }

        if (controls.ACCEPT)
        {
            if (!inst.playing)
            {
            inst.play();
            voice.play();
            }
            else 
            {
                inst.pause();
                voice.pause();
            }

        }
        if (controls.UI_UP_P)
        {            
            changesong(1);
            loadall();
        }
        if (controls.UI_DOWN_P)
        {
            changesong(-1);
            loadall();
        }
    }

    override function beatHit()
    {
        super.beatHit();            
    }

    function loadsongs(number:Int)
    {        
    for (file in FileSystem.readDirectory(modList[number - 1] + "songs/"))
            {
                if (file == "readme.txt") continue;
                songList.push(modList[number - 1] + "songs/" + file + "/");
                trace(songList.toString() + "songlist");
            }
    }

    function loadsoundjson() 
    {
        var path:String = songList[selectedSong] + 'song.json';
        trace(path);
        if (FileSystem.exists(path))
            {
                var rawJson = File.getContent(path);

                var json:SongJSON = cast Json.parse(rawJson);

                songname = json.name;
                songcomposer = json.composer;
                songcoverimg = json.coverimg;
                discimg = json.discimg;
                songbpm = json.bpm;
                songtwovocals = json.twovocals;
            }
        else 
            {
                songname = 'null';
                songcomposer = 'null';
                songcoverimg = 'null';
                discimg = 'null';
                songbpm = 120;
                songtwovocals = false;

            }

    }

    function loaddisc()
        {
            var discimage:BitmapData;
            if (FileSystem.exists(songList[selectedSong] + discimg))
                discimage = BitmapData.fromFile(songList[selectedSong] + discimg);
            else discimage = null;

            if (discimage != null)
                disc.loadGraphic(discimage);
            else 
                disc.loadGraphic(bitmapthing('assets/images/skyengine/soundplayer/defdisk.png'));
            disc.angle = 0;
        }

    function loadsound() 
    {
        var file:Sound = Sound.fromFile(songList[selectedSong] + 'Inst.ogg');
        var file2:Sound = Sound.fromFile(songList[selectedSong] + 'Voices.ogg');
        trace (file + "   " + file2);
        inst.loadEmbedded(file);
        voice.loadEmbedded(file2);
    }

    function loadtext()
    {
        songcomposertxt.changeText(songcomposer);
        songnametxt.changeText(songname);
    }

    inline function bitmapthing(path:String)
        {
        var bit:BitmapData;
        bit = BitmapData.fromFile(path);
        trace(bit);
        return bit;
        }

    function loadall()
        {
            loadsound();
            loadsoundjson();
            loaddisc();
            loadtext();
            Conductor.changeBPM(songbpm);
            
        }

    function changesong(number:Int)
    {
        selectedSong += number;
        if (selectedSong > songList.length - 1)
            selectedSong = songList.length - 1;
        if (selectedSong < 0)
            selectedSong = 0;
    }
}
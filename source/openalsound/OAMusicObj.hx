package openalsound;

import flixel.FlxBasic;
import lime.media.openal.*;
import lime.media.vorbis.*;
import haxe.io.Bytes;
import lime.utils.UInt8Array;

class OAMusicObj extends FlxBasic
{
    
    var audioSource:ALSource;
	var audioBuffer:ALBuffer;
	var audioAux:ALAuxiliaryEffectSlot;
	var audioEffect:ALEffect;
	var audioFilter:ALFilter;

    var oggfile:VorbisFile;

    public var onComplete:Void->Void;
    public var autoDestroy:Bool;

    public override function new(filepath:String)
        {

            super();
            reset();

            if (sys.FileSystem.exists(filepath))
                {
                    oggfile = VorbisFile.fromFile(filepath);
                }
            else
                return;

        }

    function reset()
        {
            audioSource = AL.createSource();
            audioBuffer = AL.createBuffer();
            audioAux = AL.createAux();
            audioEffect = AL.createEffect();
            audioFilter = AL.createFilter();
        }
    
    function readOggFile(oggFile:VorbisFile):UInt8Array
        {

        
        }
    
}
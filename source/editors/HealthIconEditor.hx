package editors;

#if desktop
import Discord.DiscordClient;
#end
import modloader.ModMenu;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxCamera;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.graphics.FlxGraphic;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import openfl.net.FileReference;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import haxe.Json;
import Character;
import flixel.system.debug.interaction.tools.Pointer.GraphicCursorCross;
import lime.system.Clipboard;
import flixel.animation.FlxAnimation;

#if MODS_ALLOWED
import sys.FileSystem;
#end

using StringTools;

class HealthIconEditor extends MusicBeatState
{
    var hpIcon:HealthIcon;
    
    override public function create()
    {

    }
}
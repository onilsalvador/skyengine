package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

import sys.io.File;
import sys.FileSystem;
import haxe.Json;
using StringTools;

typedef IcoJson = 
{
	var animations:Array<IcoAnim>;
	var scale:Float;
	var flip_x:Bool;
	var no_antialiasing:Bool;
	var position:Array<Float>;
	var icontype:Int;
	var isplayer:Bool;
	var classic:Bool;
	var imgwidth:Int;
	var imgheight:Int;
}
typedef IcoAnim =
{
	var anim:String;
	var name:String;
	var fps:Int;
	var loop:Bool;
	var indices:Array<Int>;
	var offsets:Array<Int>;
}
class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	private var isOldIcon:Bool = false;
	public var animOffsets:Map<String, Array<Dynamic>>;
	var iconType:Int = 0;
	var isPlayer:Bool = false;
	public var name:String = '';
	public var json:IcoJson;

	public function new(name:String = 'bf', isplayer:Bool = false)
	{
		super();

		#if (haxe >= "4.0.0")
		animOffsets = new Map();
		#else
		animOffsets = new Map<String, Array<Dynamic>>();
		#end
		this.isPlayer = isplayer;
		changeIcon(name);
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon(name + '-old');
		else changeIcon(name);
	}

	public function changeIcon(char:String) {


		var path:String = Paths.modFolders('characters/icons/$char.json');
		if (!FileSystem.exists(path)) 
		{
			path = Paths.getPreloadPath('characters/icons/$char.json');
		}

		var rawJson = File.getContent(path);
		json = cast Json.parse(rawJson);

		if(this.name != char) {
			var name:String = 'icons/' + char ;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			if (json.classic == true) {
				loadGraphic(file, true, json.imgwidth, json.imgheight);
				switch (json.icontype)
				{
					case 0:
						animation.add(char, [0, 1], 0, false, isPlayer);
					case 1:
						animation.add(char, [0, 1, 2], 0, false, isPlayer);
					case 2:
						animation.add(char, [0], 0, false, isPlayer);
						animation.add(char + 'singUP', [1], 0, false, isPlayer);
						animation.add(char + 'singDOWN', [2], 0, false, isPlayer);
						animation.add(char + 'singLEFT', [3], 0, false, isPlayer);
						animation.add(char + 'singRIGHT', [4], 0, false, isPlayer);
						animation.add(char + 'lose', [5], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singUP', [6], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singDOWN', [7], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singLEFT', [8], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singRIGHT', [9], 0, false, isPlayer);
						animation.add(char + 'win', [10], 0, false, isPlayer);
						animation.add(char + 'win' + 'singUP', [11], 0, false, isPlayer);
						animation.add(char + 'win' + 'singDOWN', [12], 0, false, isPlayer);
						animation.add(char + 'win' + 'singLEFT', [13], 0, false, isPlayer);
						animation.add(char + 'win' + 'singRIGHT', [14], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singUPmiss', [6], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singDOWNmiss', [7], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singLEFTmiss', [8], 0, false, isPlayer);
						animation.add(char + 'lose' + 'singRIGHTmiss', [9], 0, false, isPlayer);
						animation.add(char + 'win' + 'singUPmiss', [6], 0, false, isPlayer);
						animation.add(char + 'win' + 'singDOWNmiss', [7], 0, false, isPlayer);
						animation.add(char + 'win' + 'singLEFTmiss', [8], 0, false, isPlayer);
						animation.add(char + 'win' + 'singRIGHTmiss', [9], 0, false, isPlayer);
						animation.add(char + 'singUPmiss', [6], 0, false, isPlayer);
						animation.add(char + 'singDOWNmiss', [7], 0, false, isPlayer);
						animation.add(char + 'singLEFTmiss', [8], 0, false, isPlayer);
						animation.add(char + 'singRIGHTmiss', [9], 0, false, isPlayer);
				}	
				playAnim(char);
			}
			
			else
				{
				frames = Paths.getSparrowAtlas(file);

				for (anim in json.animations) {
					var animAnim:String = '' + anim.anim;
					var animName:String = '' + anim.name;
					var animFps:Int = anim.fps;
					var animLoop:Bool = !!anim.loop; //Bruh
					var animIndices:Array<Int> = anim.indices;
					if(animIndices != null && animIndices.length > 0) {
						animation.addByIndices(animAnim, animName, animIndices, "", animFps, animLoop);
					} else {
						animation.addByPrefix(animAnim, animName, animFps, animLoop);
					}

					if(anim.offsets != null && anim.offsets.length > 1) {
						addOffset(anim.anim, anim.offsets[0], anim.offsets[1]);
					}
				}

				playAnim('idle');
				
				}
			if (json.no_antialiasing)
				antialiasing = false;
			else
				antialiasing = ClientPrefs.globalAntialiasing;

			if (isPlayer)
				{
					flipX = !json.flip_x;
				}
			this.name = char;
		}
	}

	public function getCharacter():String {
		return name;
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0)
		{
			animOffsets[name] = [x, y];
		}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void
		{
			animation.play(AnimName, Force, Reversed, Frame);
	
			var daOffset = animOffsets.get(animation.curAnim.name);
			if (animOffsets.exists(animation.curAnim.name))
			{
				offset.set(daOffset[0], daOffset[1]);
			}
		}
}

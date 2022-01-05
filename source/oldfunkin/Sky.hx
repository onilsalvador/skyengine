package oldfunkin;

import flixel.graphics.frames.FlxAtlasFrames;

class Sky extends Character
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		var tex = FlxAtlasFrames.fromSparrow('oldfunkin/images/SKY_assets.png', 'oldfunkin/images/SKY_assets.xml');
		frames = tex;
		animation.addByIndices('danceLeft', 'sky idle', [0, 1, 2, 3, 4, 5, 6, 7], "", 24, false);
		animation.addByIndices('danceRight', 'sky idle', [8, 9, 10, 11, 12, 13, 14, 15], "", 24, false);
        animation.addByPrefix('singUP', 'sky up', 24);
		animation.addByPrefix('singRIGHT', 'sky right', 24);
		animation.addByPrefix('singDOWN', 'sky down', 24);
		animation.addByPrefix('singLEFT', 'sky left', 24);


		addOffset('danceLeft');
        addOffset('singUP');
        addOffset('singRIGHT');
        addOffset('singLEFT');
        addOffset('singDOWN');
		addOffset('danceRight');

		playAnim('danceRight');
	}

	private var danced:Bool = false;

	public function dance()
	{
		danced = !danced;

		if (danced)
			playAnim('danceRight');
		else
			playAnim('danceLeft');
	}
}

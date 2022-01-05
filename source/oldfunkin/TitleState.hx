package oldfunkin;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.system.FlxSound;
import flixel.util.FlxTimer;

class TitleState extends FlxTransitionableState
{
	static var initialized:Bool = false;

	override public function create()
	{
		super.create();

		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 2, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(0, 0, FlxG.width, FlxG.height));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 1.3, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(0, 0, FlxG.width, FlxG.height));

			initialized = true;

			FlxTransitionableState.defaultTransIn.tileData = {asset: diamond, width: 32, height: 32};
			FlxTransitionableState.defaultTransOut.tileData = {asset: diamond, width: 32, height: 32};

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
		}

		persistentUpdate = true;

		var bg:FlxSprite = new FlxSprite().loadGraphic('oldfunkin/images/stageback.png');
		bg.antialiasing = true;
		bg.setGraphicSize(Std.int(bg.width * 0.6));
		bg.updateHitbox();
		add(bg);

		var logoBl:FlxSprite = new FlxSprite().loadGraphic('oldfunkin/images/logo.png');
		logoBl.screenCenter();
		logoBl.color = FlxColor.BLACK;
		add(logoBl);

		var logo:FlxSprite = new FlxSprite().loadGraphic('oldfunkin/images/logo.png');
		logo.screenCenter();
		logo.antialiasing = true;
		add(logo);

		FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		FlxG.sound.playMusic('oldfunkin/music/title.ogg', 0, false);

		FlxG.sound.music.fadeIn(4, 0, 0.7);

		trace(FlxG.sound.music.playing);
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.ENTER && !transitioning)
		{
			FlxG.camera.flash(FlxColor.WHITE, 1);

			transitioning = true;
			FlxG.sound.music.stop();

			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				FlxG.switchState(new PlayState());
			});
			FlxG.sound.play('oldfunkin/music/titleShoot.ogg', 0.7);
		}

		super.update(elapsed);
	}
}

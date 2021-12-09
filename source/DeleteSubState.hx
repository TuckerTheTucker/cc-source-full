package;

/// Code created by Rozebud for FPS Plus (thanks rozebud)
// modified by KadeDev for use in Kade Engine/Tricky

import flixel.util.FlxAxes;
import flixel.FlxSubState;
import Options.Option;
import flixel.input.FlxInput;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import lime.utils.Assets;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.input.FlxKeyManager;
import flixel.util.FlxTimer;

using StringTools;

class DeleteSubState extends FlxSubState
{

    var deleteTextHeader:FlxText;
	var deleteTextHeader2:FlxText;
	var deleteInfo:FlxText;
	
    var curSelected:Int = 0;
	
	var yes:FlxText;
	var no:FlxText;
	
	private var isExiting:Bool = false;

    var blackBox:FlxSprite;

	override function create()
	{	
		//FlxG.sound.playMusic('assets/music/configurator' + TitleState.soundExt);
		
		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.playing)
				FlxG.sound.music.pause();
		}

		persistentUpdate = persistentDraw = true;

        blackBox = new FlxSprite(0,0).makeGraphic(FlxG.width,FlxG.height,FlxColor.BLACK);
        add(blackBox);
		
        deleteTextHeader = new FlxText(0, 250, 0, "Are you Sure you want to delete your progress?", 72);
		deleteTextHeader.alignment = CENTER;
		deleteTextHeader.scrollFactor.set(0, 0);
		deleteTextHeader.setFormat("VCR OSD Mono", 42, FlxColor.RED, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		deleteTextHeader.alpha = 0;
		deleteTextHeader.screenCenter(X);
		add(deleteTextHeader);
		
		deleteTextHeader2 = new FlxText(0, deleteTextHeader.y + 50, 0, "All of it will be lost.", 48);
		deleteTextHeader2.alignment = CENTER;
		deleteTextHeader2.scrollFactor.set(0, 0);
		deleteTextHeader2.setFormat("VCR OSD Mono", 36, FlxColor.RED, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		deleteTextHeader2.alpha = 0;
		deleteTextHeader2.screenCenter(X);
		add(deleteTextHeader2);

        deleteInfo = new FlxText(10, FlxG.height - 25, 0, "Press ESCAPE to Go back, Press ENTER to Confirm Deletion.", 36);
		deleteInfo.alignment = CENTER;
		deleteInfo.scrollFactor.set(0, 0);
		deleteInfo.setFormat("VCR OSD Mono", 18, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		deleteInfo.alpha = 0;
		deleteInfo.screenCenter(X);
		add(deleteInfo);
		
		blackBox.alpha = 0;
		
		FlxTween.tween(deleteTextHeader, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
		FlxTween.tween(deleteTextHeader2, {alpha: 1}, 1, {ease: FlxEase.expoInOut});
        FlxTween.tween(deleteInfo, {alpha: 1}, 1.4, {ease: FlxEase.expoInOut});
        FlxTween.tween(blackBox, {alpha: 0.7}, 1, {ease: FlxEase.expoInOut});
	}

	override function update(elapsed:Float)
	{	
		if (FlxG.keys.justPressed.ESCAPE)
		{
			isExiting = true;

			FlxTween.tween(deleteTextHeader, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			FlxTween.tween(deleteTextHeader2, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			FlxTween.tween(blackBox, {alpha: 0}, 1.1, {ease: FlxEase.expoInOut, onComplete: function(flx:FlxTween){close();}});
			FlxTween.tween(deleteInfo, {alpha: 0}, 1, {ease: FlxEase.expoInOut});
			FlxG.sound.play(Paths.sound('cancelMenu'));
			FlxG.sound.music.resume();
		}
		
		if (FlxG.keys.justPressed.ENTER && !isExiting)
		{
			FlxG.save.data.weekCompleted = false;
			FlxG.save.data.weekiUnlock = false;
			FlxG.save.data.weeki90Acc = false;
			FlxG.save.data.fall = false;
			FlxG.save.data.stressClear = false;
			PlayState.campaignScore = 0;
			FlxG.camera.fade(FlxColor.BLACK, 1.5, false);
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				FlxG.switchState(new TitleState());
				if (FlxG.random.bool(0.1) || TitleState.debugMusic) //1/1000 chance to play the bad piggies theme lmao
				{
					trace("super cool bad piggies reference B)");
					FlxG.sound.playMusic(Paths.music('freakyMenuAlt'), 0.7);
				}
				else
				{
					FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.7);
				}
			});
			
		}
    }
}

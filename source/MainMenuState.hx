package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import io.newgrounds.NG;
import lime.app.Application;
import flixel.util.FlxTimer;
#if windows
import flash.system.System;
#end

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate', 'options'];
	#else
	var optionShit:Array<String> = ['story mode', 'freeplay', 'donate'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	
	var backspace:FlxSprite;
	var lock:FlxSprite;
	var star:FlxSprite;
	 
	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Cavity Crush Menu" + (FlxG.save.data.weekCompleted ? ", Week Completed!" : "."), null);
		#end
		
		if (StoryMenuState.goBackS)
			curSelected = 0;
		else if (FreeplayState.goBackF)
			curSelected = 1;
		else if (AchievementState.goBackA)
			curSelected = 2;
		else if (OptionsMenu.goBackO)
			curSelected = 3;

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.15));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Paths.image('menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.15));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFF4F2400;
		add(magenta);
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = Paths.getSparrowAtlas('FNF_main_menu_assets');
		
		var backtex = Paths.getSparrowAtlas('backspace', 'shared');

		for (i in 0...optionShit.length)
		{
			var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
		}
		
		lock = new FlxSprite(900, 240).loadGraphic(Paths.image('onlylock'));
		lock.antialiasing = true;
		lock.scrollFactor.x = 0;
		lock.scrollFactor.y = 0;
		lock.scrollFactor.set();
		if (!FlxG.save.data.weekCompleted)
			add(lock);

		FlxG.camera.follow(camFollow, null, 0.08);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 18, 0, "CC v1.0.0 - Made By TuckerTheTucker", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		
		backspace = new FlxSprite(FlxG.width * 0.75, FlxG.height * 0.85);
		backspace.frames = backtex;
		backspace.scrollFactor.x = 0;
		backspace.scrollFactor.y = 0;
		backspace.antialiasing = true;
		backspace.animation.addByIndices('idle', 'backspace to exit', [0], '', 24);
		backspace.animation.addByPrefix('pressed', 'backspace PRESSED', 24, false);
		backspace.scrollFactor.set();
		backspace.animation.play('idle');
		add(backspace);
		
		var star:FlxSprite = new FlxSprite(10, versionShit.y - 35).loadGraphic(Paths.image('star'));
		star.setGraphicSize(Std.int(star.width * 1.2));
		star.scrollFactor.x = 0;
		star.scrollFactor.y = 0;
		star.antialiasing = true;
		star.scrollFactor.set();
		if (FlxG.save.data.weekCompleted)
			add(star);
		
		//copy paste moment
		var star2:FlxSprite = new FlxSprite(50, versionShit.y - 35).loadGraphic(Paths.image('star'));
		star2.setGraphicSize(Std.int(star.width * 1.2));
		star2.scrollFactor.x = 0;
		star2.scrollFactor.y = 0;
		star2.antialiasing = true;
		star2.scrollFactor.set();
		if (FlxG.save.data.weekiUnlock && FlxG.save.data.weeki90Acc && FlxG.save.data.fall && FlxG.save.data.stressClear)
			add(star2);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;
	var isExiting:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		if (!FlxG.save.data.weekCompleted)
		{
			menuItems.forEach(function(spr:FlxSprite)
			{
				if (spr.ID == 1)
				{
					spr.alpha = 0.2;
				}
			});
		}

		if (!selectedSomethin)
		{
			if (controls.UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				if (!FlxG.save.data.weekCompleted && curSelected == 2)
					changeItem(-2);
				else
					changeItem(-1);
				
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				if (!FlxG.save.data.weekCompleted && curSelected == 0)
					changeItem(2);
				else
					changeItem(1);
			}

			if (FlxG.keys.justPressed.ESCAPE)
			{
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.camera.shake(0.001, 0.5);
				
				if (optionShit[curSelected] == 'brehwhetdehellboi')
				{
					FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					FlxFlicker.flicker(magenta, 0.6, 0.15, false);
					
					FlxTween.tween(lock, {alpha: 0}, 0.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									lock.kill();
								}
							});

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.3, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxFlicker.flicker(spr, 0.6, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Menu Selected");
									case 'donate':
										FlxG.switchState(new AchievementState());
									case 'options':
										FlxG.switchState(new OptionsMenu());
								}
							});
						}
					});
				}
			}
		}
		
		if (FlxG.keys.justPressed.BACKSPACE && !isExiting && !selectedSomethin)
		{
			isExiting = true;
			backspace.animation.play('pressed');
			backspace.y -= 50;
			backspace.x -= 25;
			FlxG.sound.play(Paths.sound('cancelMenu'));
			trace('leaving the game...');
			new FlxTimer().start(0.4, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 0.4);
			});
			
			new FlxTimer().start(1.2, function(tmr:FlxTimer)
			{
				System.exit(0);
			});
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.input.keyboard.FlxKey;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import lime.app.Application;
import openfl.Assets;
import openfl.filters.ColorMatrixFilter;
import openfl.geom.Point;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;
	
	var hue:Float = 0;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;
	
	var shakeshit:Float = 0;
	
	var codePress:Int = 0;
	var codeCompleted:Bool = false;
	public static var cheatActive:Bool = false;
	
	public static var debugMusic:Bool = false; //so i can test it without having to rely on rng

	override public function create():Void
	{	
		//fuck watermarks. all my homies hate watermarks.
		Main.watermarks = false;
		FlxG.save.data.watermark = false;
		
		#if polymod
		polymod.Polymod.init({modRoot: "mods", dirs: ['introMod']});
		#end
		
		#if sys
		if (!sys.FileSystem.exists(Sys.getCwd() + "/assets/replays"))
			sys.FileSystem.createDirectory(Sys.getCwd() + "/assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		 });
		 
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());
		trace(curWacky[0] + '--' + curWacky[1]); 

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end
		
		#if debug
		debugMusic = true;
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		Highscore.load();

		if (FlxG.save.data.weekUnlocked != null)
		{
			// FIX LATER!!!
			// WEEK UNLOCK PROGRESSION!!
			// StoryMenuState.weekUnlocked = FlxG.save.data.weekUnlocked;

			if (StoryMenuState.weekUnlocked.length < 4)
				StoryMenuState.weekUnlocked.insert(0, true);

			// QUICK PATCH OOPS!
			if (!StoryMenuState.weekUnlocked[0])
				StoryMenuState.weekUnlocked[0] = true;
		}

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		startIntro();
		#end
	}

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var bumpLeft:Bool = false;
	var titleText:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();
			if (FlxG.random.bool(0.1) || debugMusic) //1/1000 chance to play the bad piggies theme lmao
			{
				trace("super cool bad piggies reference B)");
				FlxG.sound.playMusic(Paths.music('freakyMenuAlt'), 0);
			}
			else
			{
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
			}

			FlxG.sound.music.fadeIn(4, 0, 0.7);
			FlxG.camera.fade(FlxColor.BLACK, 0.8, true); //so the background doesnt look like it immediately pops up
		}

		Conductor.changeBPM(125);
		persistentUpdate = true;
		
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('bggrad'));
		bg.antialiasing = true;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		add(bg);

		if(Main.watermarks) {
			logoBl = new FlxSprite(-150, -100);
			logoBl.frames = Paths.getSparrowAtlas('KadeEngineLogoBumpin');
			logoBl.antialiasing = true;
			logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
			logoBl.animation.play('bump');
			logoBl.updateHitbox();
			// logoBl.screenCenter();
			// logoBl.color = FlxColor.BLACK;
		} else {
			logoBl = new FlxSprite(-150, -100);
			logoBl.frames = Paths.getSparrowAtlas('logoBumpin');
			logoBl.antialiasing = true;
			logoBl.animation.addByIndices('bumpLeft', 'logo bumpin', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
			logoBl.animation.addByIndices('bumpRight', 'logo bumpin', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30], "", 24, false);
			logoBl.updateHitbox();
			// logoBl.screenCenter();
			// logoBl.color = FlxColor.BLACK;
		}

		gfDance = new FlxSprite(FlxG.width * 0.45, FlxG.height * 0.08);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByPrefix('dance', 'pepper left instance 1', 24, false);
		gfDance.antialiasing = true;
		gfDance.screenCenter(Y);
		add(gfDance);
		add(logoBl);

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Paths.getSparrowAtlas('titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		// titleText.screenCenter(X);
		add(titleText);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		//add(logo);

		FlxTween.tween(logoBl, {y: logoBl.y + 5}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(gfDance, {y: gfDance.y + 2}, 0.8, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});
		FlxTween.tween(titleText, {angle: titleText.angle + 1}, 1.5, {ease: FlxEase.quadInOut, type: PINGPONG});
		//FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().loadGraphic(Paths.image('bggrad'));
		blackScreen.setGraphicSize(Std.int(blackScreen.width * 1.1));
		blackScreen.updateHitbox();
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		if (initialized)
			skipIntro();
		else
			initialized = true;

		// credGroup.add(credTextShit);
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{	
		//konami code shit. theres probably a better way but this works.
		//i wanted to make it so the code is randomized when you first boot up the game but im too much of a dum dum to know how
		if (skippedIntro)
		{
			if (FlxG.keys.justPressed.EIGHT && !codeCompleted)
			{
				if (codePress == 0)
				{
					codePress++;
					trace("8");
				}
				else
				{
					codePress = 0;
					trace("failed, try again from 0");
				}
			}

			if (FlxG.keys.justPressed.TWO && !codeCompleted)
			{
				if (codePress == 1 || codePress == 4)
				{
					codePress++;
					trace("2");
				}
				else
				{
					codePress = 0;
					trace("failed, try again from 0");
				}
			}
			
			if (FlxG.keys.justPressed.SIX && !codeCompleted)
			{
				if (codePress == 2)
				{
					codePress++;
					trace("6");
				}
				else
				{
					codePress = 0;
					trace("failed, try again from 0");
				}
			}

			if (FlxG.keys.justPressed.Y && !codeCompleted)
			{
				if (codePress == 3)
				{
					codePress++;
					trace("Y");
				}
				else
				{
					codePress = 0;
					trace("failed, try again from 0");
				}
			}
			
			if (FlxG.keys.justPressed.THREE && !codeCompleted)
			{
				if (codePress == 5)
				{
					codePress++;
					trace("3");
				}
				else
				{
					codePress = 0;
					trace("failed, try again from 0");
				}
			}

			if (FlxG.keys.justPressed.B && !codeCompleted)
			{
				if (codePress == 6)
				{
					codePress++;
					codeCompleted = true;
					FlxG.sound.play(Paths.sound('cheatunlock'));
					cheatActive = true;
					trace("B. The Code is Completed!");
				}
				else
				{
					codePress = 0;
					trace("failed, try again from 0");
				}
			}
		}
		
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}
		
		#if debug
		if (FlxG.keys.justPressed.NINE)
		{
			FlxG.save.data.weekCompleted = false;
			FlxG.save.data.weekiUnlock = false;
			FlxG.save.data.weeki90Acc = false;
			FlxG.save.data.fall = false;
			FlxG.save.data.stressClear = false;
			trace("mod progress deleted lmao");
		}
		
		if (FlxG.keys.justPressed.EIGHT)
		{
			FlxG.save.data.weekCompleted = true;
			FlxG.save.data.weekiUnlock = true;
			FlxG.save.data.weeki90Acc = true;
			FlxG.save.data.fall = true;
			FlxG.save.data.stressClear = true;
			trace("mod progress came back lmao");
		}
		#end
		
		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null)
		{
			if (gamepad.justPressed.START)
				pressedEnter = true;

			#if switch
			if (gamepad.justPressed.B)
				pressedEnter = true;
			#end
		}
		
		if (pressedEnter && !transitioning && skippedIntro)
		{
			#if !switch
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end
			
			FlxG.camera.shake(0.001, 0.5);

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.WHITE, 1);
			FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

			transitioning = true;
			// FlxG.sound.music.stop();
			
			new FlxTimer().start(0.8, function(tmr:FlxTimer)
			{
				FlxG.switchState(new MainMenuState());	
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}

		if (pressedEnter && !skippedIntro && initialized)
		{
			skipIntro();
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit()
	{	
		super.beatHit();
		
		bumpLeft = !bumpLeft;
		
		if (bumpLeft)
		{
			logoBl.animation.play('bumpLeft');
		}
		else
		{
			logoBl.animation.play('bumpRight');
		}
		
		gfDance.animation.play('dance');

		FlxG.log.add(curBeat);

		switch (curBeat)
		{
			case 1:
				createCoolText(['tuckerthetucker']);
			// credTextShit.visible = true;
			case 3:
				addMoreText('presents...');
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				if (Main.watermarks)
					createCoolText(['Kade Engine', 'by']);
				else
					createCoolText(['to everyone', 'with']);
			case 7:
				if (Main.watermarks)
					addMoreText('KadeDeveloper');
				else
				{
					addMoreText('diabetus lmao');
				}
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText('FNF');
			// credTextShit.visible = true;
			case 14:
				addMoreText('Cavity');
			// credTextShit.text += '\nNight';
			case 15:
				addMoreText('Crush'); // credTextShit.text += '\nFunkin';

			case 16:
				skipIntro();
		}
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
			remove(ngSpr);

			FlxG.camera.flash(FlxColor.WHITE, 4);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}

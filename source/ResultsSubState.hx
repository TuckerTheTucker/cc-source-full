package;

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
import flixel.addons.transition.FlxTransitionableState;
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
import openfl.Lib;
import flixel.system.FlxSound;
#if windows
import Discord.DiscordClient;
#end

using StringTools;

class ResultsSubState extends MusicBeatSubstate
{
	var curSelected:Int = 0;
	
	var hue:Float = 0;
	
	var pauseMusic:FlxSound;
	
	var blackshit:FlxSprite;
	
	var complete:FlxSprite;
	
	//gee wish i knew how to do arrays
	var exit:FlxText;
	var retry:FlxText;
	var next:FlxText;
	//gotta add in a continue button because next song button is broken on the last song
	var continuet:FlxText;
	
	var resultMiss:FlxText;
	var resultBuwnt:FlxText;
	var resultEw:FlxText;
	var resultSweet:FlxText;
	var resultDeli:FlxText;
	var accuracy:Float = 0.00;
	
	var miss:FlxSprite;
	var buwnt:FlxSprite;
	var ew:FlxSprite;
	var sweet:FlxSprite;
	var deli:FlxSprite;
	
	var songName:FlxText;
	
	var accuracyText:FlxText;
	
	private var storyDifficultyText:String = '';
	var iconRPC:String = "";
	
	public function new(x:Float, y:Float)
	{
		super();
		accuracy = PlayState.accuracy;
		
		if (PlayState.isStoryMode)
		{
			curSelected = 0;
		}
		else
		{
			curSelected = 1;
		}
		
		if (PlayState.SONG.song == 'Melt')
		{
			curSelected = 1;
		}
		
		if (PlayState.storyDifficulty == 0)
			storyDifficultyText = 'Sweet';
		else if (PlayState.storyDifficulty == 1)
			storyDifficultyText = 'Delicious';
		else if (PlayState.storyDifficulty == 2)
			storyDifficultyText = 'Yummy~';
			
		iconRPC = PlayState.SONG.player2;
		
		// To avoid having duplicate images in Discord assets
		switch (iconRPC)
		{
			case 'senpai-angry':
				iconRPC = 'senpai';
			case 'monster-christmas':
				iconRPC = 'monster';
			case 'mom-car':
				iconRPC = 'mom';
			case 'pepperStress':
				iconRPC = 'pepper';
		}
	}
	
	override function create()
	{	
		super.create();
		
		#if windows
		// Results doesn't get his own variable because it's only used here
		DiscordClient.changePresence("SONG CLEAR! -- " + PlayState.SONG.song + " (" + storyDifficultyText + ") " + Ratings.GenerateLetterRank(accuracy),"\nAcc: " + HelperFunctions.truncateFloat(accuracy, 2) + "% | Score: " + PlayState.songScore + " | Misses: " + PlayState.misses  , iconRPC);
		#end
		//WHY DOESNT THIS WORK AAAAAAAAAAAAAAAAAA
		
		FlxG.sound.playMusic(Paths.music('breakfast', 'shared'), 0);
		
		if (PlayState.SONG.song.toLowerCase() != 'melt')
		{
			FlxG.sound.music.fadeIn(8, 0, 0.6);
		}
		else
		{
			FlxG.sound.music.fadeIn(8, 0, 0); //not including the fade in would result in Melt's Inst replaying idfk why
		}
		
		blackshit = new FlxSprite().makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
		blackshit.alpha = 0;
		blackshit.screenCenter();
		blackshit.scrollFactor.set();
		add(blackshit);
		
		if (!FlxG.save.data.botplay)
		{
			miss = new FlxSprite(-7, 560).loadGraphic(Paths.image('miss', 'shared'));
			miss.alpha = 0;
			miss.scrollFactor.set();
			add(miss);
			
			buwnt = new FlxSprite(10, 425).loadGraphic(Paths.image('shit', 'shared'));
			buwnt.alpha = 0;
			buwnt.scrollFactor.set();
			add(buwnt);
			
			ew = new FlxSprite(10, 330).loadGraphic(Paths.image('bad', 'shared'));
			ew.alpha = 0;
			ew.scrollFactor.set();
			add(ew);
			
			sweet = new FlxSprite(10, 220).loadGraphic(Paths.image('good', 'shared'));
			sweet.alpha = 0;
			sweet.scrollFactor.set();
			add(sweet);
			
			deli = new FlxSprite(-20, 80).loadGraphic(Paths.image('sick', 'shared'));
			deli.alpha = 0;
			deli.scrollFactor.set();
			add(deli);
					
			resultMiss = new FlxText(miss.x + 320, miss.y + 50, 0, "", 36);
			resultMiss.alpha = 0;
			resultMiss.setFormat(Paths.font("humans.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			resultMiss.scrollFactor.set();
			resultMiss.text = "" + PlayState.misses;
			add(resultMiss);
			
			resultBuwnt = new FlxText(buwnt.x + 290, buwnt.y + 50, 0, "", 36);
			resultBuwnt.alpha = 0;
			resultBuwnt.setFormat(Paths.font("humans.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			resultBuwnt.scrollFactor.set();
			resultBuwnt.text = "" + PlayState.shits;
			add(resultBuwnt);
			
			resultEw = new FlxText(ew.x + 225, ew.y + 35, 0, "", 36);
			resultEw.alpha = 0;
			resultEw.setFormat(Paths.font("humans.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			resultEw.scrollFactor.set();
			resultEw.text = "" + PlayState.bads;
			add(resultEw);
			
			resultSweet = new FlxText(sweet.x + 300, sweet.y + 50, 0, "", 36);
			resultSweet.alpha = 0;
			resultSweet.setFormat(Paths.font("humans.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			resultSweet.scrollFactor.set();
			resultSweet.text = "" + PlayState.goods;
			add(resultSweet);
			
			resultDeli = new FlxText(deli.x + 400, deli.y + 50, 0, "", 36);
			resultDeli.alpha = 0;
			resultDeli.setFormat(Paths.font("humans.ttf"), 48, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
			resultDeli.scrollFactor.set();
			resultDeli.text = "" + PlayState.sicks;
			add(resultDeli);
		}
		
		complete = new FlxSprite(100, -110).loadGraphic(Paths.image('complete'));
		complete.setGraphicSize(Std.int(complete.width * 1.2));
		complete.alpha = 0;
		complete.screenCenter(X);
		complete.scrollFactor.set();
		add(complete);
		
		songName = new FlxText(375, 60, 0, "followmeontwitterlmao", 28);
		songName.alpha = 0;
		songName.setFormat(Paths.font("humans.ttf"), 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		songName.scrollFactor.set();
		songName.text = (PlayState.SONG.song);
		add(songName);
		
		accuracyText = new FlxText(625, 60, 0, "", 28);
		accuracyText.alpha = 0;
		accuracyText.setFormat(Paths.font("humans.ttf"), 36, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		accuracyText.scrollFactor.set();
		accuracyText.text = (HelperFunctions.truncateFloat(accuracy, 2) + "% Accuracy");
		add(accuracyText);
		
		exit = new FlxText(50, FlxG.height - 20, 0, "Exit", 28);
		exit.alpha = 0;
		exit.setFormat(Paths.font("humans.ttf"), 36, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		exit.scrollFactor.set();
		
		retry = new FlxText(200, FlxG.height - 20, 0, "Retry", 28);
		retry.alpha = 0;
		retry.screenCenter(X);
		retry.setFormat(Paths.font("humans.ttf"), 36, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		retry.scrollFactor.set();
		add(retry);
		
		next = new FlxText(FlxG.width - 100, FlxG.height - 20, 0, "Next Song", 28);
		next.alpha = 0;
		next.setFormat(Paths.font("humans.ttf"), 36, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		next.scrollFactor.set();
		
		continuet = new FlxText(FlxG.width - 100, FlxG.height - 20, 0, "Continue", 28);
		continuet.alpha = 0;
		continuet.setFormat(Paths.font("humans.ttf"), 36, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE,FlxColor.BLACK);
		continuet.scrollFactor.set();
		if (PlayState.SONG.song.toLowerCase() == 'melt' || !PlayState.isStoryMode)
		{
			add(continuet);
		}
		else
		{
			add(next);
			add(exit);
		}
		
		FlxTween.tween(blackshit, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		new FlxTimer().start(0.2, function(tmr:FlxTimer)
			{
				FlxTween.tween(complete, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(songName, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
				
				FlxTween.tween(complete, {y: complete.y + 10}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(songName, {y: songName.y + 10}, 0.4, {ease: FlxEase.quartInOut});
				
				if (!FlxG.save.data.botplay)
				{
					FlxTween.tween(accuracyText, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(accuracyText, {y: accuracyText.y + 10}, 0.4, {ease: FlxEase.quartInOut});
				}
				
			});
		
			if (!FlxG.save.data.botplay)
			{
				new FlxTimer().start(0.5, function(tmr:FlxTimer)
				{
					FlxTween.tween(resultMiss, {y: resultMiss.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultBuwnt, {y: resultBuwnt.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultEw, {y: resultEw.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultSweet, {y: resultSweet.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultDeli, {y: resultDeli.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					
					FlxTween.tween(resultMiss, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultBuwnt, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultEw, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultSweet, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(resultDeli, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					
					FlxTween.tween(miss, {y: miss.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(buwnt, {y: buwnt.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(ew, {y: ew.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(sweet, {y: sweet.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(deli, {y: deli.y + 10}, 0.4, {ease: FlxEase.quartInOut});
					
					FlxTween.tween(miss, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(buwnt, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(ew, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(sweet, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
					FlxTween.tween(deli, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
				});
			}
			new FlxTimer().start(0.7, function(tmr:FlxTimer)
			{
				FlxTween.tween(exit, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(retry, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(next, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(continuet, {alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
				
				FlxTween.tween(exit, {y: exit.y + 10}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(retry, {y: retry.y + 10}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(next, {y: next.y + 10}, 0.4, {ease: FlxEase.quartInOut});
				FlxTween.tween(continuet, {y: continuet.y + 10}, 0.4, {ease: FlxEase.quartInOut});
			});
		
	}

	override function update(elapsed:Float)
	{		
		hue += elapsed * 45;
		if(hue > 360)
			hue -= 360;
		
		complete.color = FlxColor.fromHSB(Std.int(hue), 1, 1);
		
		if (curSelected == 0)
		{
			exit.text = "> Exit";
			retry.text = "Retry";
			next.text = "Next Song";
			continuet.text = "Continue";
		}
		else if (curSelected == 1)
		{
			retry.text = "> Retry";
			exit.text = "Exit";
			next.text = "Next Song";
			continuet.text = "Continue";
		}
		else if (curSelected == 2)
		{
			next.text = "> Next Song";
			continuet.text = "> Continue";
			exit.text = "Exit";
			retry.text = "Retry";
		}
		
		if (controls.RIGHT_P)
		{
			changeSelection(1);
		}
		
		if (controls.LEFT_P)
		{
			changeSelection(-1);
		}
		
		if (controls.ACCEPT)
		{
			switch (curSelected)
			{
				case 0:
					if(PlayState.loadRep)
					{
						FlxG.save.data.botplay = false;
						FlxG.save.data.scrollSpeed = 1;
						FlxG.save.data.downscroll = false;
					}
					PlayState.loadRep = false;
					#if windows
					if (PlayState.luaModchart != null)
					{
						PlayState.luaModchart.die();
						PlayState.luaModchart = null;
					}
					#end
					if (FlxG.save.data.fpsCap > 290)
						(cast (Lib.current.getChildAt(0), Main)).setFPSCap(290);
					
					FlxG.switchState(new StoryMenuState());
				case 1:
					PlayState.hasRestarted = true;
					FlxG.resetState();
				case 2:
					if (PlayState.isStoryMode)
					{
						if (PlayState.hasRestarted)
							PlayState.hasRestarted = false;
					
						if (PlayState.SONG.song == 'Snicker' && PlayState.misses == 0 && PlayState.shits == 0 && !FlxG.save.data.botplay)
						{
							PlayState.snickerNoMiss = true;
							trace("da Snicker wit no misses.");
						}
					
						if (PlayState.SONG.song == 'Butterfingers' && PlayState.misses == 0 && PlayState.shits == 0 && !FlxG.save.data.botplay)
						{
							PlayState.butterNoMiss = true;
							trace("da Butterfingers wit no misses.");
						}
					
						if (PlayState.SONG.song == 'Toothache' && PlayState.misses == 0 && PlayState.shits == 0 && !FlxG.save.data.botplay)
						{
							PlayState.toothNoMiss = true;
							trace("da Toothache wit no misses.");
						}
					
						if (PlayState.SONG.song == 'Melt' && PlayState.misses == 0 && PlayState.shits == 0 && !FlxG.save.data.botplay)
						{
							PlayState.meltNoMiss = true;
							trace("da Melt wit no misses.");
							if (PlayState.toothNoMiss && PlayState.snickerNoMiss && PlayState.butterNoMiss)
							{
								if (PlayState.storyDifficulty == 2)
								{
									FlxG.sound.play(Paths.sound('cheatunlock'));
									FlxG.save.data.weekiUnlock = true;
								}
							}
						}
						//literally copy pasted above fu
						if (PlayState.SONG.song == 'Snicker' && accuracy >= 90 && !FlxG.save.data.botplay)
						{
							PlayState.snicker90Acc = true;
							trace("da Snicker wit da " + HelperFunctions.truncateFloat(accuracy, 2) + "% accuracy");
						}
						
						if (PlayState.SONG.song == 'Butterfingers' && accuracy >= 90 && !FlxG.save.data.botplay)
						{
							PlayState.butter90Acc = true;
							trace("da Butterfingers wit da " + HelperFunctions.truncateFloat(accuracy, 2) + "% accuracy");
						}
						
						if (PlayState.SONG.song == 'Toothache' && accuracy >= 90 && !FlxG.save.data.botplay)
						{
							PlayState.tooth90Acc = true;
							trace("da Toothache wit da " + HelperFunctions.truncateFloat(accuracy, 2) + "% accuracy");
						}
						
						if (PlayState.SONG.song == 'Melt' && accuracy >= 90 && !FlxG.save.data.botplay)
						{
							PlayState.melt90Acc = true;
							trace("da Melt wit da " + HelperFunctions.truncateFloat(accuracy, 2) + "% accuracy");
							if (PlayState.tooth90Acc && PlayState.snicker90Acc && PlayState.butter90Acc)
							{
								if (PlayState.storyDifficulty == 2)
								{
									FlxG.sound.play(Paths.sound('cheatunlock'));
									FlxG.save.data.weeki90Acc = true;
									FlxG.save.flush();
								}
							}
						}
								
						
						if (PlayState.storyPlaylist.length <= 0 || PlayState.SONG.song.toLowerCase() == 'melt')
						{
							trace('all done');
							
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							
							FlxG.switchState(new StoryMenuState());
							
							if (!FlxG.save.data.weekCompleted && !FlxG.save.data.botplay)
							{
								FlxG.save.data.weekCompleted = true;
								FlxG.save.flush();
							}
							
							if (PlayState.SONG.validScore)
							{
								Highscore.saveWeekScore(PlayState.storyWeek, PlayState.campaignScore, PlayState.storyDifficulty);
							}

							#if windows
							if (PlayState.luaModchart != null)
							{
								PlayState.luaModchart.die();
								PlayState.luaModchart = null;
							}
							#end
						}
						else
						{
							trace('next song pls');
							
							var difficulty:String = "";

							if (PlayState.storyDifficulty == 0)
								difficulty = '-easy';

							if (PlayState.storyDifficulty == 2)
								difficulty = '-hard';
								
							
							PlayState.storyPlaylist.remove(PlayState.storyPlaylist[0]);
							
							trace('LOADING NEXT SONG');
							// pre lowercasing the next story song name
							var nextSongLowercase = StringTools.replace(PlayState.storyPlaylist[0], " ", "-").toLowerCase();
								switch (nextSongLowercase) {
									case 'dad-battle': nextSongLowercase = 'dadbattle';
									case 'philly-nice': nextSongLowercase = 'philly';
								}
							trace(nextSongLowercase + difficulty);

							// pre lowercasing the song name (endSong)
							var songLowercase = StringTools.replace(PlayState.SONG.song, " ", "-").toLowerCase();
								switch (songLowercase) {
									case 'dad-battle': songLowercase = 'dadbattle';
									case 'philly-nice': songLowercase = 'philly';
							}

							FlxTransitionableState.skipNextTransIn = true;
							FlxTransitionableState.skipNextTransOut = true;
							PlayState.prevCamFollow = PlayState.camFollow;
							
							PlayState.SONG = Song.loadFromJson(nextSongLowercase + difficulty, PlayState.storyPlaylist[0]);
							FlxG.sound.music.stop();

							LoadingState.loadAndSwitchState(new PlayState());
						}
					}
					else
					{
						if (PlayState.SONG.song == 'Stresspepper')
						{
							if (accuracy >= 90 && PlayState.storyDifficulty == 2 && !FlxG.save.data.botplay)
							{
								if (!FlxG.save.data.stressClear)
								{
									FlxG.sound.play(Paths.sound('cheatunlock'));
									FlxG.save.data.stressClear = true;
									FlxG.save.flush();
								}
							}
						}
						
						FlxG.switchState(new FreeplayState());
					}
					
			}
		}
		
		
		super.update(elapsed);
    }
	
	function changeSelection(cbt:Int = 0)
	{
		curSelected += cbt;
		
		FlxG.sound.play(Paths.sound('scrollMenu'));
		
		if (curSelected > 2)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = 2;
			
		if (!PlayState.isStoryMode || PlayState.SONG.song.toLowerCase() == 'melt')
		{
			if (curSelected == 0)
				curSelected = 2;
		}
	}
}
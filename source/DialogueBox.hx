package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;
	
	var isPepper:Bool = false;
	var bfStarts:Bool = false; //if youre changing the dialogue and pepper comes first set it to false
	
	var holdP1:Int = 0;
	var holdP2:Int = 0;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;

	var bgFade:FlxSprite;
	
	var escText:FlxText;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();
		if (PlayState.isStoryMode) //only play in story mode
		{
			if (!PlayState.hasRestarted) //dont play if the song has been restarted
			{
				switch (PlayState.SONG.song.toLowerCase())
				{
					case 'senpai':
						FlxG.sound.playMusic(Paths.music('Lunchbox'), 0);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					case 'thorns':
						FlxG.sound.playMusic(Paths.music('LunchboxScary'), 0);
						FlxG.sound.music.fadeIn(1, 0, 0.8);
					case 'snicker':
						FlxG.sound.playMusic(Paths.music('makinShakesWithLove'), 0);
						FlxG.sound.music.fadeIn(6, 0, 0.2);
					case 'melt':
						FlxG.sound.playMusic(Paths.music('burn'), 0);
						FlxG.sound.music.fadeIn(4, 0, 0.2);
				}
			}
		}

		bgFade = new FlxSprite( -200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFF8E6C58);
		bgFade.scrollFactor.set();
		bgFade.screenCenter();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		box = new FlxSprite(-20, 45);
		
		var hasDialog = false;
		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'senpai':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-pixel');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
			case 'roses':
				hasDialog = true;
				FlxG.sound.play(Paths.sound('ANGRY_TEXT_BOX'));

				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-senpaiMad');
				box.animation.addByPrefix('normalOpen', 'SENPAI ANGRY IMPACT SPEECH', 24, false);
				box.animation.addByIndices('normal', 'SENPAI ANGRY IMPACT SPEECH', [4], "", 24);

			case 'thorns':
				hasDialog = true;
				box.frames = Paths.getSparrowAtlas('weeb/pixelUI/dialogueBox-evil');
				box.animation.addByPrefix('normalOpen', 'Spirit Textbox spawn', 24, false);
				box.animation.addByIndices('normal', 'Spirit Textbox spawn', [11], "", 24);
				
				var face:FlxSprite = new FlxSprite(320, 170).loadGraphic(Paths.image('weeb/spiritFaceForward'));
				face.setGraphicSize(Std.int(face.width * 6));
				add(face);
			
			case 'snicker':
				hasDialog = true;
				bfStarts = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24);
				box.animation.addByPrefix('dessertOpen', 'Speech Bubble Dessert Open', 24, false);
				box.animation.addByPrefix('dessert', 'speech bubble Dessert', 24);
				box.width = 250;
				box.height = 500;
				box.y = 350;
				
			case 'butterfingers':
				hasDialog = true;
				bfStarts = false;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24);
				box.animation.addByPrefix('dessertOpen', 'Speech Bubble Dessert Open', 24, false);
				box.animation.addByPrefix('dessert', 'speech bubble Dessert', 24);
				box.width = 250;
				box.height = 500;
				box.y = 350;
				
			case 'toothache':
				hasDialog = true;
				bfStarts = true;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24);
				box.animation.addByPrefix('dessertOpen', 'Speech Bubble Dessert Open', 24, false);
				box.animation.addByPrefix('dessert', 'speech bubble Dessert', 24);
				box.width = 250;
				box.height = 500;
				box.y = 350;
				
			case 'melt':
				hasDialog = true;
				bfStarts = false;
				box.frames = Paths.getSparrowAtlas('speech_bubble_talking', 'shared');
				box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
				box.animation.addByPrefix('normal', 'speech bubble normal', 24);
				box.animation.addByPrefix('dessertOpen', 'Speech Bubble Dessert Open', 24, false);
				box.animation.addByPrefix('dessert', 'speech bubble Dessert', 24);
				box.width = 250;
				box.height = 500;
				box.y = 350;
		}

		this.dialogueList = dialogueList;
		
		if (hasDialog)
		{
			trace('song has dialogue :D');
		}
		else
		{
			return;
			trace('song has no dialogue :C');
		}
		
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft = new FlxSprite(-20, 40);
			portraitLeft.frames = Paths.getSparrowAtlas('weeb/senpaiPortrait');
			portraitLeft.animation.addByPrefix('enter', 'Senpai Portrait Enter', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.9));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			add(portraitLeft);
			portraitLeft.visible = false;
		}
		else if (PlayState.SONG.song.toLowerCase() == 'snicker' || PlayState.SONG.song.toLowerCase() == 'butterfingers' || PlayState.SONG.song.toLowerCase() == 'toothache' || PlayState.SONG.song.toLowerCase() == 'melt')
		{
			portraitLeft = new FlxSprite(50, 100);
			portraitLeft.frames = Paths.getSparrowAtlas('dialoguePepper');
			portraitLeft.animation.addByPrefix('enterAngy', 'dialangy', 24, false);
			portraitLeft.animation.addByPrefix('enterNorm', 'dialnorm', 24, false);
			portraitLeft.animation.addByPrefix('enterHap', 'dialhappy', 24, false);
			portraitLeft.animation.addByPrefix('enterShock', 'dialshock', 24, false);
			portraitLeft.animation.addByPrefix('enterSus', 'dialsus', 24, false);
			portraitLeft.animation.addByPrefix('enterNerv', 'dialnervo', 24, false);
			portraitLeft.animation.addByPrefix('enterSurp', 'dialsurp', 24, false);
			portraitLeft.animation.addByPrefix('enterAAA', 'dialaaa', 24, false);
			portraitLeft.animation.addByPrefix('enterYay', 'dialyay', 24, false);
			portraitLeft.animation.addByPrefix('enterSad', 'dialsad', 24, false);
			portraitLeft.animation.addByPrefix('enterLesGo', 'diallesgo', 24, false);
			portraitLeft.animation.addByPrefix('enter', 'dialidle', 24, false);
			portraitLeft.setGraphicSize(Std.int(portraitLeft.width * PlayState.daPixelZoom * 0.2));
			portraitLeft.updateHitbox();
			portraitLeft.scrollFactor.set();
			portraitLeft.antialiasing = true;
			portraitLeft.alpha = 0;
			add(portraitLeft);
			portraitLeft.visible = false;
		}
		
		if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'roses' || PlayState.SONG.song.toLowerCase() == 'thorns')
		{			
			portraitRight = new FlxSprite(0, 40);
			portraitRight.frames = Paths.getSparrowAtlas('weeb/bfPortrait');
			portraitRight.animation.addByPrefix('enter', 'Boyfriend portrait enter', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * 1.1));
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			add(portraitRight);
			portraitRight.visible = false;
		}
		else if (PlayState.SONG.song.toLowerCase() == 'snicker' || PlayState.SONG.song.toLowerCase() == 'butterfingers' || PlayState.SONG.song.toLowerCase() == 'toothache' || PlayState.SONG.song.toLowerCase() == 'melt')
		{
			portraitRight = new FlxSprite(FlxG.width - 500, 150);
			portraitRight.frames = Paths.getSparrowAtlas('dialogueBF');
			portraitRight.animation.addByPrefix('enter', 'bfIdle', 24, false);
			portraitRight.animation.addByPrefix('enterScare', 'bfscared', 24, false);
			portraitRight.animation.addByPrefix('enterOop', 'bfuhh', 24, false);
			portraitRight.animation.addByPrefix('enterYes', 'bfyeah', 24, false);
			portraitRight.animation.addByPrefix('enterBlank', 'bfblank', 24, false);
			portraitRight.setGraphicSize(Std.int(portraitRight.width * 1.1));
			portraitRight.antialiasing = true;
			portraitRight.updateHitbox();
			portraitRight.scrollFactor.set();
			portraitRight.alpha = 0;
			add(portraitRight);
			portraitRight.visible = false;
		}
		
		if (bfStarts)
			box.animation.play('normalOpen');
		else
			box.animation.play('dessertOpen');
		box.flipX = true;
		box.x = 10;
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);
	
		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9);
		handSelect.frames = Paths.getSparrowAtlas('hand_textbox', 'shared');
		handSelect.animation.addByPrefix('idle', 'handpointing', 24, true);
		handSelect.animation.addByPrefix('select', 'handconfirm', 24, false);
		handSelect.setGraphicSize(Std.int(handSelect.width * 1.2));
		handSelect.antialiasing = true;
		handSelect.updateHitbox();
		handSelect.scrollFactor.set();
		handSelect.animation.play('idle');
		add(handSelect);
		handSelect.visible = false;

		dropText = new FlxText(127, 482, Std.int(FlxG.width * 0.8), "", 48);
		add(dropText);

		swagDialogue = new FlxTypeText(125, 480, Std.int(FlxG.width * 0.8), "", 48);
		swagDialogue.font = 'Humanst521 BT Roman';
		add(swagDialogue);
		
		escText = new FlxText(40, FlxG.height - 30, 0, "Press ESCAPE to Skip", 16);
		escText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, RIGHT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		escText.scrollFactor.set();
		add(escText);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;
	public static var dialogueClosed:Bool = false; //used to prevent unlocking one of the achievements, thats why its public
	
	
	override function update(elapsed:Float)
	{
		if (holdP2 == 2) //i know i fucked up p2 is bf and p1 is pepper im sorry but i have to release this mod in like an hour aaaaa
		{
			portraitRight.x = FlxG.width - 500;
			portraitRight.alpha = 0;
			portraitRight.visible = false;
			//i wanted to make it so it fades out but i couldnt find a way to get them to come back
		}
		
		if (holdP1 == 2)
		{
			portraitLeft.x = 50;
			portraitLeft.alpha = 0;
			portraitLeft.visible = false;
		}
		
		//ima save a few copy pastes
		if (isPepper)
		{
			//what should happen when its pepper's turn with the dialogue box
			swagDialogue.color = 0xFF140F00;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('pepperText', 'shared'), 0.4)];
			dropText.color = 0xFFADA577;
			box.flipX = true;
		}
		else
		{
			//what should happen when its bf's turn with the dialogue box
			swagDialogue.color = 0xFF31B0D1;
			swagDialogue.sounds = [FlxG.sound.load(Paths.sound('bfText', 'shared'), 0.4)];
			dropText.color = 0xFFADA577;
			box.flipX = false;
		}
		
		// HARD CODING CUZ IM STUPDI
		if (PlayState.SONG.song.toLowerCase() == 'roses')
			portraitLeft.visible = false;
		if (PlayState.SONG.song.toLowerCase() == 'thorns')
		{
			portraitLeft.color = FlxColor.BLACK;
			swagDialogue.color = FlxColor.WHITE;
			dropText.color = FlxColor.BLACK;
		}
		
		dropText.text = swagDialogue.text;
		dropText.font = swagDialogue.font;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'dessertOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('dessert');
				dialogueOpened = true;
				handSelect.visible = true;
			}
			
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
				handSelect.visible = true;
			}
		}
		
		if (handSelect.animation.curAnim != null)
		{
			if (handSelect.animation.curAnim.name == 'select' && handSelect.animation.curAnim.finished)
			{
				handSelect.animation.play('idle');
				handSelect.x += 10;
				handSelect.y += 15;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if (FlxG.keys.justPressed.ANY  && dialogueStarted == true)
		{
			remove(dialogue);
			
			if (!isEnding)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				handSelect.animation.play('select');
				handSelect.x -= 10;
				handSelect.y -= 15;
			}
			
			if (dialogueList[1] == null && dialogueList[0] != null || FlxG.keys.justPressed.ESCAPE)
			{
				if (!isEnding)
				{
					isEnding = true;
					
					escText.visible = false;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns' || PlayState.SONG.song.toLowerCase() == 'snicker')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						handSelect.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
						dialogueClosed = true;
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}
		
		super.update(elapsed);
	}

	var isEnding:Bool = false;

	function startDialogue():Void
	{
		cleanDialog();
		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.04, true);

		switch (curCharacter)
		{
			case 'pepang':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterAngy');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepnorm':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterNorm');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pephap':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterHap');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepshock':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterShock');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepsus':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterSus');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepnerv':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterNerv');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepsurp':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterSurp');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepper':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enter');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepaaa':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterAAA');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepyay':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterYay');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepsad':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterSad');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'pepgo':
				isPepper = true;
				holdP2++;
				holdP1 = 0;
				portraitLeft.animation.play('enterLesGo');
				box.animation.play('dessert');
				if (!portraitLeft.visible)
				{
					appearLeft();
					portraitLeft.visible = true;
				}
			case 'bf':
				isPepper = false;
				holdP1++;
				holdP2 = 0;
				portraitRight.animation.play('enter');
				box.animation.play('normal');
				if (!portraitRight.visible)
				{
					appearRight();
					portraitRight.visible = true;
				}
			case 'bfscared':
				isPepper = false;
				holdP1++;
				holdP2 = 0;
				portraitRight.animation.play('enterScare');
				box.animation.play('normal');
				if (!portraitRight.visible)
				{
					appearRight();
					portraitRight.visible = true;
				}
			case 'bfuhh':
				isPepper = false;
				holdP1++;
				holdP2 = 0;
				portraitRight.animation.play('enterOop');
				box.animation.play('normal');
				if (!portraitRight.visible)
				{
					appearRight();
					portraitRight.visible = true;
				}
			case 'bfyeah':
				isPepper = false;
				holdP1++;
				holdP2 = 0;
				portraitRight.animation.play('enterYes');
				box.animation.play('normal');
				if (!portraitRight.visible)
				{
					appearRight();
					portraitRight.visible = true;
				}
			case 'bfblank':
				isPepper = false;
				holdP1++;
				holdP2 = 0;
				portraitRight.animation.play('enterBlank');
				box.animation.play('normal');
				if (!portraitRight.visible)
				{
					appearRight();
					portraitRight.visible = true;
				}
		}
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[1];
		dialogueList[0] = dialogueList[0].substr(splitName[1].length + 2).trim();
	}
	
	function appearLeft():Void
	{
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			portraitLeft.alpha += 1 / 5;
			portraitLeft.x -= 1;
		}, 5);
	}
	
	function appearRight():Void
	{
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			portraitRight.alpha += 1 / 5;
			portraitRight.x += 1;
		}, 5);
	}
}

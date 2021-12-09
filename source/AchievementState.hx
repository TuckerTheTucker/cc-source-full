package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;

using StringTools;

class AchievementState extends MusicBeatState //i made the wonkiest and clunkiest achievement system ever. be proud of me damnit! >:(
{	
	var icon1:FlxSprite;
	var icon2:FlxSprite;
	var icon3:FlxSprite;
	var icon4:FlxSprite;
	
	var text1:FlxText;
	var text2:FlxText;
	var text3:FlxText;
	var text4:FlxText;
	
	var desc1:FlxText;
	var desc2:FlxText;
	var desc3:FlxText;
	var desc4:FlxText;
	
	public static var goBackA:Bool = false;
	
	override function create()
	{
		var bg:FlxSprite = new FlxSprite( -80).loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFFCFCD3;
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);
		
		if (goBackA)
			goBackA = false;
			
		if (StoryMenuState.goBackS)
			StoryMenuState.goBackS = false;
			
		if (FreeplayState.goBackF)
			FreeplayState.goBackF = false;
			
		if (OptionsMenu.goBackO)
			OptionsMenu.goBackO = false;

		if (FlxG.save.data.weeki90Acc)
			icon1 = new FlxSprite(0, -25).loadGraphic(Paths.image('achievementicons/achievementicon1', 'shared'));
		else
			icon1 = new FlxSprite(0, -25).loadGraphic(Paths.image('achievementicons/achievementiconmystery', 'shared'));
		icon1.antialiasing = true;
		icon1.setGraphicSize(Std.int(icon1.width * 0.6));
		add(icon1);
		
		if (FlxG.save.data.weekiUnlock)
			icon2 = new FlxSprite(0, 150).loadGraphic(Paths.image('achievementicons/achievementicon2', 'shared'));
		else
			icon2 = new FlxSprite(0, 150).loadGraphic(Paths.image('achievementicons/achievementiconmystery', 'shared'));
		icon2.antialiasing = true;
		icon2.setGraphicSize(Std.int(icon2.width * 0.6));
		add(icon2);
		
		if (FlxG.save.data.fall)
			icon3 = new FlxSprite(0, 325).loadGraphic(Paths.image('achievementicons/achievementicon3', 'shared'));
		else
			icon3 = new FlxSprite(0, 325).loadGraphic(Paths.image('achievementicons/achievementiconmystery', 'shared'));
		icon3.antialiasing = true;
		icon3.setGraphicSize(Std.int(icon3.width * 0.6));
		add(icon3);
		
		if (FlxG.save.data.stressClear)
			icon4 = new FlxSprite(0, 500).loadGraphic(Paths.image('achievementicons/achievementicon4', 'shared'));
		else
			icon4 = new FlxSprite(0, 500).loadGraphic(Paths.image('achievementicons/achievementiconmystery', 'shared'));
		icon4.antialiasing = true;
		icon4.setGraphicSize(Std.int(icon4.width * 0.6));
		add(icon4);
		
		text1 = new FlxText(icon1.x + 220, icon1.y + 75, 0, "And That's How the Cookie Crumbles!", 36);
		text1.scrollFactor.set();
		if (FlxG.save.data.weeki90Acc)
			text1.setFormat("VCR OSD Mono", 36, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		else 
			text1.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text1);
		
		text2 = new FlxText(icon2.x + 220, icon2.y + 75, 0, "Professional Sweets Expert.", 36);
		text2.scrollFactor.set();
		if (FlxG.save.data.weekiUnlock)
			text2.setFormat("VCR OSD Mono", 36, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		else 
			text2.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(text2);
		
		if (FlxG.save.data.fall)
		{
			text3 = new FlxText(icon3.x + 220, icon3.y + 75, 0, "Take The L!!", 36);
			text3.setFormat("VCR OSD Mono", 36, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		}
		else
		{
			text3 = new FlxText(icon3.x + 220, icon3.y + 75, 0, "???.", 36);
			text3.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		text3.scrollFactor.set();
		add(text3);
		
		if (FlxG.save.data.stressClear)
		{
			text4 = new FlxText(icon4.x + 220, icon4.y + 75, 0, "Pretty Good, Kid.", 36);
			text4.setFormat("VCR OSD Mono", 36, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		}
		else
		{
			text4 = new FlxText(icon4.x + 220, icon4.y + 75, 0, "???.", 36);
			text4.setFormat("VCR OSD Mono", 36, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		text4.scrollFactor.set();
		add(text4);
		
		desc1 = new FlxText(icon1.x + 220, text1.y + 36, 0, "Beat Every Song in Story Mode on Hard with a 90% Accuracy or Higher.", 16);
		desc1.scrollFactor.set();
		if (FlxG.save.data.weeki90Acc)
			desc1.setFormat("VCR OSD Mono", 24, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		else
			desc1.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(desc1);
		
		desc2 = new FlxText(icon2.x + 220, text2.y + 36, 0, "Beat Cavity Crush on Hard w/ No Misses.", 16);
		desc2.scrollFactor.set();
		if (FlxG.save.data.weekiUnlock)
			desc2.setFormat("VCR OSD Mono", 24, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		else 
			desc2.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(desc2);
		
		if (FlxG.save.data.fall)
		{
			desc3 = new FlxText(icon3.x + 220, text3.y + 36, 0, "Give 100 L's on the Last Song", 16);
			desc3.setFormat("VCR OSD Mono", 24, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		}
		else
		{
			desc3 = new FlxText(icon3.x + 220, text3.y + 36, 0, "This is a Secret Achievement.", 16);
			desc3.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		desc3.scrollFactor.set();
		add(desc3);
		
		if (FlxG.save.data.stressClear)
		{
			desc4 = new FlxText(icon4.x + 220, text4.y + 36, 0, "Beat Stresspepper on Hard with a 90% Accuracy or Higher.", 16);
			desc4.setFormat("VCR OSD Mono", 24, 0xFFD1B24D, LEFT, FlxTextBorderStyle.OUTLINE, 0xFF190D00);
		}
		else
		{
			desc4 = new FlxText(icon4.x + 220, text4.y + 36, 0, "This is a Secret Achievement.", 16);
			desc4.setFormat("VCR OSD Mono", 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		}
		desc4.scrollFactor.set();
		add(desc4);
		
		super.create();
	}
	
	override function update(elapsed:Float)
	{
		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
			goBackA = true;
		}
		
		super.update(elapsed);
	}
}
package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class CharacterSetting
{
	public var x(default, null):Int;
	public var y(default, null):Int;
	public var scale(default, null):Float;
	public var flipped(default, null):Bool;

	public function new(x:Int = 0, y:Int = 0, scale:Float = 1.0, flipped:Bool = false)
	{
		this.x = x;
		this.y = y;
		this.scale = scale;
		this.flipped = flipped;
	}
}

class MenuCharacter extends FlxSprite
{
	private static var settings:Map<String, CharacterSetting> = [
		'bf' => new CharacterSetting(0, -20, 1.0, true),
		'gf' => new CharacterSetting(50, 80, 1.5, true),
		'pepper' => new CharacterSetting(-125, -40, 1)
	];

	private var flipped:Bool = false;

	public function new(x:Int, y:Int, scale:Float, flipped:Bool)
	{
		super(x, y);
		this.flipped = flipped;

		antialiasing = true;

		frames = Paths.getSparrowAtlas('campaign_menu_UI_characters');

		animation.addByPrefix('bf', "BF idle dance white", 24, false);
		animation.addByPrefix('bfConfirm', 'BF HEY!!', 24, false);
		animation.addByIndices('gfLeft', "GF Dancing Beat WHITE", [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		animation.addByIndices('gfRight', "GF Dancing Beat WHITE", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		animation.addByPrefix('gfConfirm', 'GF Cheer', 24, false);
		animation.addByPrefix('pepper', 'pepper sleepy', 24);
		animation.addByPrefix('pepConfirm', 'pepper getup', 24, false);
		setGraphicSize(Std.int(width * scale));
		updateHitbox();
	}

	public function setCharacter(character:String):Void
	{
		if (character == '')
		{
			visible = false;
			return;
		}
		else
		{
			visible = true;
		}
		
		if (character == 'pepper')
		{
			animation.play(character);
		}
		
		var setting:CharacterSetting = settings[character];
		offset.set(setting.x, setting.y);
		setGraphicSize(Std.int(width * setting.scale));
		flipX = setting.flipped != flipped;
	}
}

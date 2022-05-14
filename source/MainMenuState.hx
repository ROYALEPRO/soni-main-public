package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;
import flixel.addons.display.FlxBackdrop;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.1-git'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		'options',
		'credits'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	var arrow:FlxSprite;
	var thing:FlxSprite;
	var thingi:FlxSprite;
	var circle:FlxSprite;
	var guy:Int;

	var thingX:Float;
	var thingY:Float;

	var face:FlxBackdrop;

	var codes:FlxSprite;

	override function create()
	{
		if(FlxG.save.data.beatedSoni)
			FlxG.mouse.visible = true;

		WeekData.loadTheFirstEnabledMod();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];
		Conductor.changeBPM(110);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/soni/bg'));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		add(bg);

		face = new FlxBackdrop(Paths.image('mainmenu/soni/faces/story_mode'), 0.2, 0.2, true, true);
		face.x -= 35;
		face.antialiasing = ClientPrefs.globalAntialiasing;
		add(face);

		var select:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('mainmenu/soni/select'));
		select.updateHitbox();
		select.screenCenter(X);
		select.antialiasing = ClientPrefs.globalAntialiasing;
		add(select);

		circle = new FlxSprite().loadGraphic(Paths.image('mainmenu/soni/circle'));
		circle.updateHitbox();
		circle.screenCenter();
		circle.antialiasing = ClientPrefs.globalAntialiasing;
		add(circle);

		thing = new FlxSprite();
		thing.frames = Paths.getSparrowAtlas('mainmenu/soni/things');
		thing.screenCenter();
		thingY = thing.y -= 20;
		thingX = thing.x -= 10;
		thing.x = thingX;
		thing.y = thingY;
		thing.antialiasing = ClientPrefs.globalAntialiasing;
		//thing.animation.curAnim.curFrame = TitleState.curSoniFrame;
		add(thing);

		thingi = new FlxSprite();
		thingi.frames = Paths.getSparrowAtlas('mainmenu/soni/things');
		thingi.screenCenter();
		thingi.visible = false;
		thingi.antialiasing = ClientPrefs.globalAntialiasing;
		add(thingi);

		codes = new FlxSprite().loadGraphic(Paths.image('mainmenu/soni/soni_codes'));
		codes.setGraphicSize(261,158);
		codes.updateHitbox();
		codes.antialiasing = ClientPrefs.globalAntialiasing;
		if(FlxG.save.data.beatedSoni)
			add(codes);

		arrow = new FlxSprite(110, 481).loadGraphic(Paths.image('mainmenu/soni/arrow'));
		arrow.updateHitbox();
		arrow.antialiasing = ClientPrefs.globalAntialiasing;

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, 549).loadGraphic(Paths.image('mainmenu/soni/${optionShit[i]}'));
			menuItem.ID = i;
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.globalAntialiasing;
			//menuItem.setGraphicSize(Std.int(menuItem.width * 0.58));
			menuItem.updateHitbox();

			switch(menuItem.ID)
			{
				case 0:
					menuItem.x = 0;
				case 1:
					menuItem.x = 319;
				case 2:
					menuItem.x = 647;
				case 3:
					menuItem.x = 958;
			}
		}

		add(arrow);

		/*var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Friday Night Funkin' v" + Application.current.meta.get('version'), 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);*/

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE //No more Friday Night Funkin' :DDDD -royal
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		face.x += .5*(elapsed/(1/120));
		face.y += .5*(elapsed/(1/120));

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if(FlxG.mouse.overlaps(codes))
			if(FlxG.mouse.justPressed)
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new Codes());
			}

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}
			else if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}
			else if (controls.UI_RIGHT_P && controls.UI_LEFT_P){}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState(new TransitionData(NONE), new TransitionData(NONE)));
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
				else
				{
					selectedSomethin = true;
					FlxG.sound.play(Paths.sound('confirmMenu'));

					menuItems.forEach(function(spr:FlxSprite)
					{
						if (curSelected != spr.ID)
						{
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween)
								{
									spr.kill();
								}
							});
						}
						else
						{
							FlxTween.tween(arrow, {y: 502}, 0.4, {ease: FlxEase.smoothStepInOut, onComplete: function(twn:FlxTween)
								{
									FlxTween.tween(arrow, {y: arrow.height * -1}, 0.5, {ease: FlxEase.expoIn});
								}
							});
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
							{
								var daChoice:String = optionShit[curSelected];

								switch (daChoice)
								{
									case 'story_mode':
										MusicBeatState.switchState(new StoryMenuState());
									case 'freeplay':
										MusicBeatState.switchState(new FreeplayState());
									#if MODS_ALLOWED
									case 'mods':
										MusicBeatState.switchState(new ModsMenuState());
									#end
									case 'awards':
										MusicBeatState.switchState(new AchievementsMenuState());
									case 'credits':
										MusicBeatState.switchState(new CreditsState());
									case 'options':
										LoadingState.loadAndSwitchState(new options.OptionsState(), false, false);
								}

								if(FlxG.save.data.beatedSoni)
									FlxG.mouse.visible = false;
							});
						}
					});
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		guy = FlxG.random.int(1,5);
		if(guy > 5) guy = 1;

		thing.animation.addByPrefix('idle', optionShit[curSelected], 24);
		thingi.animation.addByPrefix('idle', 'freeplay' + guy, 24);

		if(curSelected != 1)
		{
			thingi.visible = false;
			thing.visible = true;
			thing.animation.play('idle');
			thingi.animation.stop();
		} else if (curSelected == 1)
		{
			thingi.visible = true;
			thing.visible = false;
			thingi.animation.play('idle');
			thing.animation.stop();

			switch(guy)
			{
				case 1:
					thingi.x = 640 - 135;
					thingi.y = 360 - 105;
				case 2:
					thingi.x = 640 - 170;
					thingi.y = 360 - 95;
				case 3: 
					thingi.x = 640 - 155;
					thingi.y = 360 - 80;
				case 4:
					thingi.x = 640 - 160;
					thingi.y = 360 - 140;
				case 5:
					thingi.x = 640 - 185;
					thingi.y = 360 - 104;
			}
		}

		switch(curSelected)
		{
			case 0:
				thing.y = thingY;
				thing.x = thingX - 100;
			case 2 | 3:
				thing.y = thingY;
				thing.x = thingX;
		}

		face.loadGraphic(Paths.image('mainmenu/soni/faces/${optionShit[curSelected]}'));

		menuItems.forEach(function(spr:FlxSprite)
		{
			if(spr.y != 549)
			{
				FlxTween.tween(spr, {y: 549}, 0.1, {ease: FlxEase.smootherStepInOut});
			}
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				FlxTween.tween(arrow, {x: spr.x + 110}, 0.1, {ease: FlxEase.smootherStepInOut});
				FlxTween.tween(spr, {y: spr.y - 10}, 0.1, {ease: FlxEase.smootherStepInOut});
			}
		});
	}
}

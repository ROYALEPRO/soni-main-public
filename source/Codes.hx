package;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.FlxG;
import flixel.input.FlxAccelerometer;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.FlxSprite;

class Codes extends MusicBeatState
{
    var nokiaBG:FlxSprite;
    var numbersSpr:FlxTypedGroup<FlxSprite>;
    var code:FlxText;
    var selection:Int;

    var canSelect:Bool = true;

    override function create()
    {
        FlxG.mouse.visible = true;

        PlayState.isStoryMode = false;
        PlayState.isCode = true;

        nokiaBG = new FlxSprite().loadGraphic(Paths.image('menu_code/Nokia_png_full_hd'));
        nokiaBG.screenCenter();
        nokiaBG.antialiasing = ClientPrefs.globalAntialiasing;
        add(nokiaBG);

        numbersSpr = new FlxTypedGroup<FlxSprite>();
        add(numbersSpr);

        for (i in 0...10)
        {
            var button:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menu_code/buttons/Boton_$i'));
            button.antialiasing = ClientPrefs.globalAntialiasing;
            switch(i)
            {
                case 0:
                    button.setPosition(617,617);
                    button.setGraphicSize(58,33);
                case 1:
                    button.setPosition(542,555);
                    button.setGraphicSize(56,40);
                case 2:
                    button.setPosition(617,570);
                    button.setGraphicSize(58,34);
                case 3:
                    button.setPosition(693,557);
                    button.setGraphicSize(55,38);
                case 4:
                    button.setPosition(540,512);
                    button.setGraphicSize(53,36);
                case 5:
                    button.setPosition(617,525);
                    button.setGraphicSize(57,33);
                case 6:
                    button.setPosition(697,511);
                    button.setGraphicSize(54,37);
                case 7:
                    button.setPosition(536,463);
                    button.setGraphicSize(57,39);
                case 8:
                    button.setPosition(616,476);
                    button.setGraphicSize(59,35);
                case 9:
                    button.setPosition(699,463);
                    button.setGraphicSize(56,39);
            }
            button.ID = i;
            button.updateHitbox();
            button.y -= 5;
            numbersSpr.add(button);
        }

        code = new FlxText(565, 231, 200, "", 80);
        code.setFormat(Paths.font("vcr.ttf"), 80, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        code.text = '';
        code.screenCenter(X);
        code.x += 3;
        add(code);

        super.create();
    }

    override function update(elapsed:Float)
    {
        numbersSpr.forEach(function(spr:FlxSprite)
        {
            if(FlxG.mouse.overlaps(spr))
                selection = spr.ID;
        });
        //trace(selection);

        super.update(elapsed);

        if (controls.BACK && canSelect) //me when the so
        {
            MusicBeatState.switchState(new MainMenuState());
            if(!FlxG.save.data.beatedSoni)
                FlxG.mouse.visible = false;
        }

        for (i in numbersSpr)
            if(FlxG.mouse.overlaps(i) && canSelect)
                if(code.text.length < 4)
                    if(FlxG.mouse.justPressed)
                        code.text += selection; //if you see this talk me to my discord: ROYAL#5081                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 :trollface:

        if(controls.ACCEPT)
            switch(code.text)
            {
                case '1811': //Werhog code
                    PlayState.SONG = Song.loadFromJson('unleashed', 'unleashed');
                    LoadingState.loadAndSwitchState(new PlayState());
                    FlxG.mouse.visible = false;
                case '0907': //ou code (tgt shadow lmao)
                    PlayState.SONG = Song.loadFromJson('ou', 'ou');
                    LoadingState.loadAndSwitchState(new PlayState());
                    FlxG.mouse.visible = false;
                case '1902': //neobeat oode
                    PlayState.SONG = Song.loadFromJson('please', 'please');
                    LoadingState.loadAndSwitchState(new PlayState());
                    FlxG.mouse.visible = false;
                case '2012': //bil billetes cipher
                    PlayState.SONG = Song.loadFromJson('broken-reality', 'broken-reality');
                    LoadingState.loadAndSwitchState(new PlayState());
                    FlxG.mouse.visible = false;
                case '0069': //sonibars (best song)
                    PlayState.SONG = Song.loadFromJson('sonibars', 'sonibars');
                    LoadingState.loadAndSwitchState(new PlayState());
                    FlxG.mouse.visible = false;
                case '7545': //Shadow fucking die bruhhh
                    FlxG.mouse.visible = false;
                    FlxG.sound.pause();
                    canSelect = false;
					(new FlxVideo(Paths.video('die'))).finishCallback = function() {

                        FlxG.sound.resume();
                        FlxG.mouse.visible = true;
                        canSelect = true;
                    }
                    code.text = '';
                case '6969': //Funni peter griffin running code
                    FlxG.mouse.visible = false;
                    FlxG.sound.pause();
                    canSelect = false;
					(new FlxVideo(Paths.video('Peter Griffin in City Escape'))).finishCallback = function() {

                        FlxG.sound.resume();
                        FlxG.mouse.visible = true;
                        canSelect = true;
                    }
                    code.text = '';
                default: //Nothing lol
                    code.text = '';
                    if(canSelect)
                        FlxG.camera.shake(0.015, 0.2);
            }
    }
}
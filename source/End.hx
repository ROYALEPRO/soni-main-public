package;
import flixel.*;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class End extends MusicBeatState
{
    public function new() 
    {
        super();
    }

    var continuePlsSine:Float = 0;
    var continuePls:FlxText;
 
    override function create() 
    {
        super.create();
  
        var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('codesImg'));
        bg.antialiasing = ClientPrefs.globalAntialiasing;
        add(bg);

        continuePls = new FlxText(810, 680, 465, "PRESS ENTER TO CONTINUE", 32);
		continuePls.setFormat("Arial", 32, FlxColor.WHITE, CENTER, NONE, FlxColor.BLACK);
		continuePls.scrollFactor.set();
        add(continuePls);

        FlxG.sound.playMusic(Paths.music('freakyMenu'));
    }
 
 
    override function update(elapsed:Float) 
    {
        super.update(elapsed);

        continuePlsSine += 180 * elapsed;
		continuePls.alpha = 1 - Math.sin((Math.PI * continuePlsSine) / 180);
  
        if (controls.ACCEPT) {
            FlxG.sound.play(Paths.sound('cancelMenu'));
            MusicBeatState.switchState(new MainMenuState());
    }   }
}
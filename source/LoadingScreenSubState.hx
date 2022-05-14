package;

import flixel.math.FlxMath;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;

using StringTools;

class LoadingScreenSubState extends MusicBeatSubstate
{
    var screen:FlxSprite;
    var random:Int;

    override function create()
    {
        super.create();

        random = FlxG.random.int(1,2);
        screen = new FlxSprite().loadGraphic(Paths.image('loading/$random'));
        screen.antialiasing = ClientPrefs.globalAntialiasing;
        screen.screenCenter();
        add(screen);
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);
    }
}
package;

import flixel.util.FlxTimer;
import flixel.FlxSprite;

class Smoke extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x,y);

        frames = Paths.getSparrowAtlas('soni/Humo', 'shared');
		animation.addByPrefix('nuse', 'Todo', 24, false);
        animation.play('nuse');
        screenCenter();
        antialiasing = ClientPrefs.globalAntialiasing;
    }

    override function update(elapsed:Float)
    {
        if(animation.name == 'nuse' && animation.finished)
            kill();
        
        super.update(elapsed);
    }
}
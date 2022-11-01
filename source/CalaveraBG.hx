package;

import flixel.FlxSprite;

class CalaveraBG extends FlxSprite
{
    public function new(x:Float = 0, y:Float = 0)
    {
        super(x,y);

        frames = Paths.getSparrowAtlas('halloween/Calavera_Anim', 'shared');
        animation.addByIndices('idle', 'Calav_Anim', [27], '', 0, false);
        animation.addByPrefix('scream', 'Calav_Anim', 24, false);
        animation.play('idle');
        antialiasing = ClientPrefs.globalAntialiasing;
    }

    public function scream()
    {
        animation.play('scream', true);
    }

    override function update(elapsed:Float)
    {
        if(animation.name == 'scream' && animation.finished)
        {
            animation.play('idle', true);
        }

        super.update(elapsed);
    } 
}
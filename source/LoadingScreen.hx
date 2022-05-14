import flixel.util.FlxColor;
import flixel.ui.FlxBar;
import sys.thread.Mutex;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxState;

import openfl.utils.Assets;
import lime.utils.Assets as LimeAssets;
import lime.utils.AssetLibrary;
import lime.utils.AssetManifest;

import haxe.io.Path;

class LoadingScreen extends MusicBeatState
{
    var target:FlxState;
    var _target:MusicBeatState;
    var stopMusic:Bool = false;
    var loadMutex:Mutex;
    
    public static var mutex:Mutex;
    public static var Objects:Array<Dynamic> = [];

	var loadingSong:Bool = false;

	public function new(_target:FlxState, song:Bool = false)
	{
		target = _target;
		loadMutex = new Mutex();
		loadingSong = song;
		super();
	}

	var startLoad:Bool = false;
	override function create()
	{
		Main.dumpCache();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (!startLoad)
		{
			startLoad = true;
			sys.thread.Thread.create(() ->
			{
                loadMutex.acquire();
                trace("reset da assets");
                resetAssets();
                _target.load();
                _target.loadedCompletely = true;
                trace("we done lets gtfo " + target);
				MusicBeatState.switchState(getNextState(target, stopMusic), false, true);
				loadMutex.release();
			});
		}
		super.update(elapsed);
    }

    function onLoad()
	{
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		MusicBeatState.switchState(target);
	}
	
	static function getSongPath()
	{
		return Paths.inst(PlayState.SONG.song);
	}
	
	static function getVocalPath()
	{
		return Paths.voices(PlayState.SONG.song);
	}
    
    static function getNextState(target:FlxState, stopMusic = false):FlxState
	{
		var directory:String = 'shared';
		var weekDir:String = StageData.forceNextDirectory;
		StageData.forceNextDirectory = null;

		if(weekDir != null && weekDir.length > 0 && weekDir != '') directory = weekDir;

		Paths.setCurrentLevel(directory);
		trace('Setting asset folder to ' + directory);

        #if NO_PRELOAD_ALL
		var loaded:Bool = false;
		if (PlayState.SONG != null) {
			loaded = isSoundLoaded(getSongPath()) && (!PlayState.SONG.needsVoices || isSoundLoaded(getVocalPath())) && isLibraryLoaded("shared") && isLibraryLoaded(directory);
		}
		
		if (!loaded)
            return new LoadingScreen(target, true);
        #end
		if (stopMusic && FlxG.sound.music != null)
			FlxG.sound.music.stop();
		
		return target;
    }
    
    #if NO_PRELOAD_ALL
	static function isSoundLoaded(path:String):Bool
	{
		return Assets.cache.hasSound(path);
	}
	
	static function isLibraryLoaded(library:String):Bool
	{
		return Assets.getLibrary(library) != null;
    }
    #end

    function resetAssets()
    {
        var bg:FlxSprite;
        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('loading/${FlxG.random.int(1,2)}'));
		bg.antialiasing = ClientPrefs.globalAntialiasing;
		bg.scrollFactor.set();
        bg.updateHitbox();
		add(bg);
    }
}
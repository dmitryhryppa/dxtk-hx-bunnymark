package;
import app.GameTime;
import cpp.Float32;
import dxtk.math.Vec2f;
import app.Texture2D;
import app.Content;
import dxtk.CommonStates;
import dxtk.SpriteBatch;
import dxtk.MouseState;
import dxtk.Gamepad;
import dxtk.SpriteSortMode;
import app.IGame;
import app.Dxtk;
import imgui.Imgui;

class Main implements IGame {
    private static inline var SCENE_WIDTH:Int = 800;
    private static inline var SCENE_HEIGHT:Int = 600;
    private static var DEBUG_WINDOW_TITLE:String = "DEBUG";
    
    private var bunnies:Array<Bunny>;
    private var bunnyTex:Texture2D;

    private var gravity:Float = 0.5;
    private var fps:Int = 0;
    
    public static function main ():Void {
        var dxtk:Dxtk = new Dxtk();
        dxtk.vsyncEnabled = true;
        
        if (dxtk.init("My Game", SCENE_WIDTH, SCENE_HEIGHT, false)) {
            dxtk.run(new Main());
        }
    }

    public function new () {
        bunnies = new Array<Bunny>();
    }

    public function loadContent (content:Content):Void {
        bunnyTex = content.getTexture2D("wabbit_alpha.png");
    }

    public function onGamepadInput (gamepad:Gamepad):Void {

    }
    
    public function onMouseState (state:MouseState):Void {
        if (state.leftButton) {
            inline addBunnies(500, state.x, state.y);
        }
    }

    public function onUpdate (gameTime:GameTime):Void {
        for (i in 0...bunnies.length) {
            var bunny:Bunny = bunnies[i];
            
            bunny.x += bunny.speedX;
            bunny.y += bunny.speedY;
            bunny.speedY += gravity;

            final maxX:Int = SCENE_WIDTH - 26;
            final maxY:Int = SCENE_HEIGHT - 37;
            
            if (bunny.x > maxX) {
                bunny.speedX *= -1;
                bunny.x = maxX;
            } else if (bunny.x < 0) {
                bunny.speedX *= -1;
                bunny.x = 0;
            } if (bunny.y > maxY) {
                bunny.speedY *= -0.8;
                bunny.y = maxY;
                if (Math.random() > 0.5) bunny.speedY -= 3 + Math.random() * 4;
            }  else if (bunny.y < 0) {
                bunny.speedY = 0;
                bunny.y = 0;
            }
        }

        fps = gameTime.fps;
    }
    
    public function onDraw (spriteBatch:SpriteBatch, commonStates:CommonStates):Void {
        spriteBatch.begin(SpriteSortMode.Deferred, commonStates.nonPremultiplied());
        for (bunny in bunnies) {
            spriteBatch.draw(bunnyTex, Vec2f.make(bunny.x, bunny.y));
        }
        spriteBatch.end();
    }

    public function onDebugGUI ():Void {
        Imgui.begin(DEBUG_WINDOW_TITLE);
        Imgui.text('FPS: ${fps}');
        Imgui.text('Bunnies: ${bunnies.length}');
        Imgui.end();
    }

    private function addBunnies (count:Int, x:Int = 0, y:Int = 0):Void {
        for (i in 0...count) {
            var bunny:Bunny = {
                x: x, 
                y: y, 
                speedX: Math.random() * 5,
                speedY: Math.random() * 5 - 2.5
            };
            bunnies.push(bunny);
        }
    }
}

@:structInit
class Bunny {
    public var x:Float32;
    public var y:Float32;
    public var speedX:Float32;
    public var speedY:Float32;
}
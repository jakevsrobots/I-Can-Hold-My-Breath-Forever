package breath {
    import org.flixel.*;
    
    [SWF(width="640", height="420", backgroundColor="#000000")];

    public class Main extends FlxGame {
        public static var bgcolor:uint = 0xff303030;
        
        public function Main():void {
            super(320, 160, PlayState, 2);

            FlxState.bgColor = Main.bgcolor;
        }
    }
}
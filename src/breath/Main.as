package breath {
    import org.flixel.*;
    
    [SWF(width="640", height="320", backgroundColor="#ffffff")];

    [Frame(factoryClass="Preloader")]

    public class Main extends FlxGame {
        //public static var bgcolor:uint = 0xff303030;
        //public static var bgcolor:uint = 0xffc0c0c0;
        //public static var bgcolor:uint = 0x66161616;
        public static var bgcolor:uint = 0xaa3de7c7;
        
        public function Main():void {
            super(320, 160, PlayState, 2);
            
            FlxState.bgColor = Main.bgcolor;

        }
    }
}
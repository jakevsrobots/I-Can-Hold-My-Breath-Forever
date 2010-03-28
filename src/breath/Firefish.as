package breath {
    import org.flixel.*;

    public class Firefish extends FlxSprite {
        [Embed(source="/../data/firefish.png")]
        private var FishGraphic:Class;
        
        public function Firefish(X:uint, Y:uint):void {
            super(X, Y, FishGraphic);
        }
    }
}
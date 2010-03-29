package breath {
    import org.flixel.*;

    public class RestorePoint extends FlxSprite {
        [Embed(source="/../data/wall-note.png")]
        private var WallNoteImage:Class;

        public var note:Boolean = true;
        
        public function RestorePoint(X:uint,Y:uint):void {
            // Snap the x & y values to the grid
            /*
            X -= X % World.TILE_SIZE;
            Y -= Y % World.TILE_SIZE;
            */
            
            super(X,Y,WallNoteImage);
        }
    }
}
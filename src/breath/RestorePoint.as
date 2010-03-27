package breath {
    import org.flixel.*;

    public class RestorePoint extends FlxSprite {
        [Embed(source="/../data/lamp-post.png")]
        private var LampPostImage:Class;

        public function RestorePoint(X:uint,Y:uint):void {
            // Snap the x & y values to the grid
            X -= X % World.TILE_SIZE;
            Y -= Y % World.TILE_SIZE;
            
            super(X,Y,LampPostImage);
        }
    }
}
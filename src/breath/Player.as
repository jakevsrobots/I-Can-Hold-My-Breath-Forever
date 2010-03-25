package breath {
    import org.flixel.*;

    public class Player extends FlxSprite {
        [Embed(source='/../data/bird_player_image.png')]
        private var PlayerImage:Class;

        private var gravity_on:Boolean = true;
        private var _move_speed:int;
        
        public function Player(X:Number, Y:Number):void {
            super(X,Y);
            this.loadGraphic(PlayerImage, true, true);

            maxVelocity.x = 200;
            maxVelocity.y = 200;

            _move_speed = 700;
            drag.x = 500;

            width = 14;
        }

        override public function update():void {
            if(gravity_on) {
                acceleration.y = 420;
            } else {
                acceleration.y = 0;
            }

            if(FlxG.keys.LEFT) {
                facing = LEFT;
                velocity.x -= _move_speed * FlxG.elapsed;
            } else if(FlxG.keys.RIGHT) {
                facing = RIGHT;
                velocity.x += _move_speed * FlxG.elapsed;                
            }
            
            super.update();
        }
    }
}
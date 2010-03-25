package breath {
    import org.flixel.*;

    public class Player extends FlxSprite {
        [Embed(source='/../data/bird_player_image.png')]
        private var PlayerImage:Class;

        public var gravity_on:Boolean = true;
        public var in_water:Boolean = false;        
        private var _move_speed:int;
        
        public function Player(X:Number, Y:Number):void {
            super(X,Y);
            this.loadGraphic(PlayerImage, true, true);

            maxVelocity.x = 200;
            maxVelocity.y = 200;

            _move_speed = 700;
            drag.x = 500;

            width = 4;
            offset.x = 6;
        }

        override public function update():void {
            // Physics/movement
            if(gravity_on) {
                acceleration.y = 420;
                drag.x = 500;
                drag.y = 0;
            } else {
                acceleration.y = 0;
                drag.x = drag.y = 300;
            }

            if(FlxG.keys.LEFT) {
                facing = LEFT;
                velocity.x -= _move_speed * FlxG.elapsed;
            } else if(FlxG.keys.RIGHT) {
                facing = RIGHT;
                velocity.x += _move_speed * FlxG.elapsed;                
            }

            if(!gravity_on) {
                if(FlxG.keys.UP) {
                    velocity.y -= _move_speed * FlxG.elapsed;
                } else if(FlxG.keys.DOWN) {
                    velocity.y += _move_speed * FlxG.elapsed;                
                }
            }

            // Animation
            if(in_water) {
                alpha = 0.7;
            } else {
                alpha = 1.0;
            }
            
            super.update();
        }
    }
}
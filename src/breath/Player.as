package breath {
    import org.flixel.*;

    public class Player extends FlxSprite {
        [Embed(source='/../data/bird_player_image.png')]
        private var PlayerImage:Class;
        [Embed(source='/../data/newplayer.png')]
        private var NewPlayerImage:Class;
        [Embed(source="/../data/glow-light.png")]
        private var GlowImage:Class;

        public var gravity_on:Boolean = true;
        public var in_water:Boolean = false;
        public var push_up:Boolean = false;        
        private var _move_speed:int;

        public var glow:FlxSprite;
        public var darkness:FlxSprite;        
        
        public function Player(X:Number, Y:Number, darkness:FlxSprite):void {
            super(X,Y);

            this.darkness = darkness;
        
            glow = new FlxSprite(X,Y,GlowImage);
            glow.scale = new FlxPoint(4,4);
            glow.alpha = 1;
            glow.blend = "screen";
            
            this.loadGraphic(NewPlayerImage, true, true);

            maxVelocity.x = 140;
            maxVelocity.y = 140;

            _move_speed = 700;
            drag.x = 500;

            addAnimation("walk", [0,1,2,3], 12);
            addAnimation("stopped", [9]);
            addAnimation("jump", [2,3,4],2);
            addAnimation("mid-air",[4]);
            
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
                acceleration.y = 40;
                drag.x = drag.y = 300;
            }

            if(push_up) {
                acceleration.y = -40;
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

            if(velocity.x != 0 || velocity.y < 0) {
                play("walk");
            } else {
                play("stopped");
            }
            
            super.update();
        }

        override public function render():void {
            var firefly_point:FlxPoint = new FlxPoint;
            
            getScreenXY(firefly_point);

            darkness.draw(
                glow,
                firefly_point.x - (glow.width / 2),
                firefly_point.y - (glow.height/ 2)
            );

            super.render();
        }
        
    }
}
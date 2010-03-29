package breath {
    import org.flixel.*;

    public class Firefish extends FlxSprite {
        [Embed(source="/../data/glow-light.png")]
        private var GlowImage:Class;

        private var start_point:FlxPoint;
        private var destination:FlxPoint;
        
        private var move_speed:uint = 120;        

        public var glow:FlxSprite;
        public var darkness:FlxSprite;        

        public var player:Player;

        private var display_test_point:FlxPoint;
        
        public function Firefish(X:uint, Y:uint, darkness:FlxSprite):void {
            super(X, Y);

            start_point = new FlxPoint;
            destination = new FlxPoint;            
            
            start_point.x = X;
            start_point.y = Y;
            
            this.darkness = darkness;

            createGraphic(1,1,0xffffffff);

            glow = new FlxSprite(X,Y,GlowImage);
            glow.scale = new FlxPoint(2,2);
            glow.alpha = 1;
            glow.blend = "screen";
            
            maxVelocity.x = maxVelocity.y = 200;

            display_test_point = new FlxPoint;
            
            get_new_destination();
            
            drag.x = drag.y = 100;
        }

        override public function update():void {
            if(destination.x < this.x) {
                velocity.x -= move_speed * FlxG.elapsed;
            } else {
                velocity.x += move_speed * FlxG.elapsed;
            }

            if(destination.y < this.y) {
                velocity.y -= move_speed * FlxG.elapsed;
            } else {
                velocity.y += move_speed * FlxG.elapsed;
            }

            if(Math.abs(destination.y - this.y) < 4 &&
                Math.abs(destination.x - this.x) < 4) {
                
                get_new_destination();
            }

            super.update();
        }

        override public function render():void {
            getScreenXY(display_test_point);

            if(display_test_point.x > FlxG.width * 2 ||
                display_test_point.x < -FlxG.width ||
                display_test_point.y > FlxG.height * 2 ||
                display_test_point.y < -FlxG.height) {
                return;
           }
           
           var firefly_point:FlxPoint = new FlxPoint;
            
            getScreenXY(firefly_point);

            darkness.draw(
                glow,
                firefly_point.x - (glow.width / 2),
                firefly_point.y - (glow.height/ 2)
            );

            super.render();
        }

        override public function kill():void {
            glow.kill();
            super.kill();
        }

        public function get_new_destination():void {
            destination = new FlxPoint(
                start_point.x + (uint(Math.random() * 100) - 50),
                start_point.y + (uint(Math.random() * 100) - 50)
            );

            move_speed = 140 + (Math.random() * 20);
        }


        override public function hitLeft(Contact:FlxObject, Velocity:Number):void {
            get_new_destination();
            super.hitLeft(Contact,Velocity);            
        }
        
        override public function hitTop(Contact:FlxObject, Velocity:Number):void {
            get_new_destination();
            super.hitTop(Contact,Velocity);
        }
        override public function hitBottom(Contact:FlxObject, Velocity:Number):void {
            get_new_destination();
            super.hitBottom(Contact,Velocity);
        }
        
    }
}
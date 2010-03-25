package breath {
    import org.flixel.*;

    public class PlayState extends FlxState {
        [Embed(source="/../data/autotiles.png")]
        private var AutoTiles:Class;

        private var world:World;
        private var player:Player;

        private var restore_point_id:String = '0';

        private var oxygen_timer:Number = 10.0;
        private var oxygen_timer_display:FlxText;
        private var darkness:FlxSprite;
        
        override public function create():void {
            world = new World();

            this.add(world.walls_map);
            this.add(world.water_map);
            
            player = new Player(4 * World.TILE_SIZE, 9 * World.TILE_SIZE);
            
            this.add(player);

            darkness = new FlxSprite(0, 0);
            darkness.createGraphic(FlxG.width, FlxG.height, 0xff000000);
            darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
            darkness.alpha = 0.0;

            this.add(darkness);
            
            oxygen_timer_display = new FlxText(0, 20, FlxG.width, '10');
            oxygen_timer_display.setFormat(null, 76, 0xffffff, 'center');
            oxygen_timer_display.alpha = 0.0;
            oxygen_timer_display.scrollFactor.x = oxygen_timer_display.scrollFactor.y = 0;
            
            this.add(oxygen_timer_display);
            
            world.walls_map.follow();
            FlxG.followAdjust(0.5, 0.5);
            FlxG.follow(player, 2.5);
        }

        override public function update():void {
            world.walls_map.collide(player);

            if(world.water_map.overlaps(player)) {
                player.in_water = true;
            } else {
                player.in_water = false;
            }

            if(world.safezone_map.overlaps(player) || world.water_map.overlaps(player)) {
                player.gravity_on = false;
            } else {
                player.gravity_on = true;
            }

            // Nudge the player up if they're in the safe zone.
            if(world.safezone_map.overlaps(player)) {
                player.push_up = true;
            } else {
                player.push_up = false;                
            }

            // Check air bubble entrances
            for(var bubble_id:String in world.airbubble_entrances) {
                var air_bubble_entrance:FlxObject = world.airbubble_entrances[bubble_id];
                    if(air_bubble_entrance.overlaps(player)) {
                        restore_point_id = bubble_id;
                    }
            }

            // Check oxygen level & update label
            if(player.in_water) {
                oxygen_timer_display.text = String(uint(Math.ceil(oxygen_timer)));
                oxygen_timer_display.alpha = 1.0 - (oxygen_timer / 10.0);
                
                /*
                if(oxygen_timer_display.alpha < 0.1) {
                    oxygen_timer_display.alpha = 0.1;
                    }*/
                
                darkness.alpha = Math.pow(1.0 - (oxygen_timer / 10.0), 2);
                
                oxygen_timer -= FlxG.elapsed;

                if(oxygen_timer < 0.0) {
                    oxygen_timer = 0.0;
                }
            } else {
                oxygen_timer = 10.0;
            }

            FlxG.log('oxygen timer: ' + oxygen_timer);
            
            
            super.update();
        }
    }
}
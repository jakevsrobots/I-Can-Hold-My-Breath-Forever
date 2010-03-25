package breath {
    import org.flixel.*;

    public class PlayState extends FlxState {
        [Embed(source="/../data/autotiles.png")]
        private var AutoTiles:Class;

        private var world:World;
        private var player:Player;

        public var restore_point_id:String = '0';
        
        override public function create():void {
            world = new World();
            
            this.add(world.walls_map);
            this.add(world.water_map);
            
            player = new Player(4 * World.TILE_SIZE, 9 * World.TILE_SIZE);
            
            this.add(player);

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
            
            super.update();
        }
    }
}
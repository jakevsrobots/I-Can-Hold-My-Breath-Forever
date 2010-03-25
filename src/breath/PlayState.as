package breath {
    import org.flixel.*;

    public class PlayState extends FlxState {
        [Embed(source="/../data/autotiles.png")]
        private var AutoTiles:Class;

        private var world:World;
        private var player:Player;

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
                player.gravity_on = false;
            } else {
                player.gravity_on = true;
            }
            
            super.update();
        }
    }
}
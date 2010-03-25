package breath {
    import org.flixel.*;

    public class PlayState extends FlxState {
        [Embed(source="/../data/autotiles.png")]
        private var AutoTiles:Class;
        [Embed(source="/../data/walls_map.png")]
        private var WallsMap:Class;
        
        private var walls_map:FlxTilemap;
        private var walls_group:FlxGroup;

        private var player:Player;

        public static var TILE_SIZE:int = 8;
        
        override public function create():void {
            walls_group = new FlxGroup;
            this.add(walls_group);
            
            walls_map = new FlxTilemap;
            walls_map.auto = FlxTilemap.AUTO;
            walls_map.loadMap(FlxTilemap.pngToCSV(WallsMap), AutoTiles, 8, 8);

            walls_group.add(walls_map);

            player = new Player(94 * TILE_SIZE, 30 * TILE_SIZE);
            
            this.add(player);

            walls_map.follow();
            FlxG.followAdjust(0.5, 0.5);
            FlxG.follow(player, 2.5);
        }

        override public function update():void {
            walls_map.collide(player);
            
            super.update();
        }
    }
}
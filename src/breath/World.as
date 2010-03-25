package breath {
    import org.flixel.*;

    import com.adobe.serialization.json.JSON;

    public class World {
        [Embed(source='/../data/world.json', mimeType="application/octet-stream")]
        public var MapJSON:Class;
        [Embed(source="/../data/autotiles.png")]
        private var AutoTiles:Class;

        public static var TILE_SIZE:int = 8;
        public var walls_map;
        public var width:uint;
        public var height:uint;        
        
        public function World():void {
            walls_map = new FlxTilemap;
            walls_map.startingIndex = 0;
            walls_map.collideIndex = 1;
            walls_map.auto = FlxTilemap.AUTO;

            var map:Object = JSON.decode(new MapJSON);

            width = parseInt(map.width);
            height = parseInt(map.height);

            for each(var layer:Object in map.layers) {
                if(layer.name == 'walls') {
                    walls_map.loadMap(layer.tiles, AutoTiles, TILE_SIZE, TILE_SIZE);
                }
            }
        }
    }
}
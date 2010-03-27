package breath {
    import org.flixel.*;

    import flash.utils.Dictionary;
    
    import com.adobe.serialization.json.JSON;

    public class World {
        [Embed(source='/../data/world.json', mimeType="application/octet-stream")]
        public var MapJSON:Class;
        [Embed(source="/../data/autotiles.png")]
        private var AutoTiles:Class;
        [Embed(source="/../data/water-autotiles.png")]
        private var WaterAutoTiles:Class;
        
        public static var TILE_SIZE:int = 8;
        public var walls_map:FlxTilemap;
        public var water_map:FlxTilemap;
        public var safezone_map:FlxTilemap;        
        public var width:uint;
        public var height:uint;        

        public var airbubble_entrances:Dictionary;
        public var airbubble_restore_points:Dictionary;
        
        public var stories:Dictionary;
        
        public function World():void {
            walls_map = new FlxTilemap;
            walls_map.startingIndex = 0;
            walls_map.collideIndex = 1;
            walls_map.auto = FlxTilemap.AUTO;

            // Water map works just like walls map, but never actually
            // collide against it; just detect overlaps on it to set
            // a 'swimming' variable or the like.
            water_map = new FlxTilemap;
            water_map.startingIndex = 0;
            water_map.collideIndex = 1;
            water_map.auto = FlxTilemap.AUTO;

            // In the safe zone, character has no gravity but cannot drown.
            safezone_map = new FlxTilemap;
            safezone_map.startingIndex = 0;
            safezone_map.collideIndex = 1;
            safezone_map.auto = FlxTilemap.AUTO;

            airbubble_entrances = new Dictionary;
            airbubble_restore_points = new Dictionary;
            
            var map:Object = JSON.decode(new MapJSON);

            width = parseInt(map.width);
            height = parseInt(map.height);

            // Tile layers
            
            for each(var layer:Object in map.layers) {
                if(layer.name == 'walls') {
                    walls_map.loadMap(layer.tiles, AutoTiles, TILE_SIZE, TILE_SIZE);
                } else if(layer.name == 'water') {
                    water_map.loadMap(layer.tiles, WaterAutoTiles, TILE_SIZE, TILE_SIZE);
                } else if(layer.name == 'safezone') {
                    safezone_map.loadMap(layer.tiles, AutoTiles, TILE_SIZE, TILE_SIZE);
                }
            }

            // Object groups
            for each(var objectgroup:Object in map.objectgroups) {
                    if(objectgroup.name == 'airbubbles') {
                        for each(var obj:Object in objectgroup.objects) {
                                var bubble_id:String = obj.name.split('-')[1];

                                if(obj.type == 'restore') {
                                    airbubble_restore_points[bubble_id] = new RestorePoint(obj.x, obj.y);
                                } else if(obj.type == 'enter') {
                                    // Just use a generic FlxObject here since all we're doing with
                                    // entrances is checking overlaps.
                                    airbubble_entrances[bubble_id] = new FlxObject(obj.x, obj.y, obj.width, obj.height);
                                }
                            }
                    }
            }

            // Stories
            stories = new Dictionary;
            //stories['0'] = 'Text test';
            stories['0'] = 'There were two friends. One said "I Can Hold My Breath Forever," and dove into the water.';            
            stories['1'] = 'There were two friends. One said "I Can Hold My Breath Forever," and dove into the water.';
        }
    }
}
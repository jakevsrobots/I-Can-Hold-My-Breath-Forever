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

        public var firefish_group:FlxGroup;
        
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
                    } else if(objectgroup.name == 'firefish') {
                        firefish_group = new FlxGroup;

                        trace('fish group');
                        
                        for each(var fish_obj:Object in objectgroup.objects) {
                            trace('fish', fish_obj.x, fish_obj.y);
                            firefish_group.add(
                                new Firefish(
                                    fish_obj.x - (fish_obj.x % World.TILE_SIZE),
                                    fish_obj.y - (fish_obj.y % World.TILE_SIZE)
                                )
                            );
                        }
                    }
            }

            // Stories
            stories = new Dictionary;

            stories['1'] = "My dear friend,\nI cannot know how long you waited before following me, but I longingly look forward to meeting you in these underwater caves.";
            stories['2'] = "My dear friend,\nWhen I dove into that small pond, I knew it may take you some time to come along.";
            stories['3'] = "My dear friend,\nThis tunnel seems to be a dead end; I will backtrack a bit and then dive deeper downward. How deep and dark this cave must be!";
            stories['4'] = "My dear friend,\nDo you remember the small green fish we used to catch in this pond? They must prefer the shallow water, I don't see them at this depth.";
            stories['5'] = "My dear friend,\nIt's been hours now, my friend. I wonder if you're just behind me; I know moving through these caves must be a bit slower with your limitations...";
            stories['6'] = "My dear friend,\nOut of the corner of my eye I saw something move back here and thought it might be you, my friend; maybe you had somehow outperformed me in navigating this darkness! But it was just one of those glowing fish.";
            stories['7'] = "My dear friend,\nIt's so dark here. You never could see well in the dark. That, and you never could hold your breath for long. At most, what, nine seconds? Ten?";
            stories['8'] = "My dear friend,\nI stopped here, and waited for you. I wonder: now that you're reading this, you must be quite deep in these caves. I've been here for months... Does it feel like home to you?";
            stories['9'] = "My dear friend,\nWhat an enormous, beautiful cavern! I wish I could wait here longer, but I must press on. How are you stomaching the pressure? Sometimes I shout questions and pretend the echoes are your answers.";
            stories['10'] = "My dear friend,\nI'm sure you've noticed the strange behavior of the water down here. At this depth, water and air interact like two mortal enemies, repelling one another into the strangest configurations.";
            stories['11'] = "My dear friend,\n ";
            
            // old stories
            /*
            stories['0'] = 'There were two friends. One said "I Can Hold My Breath Forever," and dove into a small pond.';
            stories['1'] = 'After a while, the other friend followed.';
            stories['2'] = 'The small pond concealed a network of underwater tunnels and caves.';
            stories['3'] = 'Many of the caves and tunnels seemed to be carved out of the rock deliberately.';
            stories['4'] = 'It was so oppressively dark and close in the underwater tunnels; each cave was like an oasis despite the cold, stale air.';
            stories['5'] = "One could have easily lost one's way in these dark tunnels and never be heard of again.";
            stories['6'] = 'Who would carve tunnels so confusing and mazelike, and why?';
            stories['7'] = 'Was it really all natural?';
            stories['8'] = "Water shouldn't have behaved this way...";
            stories['9'] = 'It was a large, beautiful cavern. Surely if one were to come across this cavern they would stop and wait for their friend to share the experience...';
            stories['10'] = 'Surely it was water and not ice; but it hung in a block, solid to the eye but fluid to the touch.';
            stories['11'] = 'So deep. What could be at the bottom?';
            stories['12'] = 'The small glowing fish were welcome companions.';
            stories['13'] = 'Here deep in the cave nothing behaved as it should.';
            */
        }
    }
}
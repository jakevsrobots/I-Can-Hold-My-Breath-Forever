package breath {
    import org.flixel.*;

    public class PlayState extends FlxState {
        [Embed(source="/../data/autotiles.png")]
        private var AutoTiles:Class;
        [Embed(source="/../data/world-background.png")]
        private var BackgroundImage:Class;

        private var world:World;
        private var player:Player;

        private var saved_restore_point:String = '0';

        private var oxygen_timer:Number = 10.0;
        private var oxygen_timer_display:FlxText;
        private var darkness:FlxSprite;

        private var darkness_color:uint = 0xee000000;
        public static var world_darkness:FlxSprite;
        
        private var player_dead:Boolean = false;
        private var player_death_length:Number = 1.0;
        private var player_death_timer:Number = 0.0;

        private var story_overlay:StoryOverlay;
        private var notes:FlxGroup;

        private var background:FlxSprite;
        
        override public function create():void {
            PlayState.world_darkness = new FlxSprite(0,0);
            world_darkness.createGraphic(FlxG.width, FlxG.height, darkness_color);
            world_darkness.scrollFactor.x = world_darkness.scrollFactor.y = 0;
            world_darkness.blend = "multiply";
            
            world = new World();

            background = new FlxSprite(0,0,BackgroundImage);
            this.add(background);

            // Add restore point sprites
            notes = new FlxGroup;
            for each(var note:RestorePoint in world.airbubble_restore_points) {
                if(note.note) {
                    notes.add(note);
                }
            }
            
            player = new Player(4 * World.TILE_SIZE, 9 * World.TILE_SIZE, world_darkness);
            
            darkness = new FlxSprite(0, 0);
            darkness.createGraphic(FlxG.width, FlxG.height, 0xff000000);
            darkness.scrollFactor.x = darkness.scrollFactor.y = 0;
            darkness.alpha = 0.0;
            
            oxygen_timer_display = new FlxText(0, 0, FlxG.width, '10');
            oxygen_timer_display.setFormat(null, 160, 0xffffff, 'center');
            oxygen_timer_display.alpha = 0.0;
            oxygen_timer_display.scrollFactor.x = oxygen_timer_display.scrollFactor.y = 0;
            
            story_overlay = new StoryOverlay(16, 2);
            
            world.walls_map.follow();
            FlxG.followAdjust(0.5, 0.5);
            FlxG.follow(player, 2.5);

            //this.add(world.walls_map);
            //this.add(world.water_map);
            this.add(world.firefish_group);
            
            this.add(notes);
            this.add(player);
            this.add(world_darkness);
            this.add(darkness);
            this.add(oxygen_timer_display);
            this.add(story_overlay);
        }

        // For testing, skip ahead to the next restore point.
        public function skip_ahead():void {
            var next_point:String = String(parseInt(saved_restore_point) + 1);

            if(!world.airbubble_restore_points.hasOwnProperty(next_point)) {
                next_point = '0';
            }
            
            var restore_point:FlxPoint = world.airbubble_restore_points[next_point];
            saved_restore_point = next_point;
                
            player.x = restore_point.x;
            player.y = restore_point.y;

        }
        
        override public function update():void {
            if(FlxG.keys.justPressed('N')) {
                skip_ahead();
                super.update();
                return;
            }
            
            if(player_dead) {
                player_death_timer -= FlxG.elapsed;
                
                if(player_death_timer <= 0.0) {
                    player_dead = false;
                }

                // Halt the player so they can't hold an arrow button
                // down & end up outside a wall
                player.velocity.x = player.velocity.y = 0;
                
                super.update();
                return;
            }
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
                        if(bubble_id != saved_restore_point) {
                            FlxG.log('updating restore point ' + bubble_id);
                            saved_restore_point = bubble_id;
                        }
                    }
            }

            // Check story points
            for(var restore_point_id:String in world.airbubble_restore_points) {
                var restore_point:RestorePoint = world.airbubble_restore_points[restore_point_id];
                
                if(player.overlaps(restore_point)) {
                    if(world.stories.hasOwnProperty(restore_point_id)) {
                        story_overlay.showText(world.stories[restore_point_id]);
                    }
                }
            }
            
            // Check oxygen level & update label
            if(player.in_water) {
                oxygen_timer_display.text = String(uint(Math.ceil(oxygen_timer)));
                oxygen_timer_display.alpha = 1.0 - (oxygen_timer / 10.0);
                
                darkness.alpha = Math.pow(1.0 - (oxygen_timer / 10.0), 2);

                var max_overlay_alpha:Number = 0.9;
                
                if(darkness.alpha > max_overlay_alpha) {
                    darkness.alpha = max_overlay_alpha;
                }

                if(oxygen_timer_display.alpha > max_overlay_alpha) {
                    oxygen_timer_display.alpha = max_overlay_alpha;
                }
                
                oxygen_timer -= FlxG.elapsed;

                if(oxygen_timer < 0.0) {
                    oxygen_timer = 0.0;
                    kill_player();
                }

                world_darkness.alpha = 1;
            } else {
                oxygen_timer = 10.0;
                darkness.alpha = 0;
                oxygen_timer_display.alpha = 0;

                world_darkness.alpha = 0;
            }

            //FlxG.log('oxygen timer: ' + oxygen_timer);
            super.update();
        }

        override public function render():void {
            world_darkness.fill(darkness_color);
            super.render();
        }
        
        private function kill_player():void {
            // The player has drowned; move them back to the last restore point
            var restore_point:FlxPoint = world.airbubble_restore_points[saved_restore_point];
            FlxG.log('moving to ' + saved_restore_point + ' at ' + restore_point.x + ',' + restore_point.y);
            
            player.x = restore_point.x;
            player.y = restore_point.y;
            player.velocity.x = player.velocity.y = 0;
            
            // Re-set the 'death' timer which holds the blackout & countdown
            // for a couple seconds.
            player_dead = true;
            player_death_timer = player_death_length;

            // Complete blackout
            oxygen_timer_display.text = '0';
            darkness.alpha = 1.0;
            oxygen_timer_display.alpha = 1.0;
        }
    }
}
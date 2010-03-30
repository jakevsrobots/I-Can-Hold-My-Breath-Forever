package breath {
    import org.flixel.*;

    public class StoryOverlay extends FlxGroup {
        [Embed(source='/../data/gardenia.ttf', fontFamily='gardenia')]
        private var GardeniaFont:String;
        
        private var text:MyText;

        // The number of seconds to hold the text before it starts to fade.
        private var text_lifespan:Number = 2.0;
        private var fade_timer:Number;
        
        public function StoryOverlay(x:int=0, y:int=0):void {
            super();

            this.x = x;
            this.y = y;

            this.scrollFactor.x = this.scrollFactor.y = 0;
            
            text = new MyText(4, 4, 290, ' ');
            text.setFormatExtended("gardenia", 8, 0xffffffff, null, 0, -5);
            add(text, true);

            text.alpha = 0;
        }

        public function showText(new_text:String):void {
            fade_timer = text_lifespan;
            text.text = new_text;
            text.alpha = 1.0;
        }

        override public function update():void {
            super.update();

            if(fade_timer > 0) {
                fade_timer -= FlxG.elapsed;
            } else {
                text.alpha -= FlxG.elapsed;
            }

            if(text.alpha < 0) {
                text.alpha = 0;
            }
        }
    }
}
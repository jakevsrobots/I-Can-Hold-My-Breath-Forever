package breath {
    import org.flixel.*;

    public class StoryOverlay extends FlxGroup {
        [Embed(source='/../data/text-box-bg.png')]
        private var BackgroundImage:Class;

        private var background:FlxSprite;
        private var text:FlxText;

        public function StoryOverlay(x:int=0, y:int=0):void {
            super();

            this.x = x;
            this.y = y;

            this.scrollFactor.x = this.scrollFactor.y = 0;
            
            background = new FlxSprite(0, 0, BackgroundImage);
            add(background, true);
            
            text = new FlxText(4, 4, 126, '');
            add(text, true);

            hide();
        }

        public function showText(new_text:String):void {
            text.text = new_text;
            background.alpha = 1.0;
            text.alpha = 1.0;
        }

        public function hide():void {
            background.alpha = 0.0;
            text.alpha = 0.0;            
        }
    }
}
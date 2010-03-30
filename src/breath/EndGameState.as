package breath {
    import org.flixel.*;

    public class EndGameState extends FlxState {
        [Embed(source='/../data/gardenia.ttf', fontFamily='gardenia')]
        private var GardeniaFont:String;
        
        private var text:MyText;

        private var bg:FlxSprite;
        
        override public function create():void {
            bg = new FlxSprite(0,0);
            bg.createGraphic(FlxG.width, FlxG.height, 0xffffffff);
            
            text = new MyText(0, (FlxG.height / 2) - 32, FlxG.width, 'jake elliott\n2010');
            text.setFormatExtended("gardenia", 16, 0xff000000, 'center', 0, -5);

            this.add(bg);
            this.add(text);
            
            FlxG.flash.start(0xff000000, 5);
        }
    }
}
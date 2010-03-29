package breath {
    import org.flixel.*;
	import flash.text.TextFormat;
    
    public class MyText extends FlxText {

		override public function MyText(X:Number, Y:Number, Width:uint, Text:String=null) {
            super(X,Y,Width,Text);
        }
        
		public function setFormatExtended(Font:String=null,Size:Number=8,Color:uint=0xffffff,Alignment:String=null,ShadowColor:uint=0, leading:int=0):FlxText {
			if(Font == null)
				Font = "";
			var tf:TextFormat = dtfCopy();
			tf.font = Font;
			tf.size = Size;
			tf.color = Color;
			tf.align = Alignment;
            tf.leading = leading;
			_tf.defaultTextFormat = tf;
			_tf.setTextFormat(tf);
			_shadow = ShadowColor;
			_regen = true;
			calcFrame();
			return this;
		}
    }
}
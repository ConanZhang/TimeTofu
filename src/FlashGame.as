/**
 * Main Class to Initiate World
 */
package
{
		import FlashGame.DebugScreen;
		import FlashGame.TestWorld;
		
		import flash.display.MovieClip;
		import flash.display.Sprite;
		import flash.events.KeyboardEvent;
		import flash.events.MouseEvent;
		import flash.text.Font;
		import flash.ui.Mouse;
	
	/**SWF Options*/
	[SWF(backgroundColor="#C4A57C", width="700", height="525", frameRate="30")]

	public class FlashGame extends Sprite
	{
		//embed font
		[Embed(source="assets/Zenzai_Itacha.ttf", fontName="Zenzai Itacha", embedAsCFF="false")]
		private var Zenzai_Itacha:Class;
		
		/**Class Member Variables*/
		private var test:TestWorld;  
		private var debug:DebugScreen;
		
		/**Constructor*/
		public function FlashGame()
		{
			//register font to global list
			Font.registerFont(Zenzai_Itacha);
			
			//hide cursor
			Mouse.hide();
			
			//create new test world
			test = new TestWorld(this);
			test.stage.addEventListener(KeyboardEvent.KEY_DOWN, test.keyPressed, false, 0, true);
			test.stage.addEventListener(KeyboardEvent.KEY_UP, test.keyReleased, false, 0, true);
			test.stage.addEventListener(MouseEvent.MOUSE_DOWN, test.leftClick);
			
			//display debug information
//			debug = new DebugScreen(this);
		}
	}
}
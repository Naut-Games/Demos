/**
 * The MIT License (MIT)
 * 
 * Copyright (c) 2004 Spencer Evans, NAUT
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 * 
 * @version     1.0
 * @copyright   Copyright © 2014 Spencer Evans, NAUT
 * @author		Spencer Evans	spencer@nautgames.com
 * @license     http://opensource.org/licenses/MIT
 * @website     http://nautgames.com
 */
package com.naut 
{
	//{ Import
	import com.naut.math.Random;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	//}
	
	/**
	 * This is a basic test of the Random class. This test randomly generates
	 * x and y coordinates and plots them on the screen as shape pixels.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class RandomPixelTest extends Sprite
	{
		
		//{ Display
		public var messageText:TextField = new TextField();
		//}
		
		
		//{ Members
		/** The random number generator we will use. */
		public var rng:Random;
		
		public var isStarted:Boolean = false;
		//}
		
		
		//{ Initialization
		public function RandomPixelTest() 
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 400, 400);
			graphics.endFill();
			
			messageText = new TextField();
			messageText.selectable = false;
			var tf:TextFormat = new TextFormat("Arial", 16, 0xFFFFFF, false, false, false, null, null);
			messageText.setTextFormat(tf);
			messageText.defaultTextFormat = tf;
			messageText.width = 400;
			messageText.height = 400;
			messageText.x = 15;
			messageText.y = 15;
			addChild(messageText);
			messageText.text = "Random class Test\n" +
				"   Press a number 0-9 to choose a random\n" + 
				"	pixel generation seed.\n\n" + 
				"	Press any number again to restart the\n" + 
				"	generation or change seeds.\n\n" + 
				"	Choosing the same seed again will re-plot\n" + 
				"	the same set of pixels";
			
			stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUp);
		}
		//}
		
		
		//{ Event Handlers
		private final function stage_keyUp(event:KeyboardEvent):void
		{
			// find out which key was pressed and choose that seed
			var seed:int = -1;
			if (event.keyCode == Keyboard.NUMBER_0 || event.keyCode == Keyboard.NUMPAD_0) seed = 0;
			else if (event.keyCode == Keyboard.NUMBER_1 || event.keyCode == Keyboard.NUMPAD_1) seed = 1;
			else if (event.keyCode == Keyboard.NUMBER_2 || event.keyCode == Keyboard.NUMPAD_2) seed = 2;
			else if (event.keyCode == Keyboard.NUMBER_3 || event.keyCode == Keyboard.NUMPAD_3) seed = 3;
			else if (event.keyCode == Keyboard.NUMBER_4 || event.keyCode == Keyboard.NUMPAD_4) seed = 4;
			else if (event.keyCode == Keyboard.NUMBER_5 || event.keyCode == Keyboard.NUMPAD_5) seed = 5;
			else if (event.keyCode == Keyboard.NUMBER_6 || event.keyCode == Keyboard.NUMPAD_6) seed = 6;
			else if (event.keyCode == Keyboard.NUMBER_7 || event.keyCode == Keyboard.NUMPAD_7) seed = 7;
			else if (event.keyCode == Keyboard.NUMBER_8 || event.keyCode == Keyboard.NUMPAD_8) seed = 8;
			else if (event.keyCode == Keyboard.NUMBER_9 || event.keyCode == Keyboard.NUMPAD_9) seed = 9;
			
			// If it was a valid key, start the test
			if (seed != -1)
			{
				rng = new Random(seed);
				
				if (!isStarted)
				{
					isStarted = true;
					
					removeChild(messageText);
					messageText = null;
					test();
				}
				else
				{
					// Reset the graphical state
					graphics.clear();
					graphics.beginFill(0x000000);
					graphics.drawRect(0, 0, 400, 400);
					graphics.endFill();
				}
			}
		}
		
		private final function stage_enterFrame(event:Event):void
		{
			plotRandomPixel();
		}
		//}
		
		
		//{ Test
		private final function test():void
		{
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
		}
		
		private final function plotRandomPixel():void
		{
			var color:uint = rng.nextIntUnder(0xFFFFFF + 1);
			
			var iterations:int = rng.nextIntIn(1, 10);
			
			for (var i:int = 0; i < iterations; ++i)
			{
				var x:int = rng.nextIntUnder(400);
				var y:int = rng.nextIntUnder(400);
				
				var size:int = rng.nextIntIn(1, 5);
				
				graphics.beginFill(color);
				graphics.drawRect(x, y, size, size);
				graphics.endFill();
			}
		}
		//}
	}

}
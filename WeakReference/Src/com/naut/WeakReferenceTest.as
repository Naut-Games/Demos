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
	import com.naut.utils.WeakReference;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	//}
	
	/**
	 * This is a basic test of the WeakReference class. This test creates roughly 20MB of 
	 * random data in a byte array. The byte array is strongly referenced and weakly referenced. 
	 * Clicking on the screen will remove the strong reference. After some time, the object is
	 * eventually collected by the garbage collector.
	 * 
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class WeakReferenceTest extends Sprite
	{
		
		//{ Display
		public var messageText:TextField = new TextField();
		//}
		
		
		//{ Members
		/** The strong reference to the byte array. */
		private var _strongReference:ByteArray;
		
		/** The weak reference to the byte array. */
		private var _weakReference:WeakReference = new WeakReference();
		
		/** The string of instructions that should be displayed. */
		private var _instructions:String = "";
		//}
		
		
		//{ Initialization
		public function WeakReferenceTest() 
		{
			// Set up the UI, black background with white text
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 400, 400);
			graphics.endFill();
			
			messageText = new TextField();
			messageText.selectable = false;
			var tf:TextFormat = new TextFormat("Arial", 12, 0xFFFFFF, false, false, false, null, null);
			messageText.setTextFormat(tf);
			messageText.defaultTextFormat = tf;
			messageText.width = 400;
			messageText.height = 400;
			messageText.x = 15;
			messageText.y = 15;
			addChild(messageText);
			
			// Update the text every frame
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
			
			// Begin the first step
			_instructions = "Click anywhere to create 20MB of data.";
			updateText();
			stage.addEventListener(MouseEvent.CLICK, stage_click_create);
		}
		//}
		
		
		//{ Text
		private final function updateText():void
		{
			messageText.text = 
				"The strong reference points to " + 
					String(_strongReference != null ? 
					"a ByteArray of size: " + (_strongReference.length / 1024 / 1024) + "MB" 
					: _strongReference)
				+ "\n" + "The weak reference points to " +
					String(_weakReference.object != null ? 
					"a ByteArray of size: " + (_weakReference.object.length / 1024 / 1024) + "MB" 
					: _weakReference.object)
				+ "\n"
				+ "\n" + "Current memory usage: " + Number(System.totalMemoryNumber / 1024 / 1024).toFixed(1)
				+ "\n"
				+ "\n" + _instructions;
		}
		//}
		
		
		//{ Event Handlers
		private final function stage_click_create(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, stage_click_create);
			
			// Create the 20MB data
			var byteArray:ByteArray = new ByteArray();
			byteArray.length = 20 * 1024 * 1024;
			
			// Create the strong and weak references
			_strongReference = byteArray;
			_weakReference.object = byteArray;
			
			// Move on to the next step
			_instructions = "20MB of data created.\n\nClick anywhere to nullify the strong reference.";
			updateText();
			stage.addEventListener(MouseEvent.CLICK, stage_click_nullify);
		}
		
		private final function stage_click_nullify(event:MouseEvent):void
		{
			_strongReference = null;
			
			_instructions = "Strong reference was set to null.\n"
				+ "Weak refernce should also drop to null.\n"
				+ "Memory should return to normal.\n\n"
				+ "Click anywhere to try it again.";
			updateText();
			stage.addEventListener(MouseEvent.CLICK, stage_click_create);
		}
		
		private final function stage_enterFrame(event:Event):void
		{
			updateText();
		}
		//}
		
	}

}
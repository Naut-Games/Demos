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
	import com.naut.ai.NeuralNet;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	//}
	
	/**
	 * This is a basic test of the NeuralNet class. This tests creates and trains
	 * a neural net to behave as an exlusive or (XOR) logical function. The standard
	 * behavior of XOR is:
	 * 		INPUT 1 | INPUT 2 | OUTPUT
	 * -----------------------------------------
	 *        0     |    0    |   0
	 *        0     |    1    |   1
	 *        1     |    0    |   1
	 *        1     |    1    |   0
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class NeuralNetXORTest extends Sprite
	{
		
		//{ Display
		public var messageText:TextField = new TextField();
		//}
		
		
		//{ Initialization
		public function NeuralNetXORTest() 
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
			messageText.text = "XOR Neural Network Test\n" +
				"   Click anywhere to test.";
			
			stage.addEventListener(MouseEvent.CLICK, stage_click);
		}
		//}
		
		
		//{ Event Handlers
		private final function stage_click(event:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.CLICK, stage_click);
			test();
		}
		//}
		
		
		//{ Test
		private final function test():void
		{
			// Initialize the neural network to take the two boolean inputs and give one boolean output
			var net:NeuralNet = net = new NeuralNet();
			net.initialize(2, 2, 1);
			
			// Set up the training values to train the net.
			// Do not use values of 0 or 1 to train with since those are outside
			// of the normalized (sigmoid function) neuron signal range function range
			// which is (0,1) exclusive.
			var low:Number = 0.1;	// false
			var high:Number = 0.9;	// true
			var inputSets:Vector.<Vector.<Number>> = Vector.<Vector.<Number>>([
				Vector.<Number>([low, low]),
				Vector.<Number>([high, low]),
				Vector.<Number>([low, high]),
				Vector.<Number>([high, high])]);
			var outputSets:Vector.<Vector.<Number>> = Vector.<Vector.<Number>>([
				Vector.<Number>([low]),
				Vector.<Number>([high]),
				Vector.<Number>([high]),
				Vector.<Number>([low])]);
			
			// The NeuralNet uses purely numbers between 0 and 1. In order to 
			// work as a boolean operator we define FALSE as < 0.5 and TRUE as > 0.5
			// We train the network until it gives us the desired output
			var trainings:Number = 0;	// keep track of how many times we train
			while (true)
			{
				// Train the network using the training set
				net.train(inputSets, outputSets);
				trainings++;
				
				// Test the network for each of the desired values
				// Here we use 0 as false and 1 as true
				var testOutput00:Number = net.evaluate(Vector.<Number>([0, 0]))[0];
				var testOutput01:Number = net.evaluate(Vector.<Number>([0, 1]))[0];
				var testOutput10:Number = net.evaluate(Vector.<Number>([1, 0]))[0];
				var testOutput11:Number = net.evaluate(Vector.<Number>([1, 1]))[0];
				
				// Break out if we've reached the desired evaluation output.
				// Assume that <0.5==0==false, and that >0.5==1==true
				if (testOutput00 < 0.5 && testOutput01 > 0.5 && testOutput10 > 0.5 && testOutput11 < 0.5)
				{
					break;
				}
			}
			
			// Our network is now working as an XOR function
			messageText.text = "Training complete!\n" + 
				"The network was trained " + trainings + " times.\n\n" + 
				"Test results:\n" +
				"XOR(0,0) = " + testOutput00 + "   < 0.5\n" + 
				"XOR(0,1) = " + testOutput01 + "   > 0.5\n" + 
				"XOR(1,0) = " + testOutput10 + "   > 0.5\n" + 
				"XOR(1,1) = " + testOutput11 + "   < 0.5";
		}
		//}
		
	}

}
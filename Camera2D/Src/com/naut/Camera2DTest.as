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
	import com.naut.scene2D.Camera2D;
	import com.naut.scene2D.TestScene2D;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.Keyboard;
	//}
	
	/**
	 * A simple test of manipulating the transformation of a "scene" display object via
	 * a 2D camera class. This test displays a scene and then controls the camera view user
	 * input.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class Camera2DTest extends Sprite
	{
		
		//{ Display
		/** A text field to display some help text. */
		public var messageText:TextField = new TextField();
		//}
		
		
		//{ Members
		/** A scene to view using the camera. */
		public var scene:TestScene2D;
		
		/** The camera used to manipulate the scene's projection. */
		public var camera:Camera2D;
		
		/** The set of keyboard keys currently being held down. */
		public var downKeys:Array = new Array();
		//}
		
		
		//{ Initialization
		public function Camera2DTest() 
		{
			// Display instructions
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
			messageText.text = "Camera2D class Test\n" +
				"   WASD - Move\n" + 
				"	QE - Rotate\n" + 
				"	RF - Zoom\n" + 
				"	Space - Reset\n";
			
			// Set the scene
			scene = new TestScene2D();
			stage.addChildAt(scene, 0);
			
			// Create the camera with the proper viewing dimensions
			camera = new Camera2D(stage.stageWidth, stage.stageHeight);
			
			// Apply the camera's initial transformation to the scene
			camera.apply(scene);
			
			// Listen for keyboard input and frames to update
			stage.addEventListener(KeyboardEvent.KEY_DOWN, stage_keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, stage_keyUp);
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrame);
		}
		//}
		
		
		//{ Input
		private final function stage_keyDown(event:KeyboardEvent):void
		{
			downKeys[event.keyCode] = true;
		}
		
		private final function stage_keyUp(event:KeyboardEvent):void
		{
			downKeys[event.keyCode] = false;
		}
		//}
		
		
		//{ Updating
		private final function stage_enterFrame(event:Event):void
		{
			// Find the estimated number of elapsed seconds
			var elapsedSeconds:Number = 1 / stage.frameRate;
			
			// Move in screen aligned space
			// We scale the actual move delta based on how much time 
			// has gone by and how fast the camera moves
			var moveSpeed:Number = 300;		// px per second
			var moveDelta:Point = new Point();
			if (downKeys[Keyboard.W]) moveDelta = moveDelta.add(camera.up);
			if (downKeys[Keyboard.S]) moveDelta = moveDelta.subtract(camera.up);
			if (downKeys[Keyboard.A]) moveDelta = moveDelta.subtract(camera.right);
			if (downKeys[Keyboard.D]) moveDelta = moveDelta.add(camera.right);
			moveDelta.normalize(moveSpeed * elapsedSeconds);
			camera.x += moveDelta.x;
			camera.y += moveDelta.y;
			
			// Rotate around the current view point
			var rotationSpeed:Number = 90;	// degress / second
			var rotationDelta:Number = 0;
			if (downKeys[Keyboard.Q]) rotationDelta--;
			if (downKeys[Keyboard.E]) rotationDelta++;
			rotationDelta *= rotationSpeed * elapsedSeconds;
			camera.rotation += rotationDelta;
			
			// Zoom in and out from the current view point
			// Due to the nature of scaling, the visual effect of zooming 
			// in and out will diminsh over time, thus we scale our zoom 
			// delta by the factor of the current zoom to achieve a smooth zoom
			var zoomSpeed:Number = 1;
			var zoomDelta:Number = 0;
			if (downKeys[Keyboard.R]) zoomDelta++;
			if (downKeys[Keyboard.F]) zoomDelta--;
			zoomDelta *= camera.zoom * zoomSpeed * elapsedSeconds;
			camera.zoom += zoomDelta;
			
			// Watch for resets
			if (downKeys[Keyboard.SPACE])
			{
				camera.x = 0;
				camera.y = 0;
				camera.rotation = 0;
				camera.zoom = 1;
			}
			
			// Apply the new view transformation to the scene if it has changed
			if (camera.changed)
			{
				camera.apply(scene);
			}
		}
		//}
		
	}

}
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
package com.naut.scene2D 
{
	//{ Import
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	//}
	
	/**
	 * A very basic layered scene with a 3 layers of trees and grass.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class TestScene2D extends Sprite
	{
		
		//{ Layers
		public var foreground:Sprite = new Sprite();
		public var midground:Sprite = new Sprite();
		public var background:Sprite = new Sprite();
		//}
		
		
		//{ Graphics
		public var groundBmpData:BitmapData;
		public var treeBmpData:BitmapData;
		//}
		
		
		//{ Initialization
		public function TestScene2D() 
		{
			// Add the layers
			addChild(background);
			addChild(midground);
			addChild(foreground);
			
			// Give the layers some fogginess to set them apart
			var ct:ColorTransform = background.transform.colorTransform;
			ct.redOffset = ct.greenOffset = ct.blueOffset = 50;
			background.transform.colorTransform = ct;
			
			ct = midground.transform.colorTransform;
			ct.redOffset = ct.greenOffset = ct.blueOffset = 25;
			midground.transform.colorTransform = ct;
			
			// Add trees to each layer
			for (var i:int = 0; i < 10; ++i)
			{
				drawTree(background);
				drawTree(midground);
				drawTree(foreground);
			}
			
			// Draw the ground for each layer
			drawGround(background);
			drawGround(midground);
			drawGround(foreground);
		}
		//}
		
		
		//{ Drawing
		private function drawGround(layer:Sprite):void
		{
			if (groundBmpData == null)
			{
				var spr:Sprite = new Sprite();
				spr.graphics.clear();
				spr.graphics.beginFill(0x86942A);
				spr.graphics.drawRect(0, 0, 32, 32);
				spr.graphics.endFill();
				
				groundBmpData = new BitmapData(32, 32, false, 0xFF86942A);
			}
			
			var bmp:Bitmap = new Bitmap(groundBmpData, "auto", false);
			
			bmp.width = 3000;
			bmp.height = 1080 / 2;
			bmp.x = -1500;
			bmp.y = 0;
			
			layer.addChild(bmp);
		}
		
		private function drawTree(layer:Sprite):void
		{
			if (treeBmpData == null)
			{
				var spr:Sprite = new Sprite();
				spr.graphics.clear();
				spr.graphics.beginFill(0xA37B45);
				spr.graphics.drawRect(12.5, 37.5, 50, 125);
				spr.graphics.endFill();
				spr.graphics.beginFill(0x507642);
				spr.graphics.drawCircle(37.5, 37.5, 37.5);
				spr.graphics.endFill();
				
				treeBmpData = new BitmapData(75, 162.5, true, 0x00000000);
				treeBmpData.draw(spr);
			}
			
			var bmp:Bitmap = new Bitmap(treeBmpData, "auto", false);
			bmp.y = -160;
			bmp.x = (Math.random() * 2800 - 1400) - 37.5;
			
			layer.addChild(bmp);
		}
		//}
		
	}

}
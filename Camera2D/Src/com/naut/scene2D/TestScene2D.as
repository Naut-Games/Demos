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
		
		
		//{ Initialization
		public function TestScene2D() 
		{
			// Add the layers
			addChild(background);
			addChild(midground);
			addChild(foreground);
			
			// Give the midground and background a little fogginess using a white ting
			var ct:ColorTransform = background.transform.colorTransform;
			ct.redOffset = ct.greenOffset = ct.blueOffset = 50;
			background.transform.colorTransform = ct;
			
			ct = midground.transform.colorTransform;
			ct.redOffset = ct.greenOffset = ct.blueOffset = 25;
			midground.transform.colorTransform = ct;
			
			// Add random trees to the layers
			for (var i:int = 0; i < 10; ++i)
			{
				drawTree(background);
				drawTree(midground);
				drawTree(foreground);
			}
			
			// Draw the ground in each layer
			drawGround(background);
			drawGround(midground);
			drawGround(foreground);
			
			// Cache the graphics as real bitmaps for performance
			rasterGraphics(background);
			rasterGraphics(midground);
			rasterGraphics(foreground);
		}
		
		
		//{ Graphics
		private function drawGround(layer:Sprite):void
		{
			var y:Number = 600 / 2 * 0.7 + 100;
			
			layer.graphics.beginFill(0x86942A);
			layer.graphics.drawRect( -1500, -10 + y, 3000, 600 / 4);
			layer.graphics.endFill();
		}
		
		private function drawTree(layer:Sprite):void
		{
			var x:Number = Math.random() * 2800 - 1400;
			var y:Number = 600 / 2 * 0.7 + 100;
			
			layer.graphics.beginFill(0xA37B45);
			layer.graphics.drawRect( -50 + x, -200 + y, 100, 200);
			layer.graphics.endFill();
			
			layer.graphics.beginFill(0x507642);
			layer.graphics.drawCircle(0 + x, -250 + y, 75);
			layer.graphics.endFill();
		}
		//}
		
		
		//{ Bitmap Caching
		private function rasterGraphics(layer:Sprite):void
		{
			// Manually cache the drawing to a bitmap because large vector is expensive
			layer.x = 1500;
			layer.y = 600 / 2;
			var bitmapData:BitmapData = new BitmapData(3000, 600 + 300, true, 0x00000000);
			bitmapData.draw(layer, layer.transform.matrix);
			var bmp:Bitmap = new Bitmap(bitmapData);
			layer.graphics.clear();
			layer.x = 0;
			layer.y = 0;
			
			// Position the bitmap and add it as a child
			bmp.x = -bitmapData.width / 2;
			bmp.y = -bitmapData.height / 2;
			layer.addChild(bmp);
		}
		//}
		
	}

}
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
	import flash.display.Sprite;
	//}
	
	/**
	 * A very basic scene with an origin and a grid of squares.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class TestScene2D extends Sprite
	{
		
		//{ Initialization
		public function TestScene2D() 
		{
			var gridRadius:int = 32;
			var cellSize:int = 2048 / gridRadius;
			
			// Draw a nice alpha floor plane that encompasses the entire grid
			graphics.clear();
			graphics.lineStyle(2, 0xFFFFFF, 0.015);
			graphics.beginFill(0xFFFFFF, 0.1);
			graphics.drawRect( -gridRadius * cellSize, -gridRadius * cellSize, (gridRadius * 2) * cellSize, (gridRadius * 2) * cellSize);
			graphics.endFill();
			
			// Draw grid lines for each cell
			for (var x:int = -gridRadius; x <= gridRadius; ++x)
			{
				for (var y:int = -gridRadius; y <= gridRadius; ++y)
				{
					graphics.moveTo( -gridRadius * cellSize, y * cellSize);
					graphics.lineTo(  gridRadius * cellSize, y * cellSize);
					
					graphics.moveTo(x * cellSize, -gridRadius * cellSize);
					graphics.lineTo(x * cellSize,  gridRadius * cellSize);
				}
			}
			
			// Draw the x and y axes
			graphics.lineStyle(4, 0xFF0000, 1);
			graphics.moveTo( -gridRadius * cellSize, 0);
			graphics.lineTo(gridRadius * cellSize, 0);
			
			graphics.lineStyle(4, 0x00FF00, 1);
			graphics.moveTo(0, -gridRadius * cellSize);
			graphics.lineTo(0, gridRadius * cellSize);
			
			// Manually cache the drawing to a bitmap because large vector is expensive
			this.x = gridRadius * cellSize;
			this.y = gridRadius * cellSize;
			var bitmapData:BitmapData = new BitmapData((gridRadius * 2) * cellSize, (gridRadius * 2) * cellSize, true, 0x00000000);
			bitmapData.draw(this, this.transform.matrix);
			var bmp:Bitmap = new Bitmap(bitmapData);
			graphics.clear();
			this.x = 0;
			this.y = 0;
			
			// Position the bitmap and add it as a child
			bmp.x = -bitmapData.width / 2;
			bmp.y = -bitmapData.height / 2;
			this.addChild(bmp);
		}
		
	}

}
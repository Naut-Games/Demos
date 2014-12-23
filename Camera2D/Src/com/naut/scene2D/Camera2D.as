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
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	//}
	
	/**
	 * A basic camera for manipulating 2D scenary projections.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class Camera2D 
	{
		
		//{ Members
		/** The x position, in world space, that the camera is looking at. */
		public function get x():Number { return _x; }
		public function set x(value:Number):void { if (_x != value) { _x = value; _dirty = true; } }
		private var _x:Number = 0;
		
		/** The y position, in world space, that the camera is looking at. */
		public function get y():Number { return _y; }
		public function set y(value:Number):void { if (_y != value) { _y = value; _dirty = true; } }
		private var _y:Number = 0;
		
		/** The rotation of the camera in degrees. Internal calculations rely on radians. */
		public function get rotation():Number { return _radians * 57.29577951; }
		public function set rotation(degrees:Number):void { var r:Number = degrees * 0.017453293; if (r != _radians) { _radians = r; _dirty = true; } }
		private var _radians:Number = 0;
		
		/** The zoom of the camera affects the scale of the scene. 2x zoom means 2 for scaleX and scaleY. */
		public function get zoom():Number { return _zoom; }
		public function set zoom(value:Number):void { if (_zoom != value) { _zoom = value; _dirty = true; } }
		private var _zoom:Number = 1;
		
		/** The width of the camera's viewing area. Determines where the camera's position (x,y) will be focused on. */
		public function get viewWidth():uint { return _originX * 2; }
		public function set viewWidth(value:uint):void { value /= 2; if (_originX != value) { _originX = value; _dirty = true; } }
		
		/** The height of the camera's viewing area. Determines where the camera's position (x,y) will be focused on. */
		public function get viewHeight():uint { return _originY * 2; }
		public function set viewHeight(value:uint):void { value /= 2; if (_originY != value) { _originY = value; _dirty = true; } }
		
		/** The view transform matrix used to transform screen space into world space. */
		public function get view():Matrix { if (_dirty) { calculate(); } return _view.clone(); }
		public function set view(value:Matrix):void { _view.copyFrom(value); _dirty = false; _changed = true; }
		private const _view:Matrix = new Matrix();
		
		/** The direction "up" from the camera's current viewing perspective, this would be -y in stage coordinate space. */
		public final function get up():Point { return Point.polar(1, _radians + 4.7123889803846895); }
		
		/** The direciton "right" from the camera's current viewing perspective, this would be +x in stage coordinate space. */
		public final function get right():Point { return Point.polar(1, _radians); }
		
		/** Indicates if view has changed since the last application view the apply() method. */
		public final function get changed():Boolean { return _changed || _dirty; }
		private var _changed:Boolean = true;
		
		/** The center of the camera's view. Used as the scaling and rotation origin. */
		private var _originX:Number = 0;
		private var _originY:Number = 0;
		
		/** Indicates if the values of the camera have changed since the last call to calculate. */
		private var _dirty:Boolean = false;
		//}
		
		
		//{ Initialization
		/**
		 * Creates a new camera with the view dimensions supplied.
		 * @param	viewWidth	The width of the camera's viewport.
		 * @param	viewHeight	The height of the camera's viewport.
		 */
		public function Camera2D(viewWidth:uint = 0, viewHeight:uint = 0)
		{
			this.viewWidth = viewWidth;
			this.viewHeight = viewHeight;
		}
		//}
		
		
		//{ Calculations
		/**
		 * Recalculates the camera's viewing matrix.
		 */
		private final function calculate():void
		{
			_view.identity();
			_view.tx = -_x;
			_view.ty = -_y;
			_view.rotate( -_radians);
			_view.scale(_zoom, _zoom);
			_view.translate(_originX, _originY);
			_dirty = false;
			_changed = true;
		}
		//}
		
		
		//{ Application
		/**
		 * Applies the camera's current view to the display object supplied.
		 * @param	scene	The scene object to apply the viewing transform to.
		 */
		public function apply(scene:DisplayObject):void
		{
			if (_dirty) calculate();
			_changed = false;
			scene.transform.matrix = _view;
		}
		//}
		
	}

}
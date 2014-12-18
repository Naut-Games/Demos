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
 * The above copyright notice and this permission notice shall be included in 
 * all copies or substantial portions of the Software.
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
package com.naut.utils 
{
	//{ Import
	import flash.utils.Dictionary;
	//}
	
	/**
	 * A utility class for creating weak references to objects. The weak reference instance itself
	 * is a lightweight wrapper for the built in Dictionary class. When the flash player mark and
	 * sweep garbage collector runs, the object being weakly referenced will be marked and collected 
	 * if only weak references are pointing to it.
	 * 
	 * The idea: 
	 * The flash.utils.Dictionary class is capable of weakly referencing instances of objects when
	 * objects are supplied as keys. In order to weakly store the object, we use the object as the
	 * key and any non-null value as the mapped value (we use true).
	 * 
	 * How we've used this in the past:
	 * - We've mainly used this in the past for caching and object pooling. 
	 * 
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public final class WeakReference 
	{
		
		//{ Members
		/** The weak reference to the object being wrapped. The object being weakly held is stored as the key. */
		private var _reference:Dictionary = new Dictionary(true);
		
		/** Gets or sets the object being referenced. Returns null if the reference is no longer valid. */
		public final function get object():Object 
		{
			for (var object:Object in _reference) 
			{
				return object; 
			}
			return null; 
		}
		public final function set object(value:Object):void 
		{
			if (value) _reference[value] = true; 
			else _reference = new Dictionary(true);
		}
		//}
		
		
		//{ Initialization
		/**
		 * Creates a new weak reference to an object. 
		 * @param	object The object being weakly referenced.
		 */
		public function WeakReference(object:Object = null) 
		{
			if (object) _reference[object] = true; 
		}
		//}
		
	}

}
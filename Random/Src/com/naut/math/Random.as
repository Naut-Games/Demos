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
package com.naut.math
{
	//{ Import
	import flash.utils.ByteArray;
	//}
	
	/**
	 * Psuedo random number generator (RNG) that employs a crude Linear 
	 * Congruential Generator (LCG) algorithm.
	 * 
	 * This RNG can generate values in [0, 1) and (0,1), generating numbers
	 * in the latter range practially suitable for initializing weights in 
	 * a neural network.
	 * 
	 * This may not be a perfect implementation of LCG, but it is fast (enough)
	 * and suitable for most game development applications.
	 * 
	 * This RNG is by no means suitable for encryption or security.
	 * 
	 * The key factor in measuring the success of this RNG is that it is 
	 * sufficiently efficient, seedable so results can be reproduced, and 
	 * that it produces sufficiently random results.
	 * 
	 * Note that this RNG may exhibit different generation results on different
	 * platforms / hardware, but the occurance is rare.
	 * 
	 * How we've applied this in the past:
	 * 		- We've used this RNG to save randomly generated game state, like 
	 * 			a randomly generated real time strategy game map. Using the RNG
	 * 			we were able to regenerate the mapwithout having the save the 
	 * 			entire map configuration.
	 * 		- We've ported this RNG to C# and Java to generate the same values
	 * 			in server applications, so the server does not need to send
	 * 			or recieve and large set of generated values.
	 * 		- We've used this RNG to generate the same set of values on multiple
	 * 			networked clients simply by sending the seed from one client 
	 * 			to another.
	 * 
	 * This RNG is not suitable to generate large volumes of noise in real time
	 * consider using the bitmap generate noise function for similar behavior.
	 * 
	 * Possible improvements:
	 *		1. Consistent generation across platforms / hardware
	 * 		2. Reverse stepping through values
	 * 		3. Even faster algorithm
	 * 		4. Alchemy math integration
	 * 
	 * @see http://en.wikipedia.org/wiki/Linear_congruential_generator
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public final class Random
	{
		
		//{ Members
		/** The seed that is used to generate the next random number. */
		private var seed:int;
		//}
		
		
		//{ Initialization
		/** 
		 * Creates a new seedable psuedo random number generator.
		 * @param seed	The non-negative integer used to initialize the RNG, 
		 * 	null will give rng based on time.
		 */
		public function Random(seed:* = null) 
		{
			// Handle optional seed, default to time
			if (seed == null)
			{
				seed = int(new Date().getTime());
			}
			else if (seed is int == false) 
			{
				// Non integer seeds are unsupported!
				throw new Error("Seed must be an int!");
			}
			
			// Ensure that the seed is positive for LCG algo
			this.seed = Math.abs(seed);
		}
		//}
		
		
		//{ Generation
		/**
		 * Generates the next Number in range [0,1).
		 * @return A randomly generated number >= 0 and < 1.
		 */
		public function nextDecimal():Number 
		{
			return sample() / int.MAX_VALUE;
		}
		
		/**
		 * Generates the next Number in range [min, 1 - max).
		 * Providing no values will effectively give a number in range (0,1).
		 * 
		 * @param min	The minimum inclusive value.
		 * @param max	The maximum exclusive value.
		 * @return The randomly generated number.
		 */
		public function nextDecimalIn(min:Number = NaN, max:Number = 1):Number
		{
			if (isNaN(min)) min = Number.MIN_VALUE;
			
			// Generate a 0 inclusive double in range [0,1)
			var dbl:Number = nextDecimal();
			
			// Find the range of [min, max)
			if (min == Number.MIN_VALUE)
			{
				// We want to get (0, 1) as close as possible
				// remove only 1 min value as dbl is given in [0,1)
				var range:Number = max - min;
			}
			else
			{
				// remove 2 mins from the range
				range = max - min * 2;
			}
			
			// Map the value onto the range (min,max)
			dbl = min + dbl * range;
			
			return dbl;
		}
		
		/**
		 * Generates the next integer in range [0, int.MAX_VALUE).
		 * @return The integer generated.
		 */
		public function nextInt():int 
		{
			return sample();
		}
		
		/**
		 * Generates the next integer in range [0, maxValue).
		 * @param	maxValue	The maximum exclusive value.
		 * @return	The integer generated.
		 */
		public function nextIntUnder(maxValue:int):int 
		{
			return int(sample() / int.MAX_VALUE * maxValue);
		}
		
		/**
		 * Generates the next integer in range [minValue, maxValue).
		 * @param	minValue	The minumum inclusive value.
		 * @param	maxValue	The maximum exclusive value.
		 * @return	The integer generated.
		 */
		public function nextIntIn(minValue:int, maxValue:int):int 
		{
			// Find the range
			var range:int = maxValue - minValue;
			
			// Ensure a valid range
			if (range == 0) return minValue;
			else if (range < 0) throw (new Error("Range is less than 0!"));
			
			return int(sample() / int.MAX_VALUE * maxValue + minValue);
		}
		//}
		
		
		//{ Sample
		/**
		 * The generation function using the LCG algorithm.
		 * @return An generated integer in range [0,int.MAX_VALUE)
		 */
		protected function sample():int 
		{
			var random:int = 0;
			var byteArray:ByteArray = new ByteArray();
			var d:Number = seed;
			
			// Generate some noise and read from it
			for (var i:int = 0; i < 16; ++i)
			{
				// Random calc
				d = 1024243321.0 * d + 1.0;
				byteArray.clear();
				byteArray.writeDouble(d);
				byteArray.position = 4;
				
				// Update the seed
				seed = byteArray.readInt();
				
				// Update the random
				random = random << 2;
				random = random + (seed >> 30);
			}
			
			random = Math.abs(random);
			
			return random;
		}
		//}
		
	}

}

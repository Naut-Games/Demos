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
package com.naut.ai
{
	/**
	 * A connection between two neurons that learns through backpropagation.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	internal class Synapse 
	{
		
		//{ Members
		/** The previous and next neurons attached to this synapse. */
		internal var prev:Neuron;
		internal var next:Neuron;
		
		/** The current weighting at this synapse, determines how the signal should be adjusted as it passes through. */
		internal var weight:Number;
		
		/** The amount weight should be shifted to account for any observed error. */
		private var _delta:Number = 0;
		
		/** The weighted signal coming from the previous neuron. */
		internal function get signal():Number { return prev.signal * weight; }
		
		/** The weighted error observed in the next neuron. */
		internal function get error():Number { return next.error * weight; }
		//}
		
		
		//{ Initialization
		/**
		 * Creates a new weighted synapses and connects the two neurons.
		 * @param	prev	The neuron that feeds into this synapse.
		 * @param	next	The neuron that feeds from this synapse.
		 * @param	weight	The weight of the synapse that is applied to the signal.
		 */
		public function Synapse(prev:Neuron, next:Neuron, weight:Number) 
		{
			this.weight = weight;
			
			this.prev = prev;
			prev.outputs.push(this);
			
			this.next = next;
			next.inputs.push(this);
		}
		//}
		
		
		//{ Training
		/**
		 * Backpropagates error and weighting adjustment through this synapse.
		 */
		internal function backpropagate():void
		{
			// Determine how much to shift our weight based on the error
			_delta += next.error * prev.signal;
		}
		
		/**
		 * Adjusts weighting based on the amount of error and adjustment recorded.
		 * @param	learningRate The rate at which to apply the recorded adjustment.
		 */
		internal function learn(learningRate:Number):void
		{
			weight += _delta * learningRate;
			_delta = 0;
		}
		//}
		
	}

}
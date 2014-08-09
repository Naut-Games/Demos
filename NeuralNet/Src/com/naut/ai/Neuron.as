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
	 * A basic neuron that uses a sigmoid activation function and learns through backpropagation.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	internal class Neuron
	{
		
		//{ Members
		/** The value computed at this neuron. */
		internal var signal:Number;
		
		/** The set of incoming and outgoing connections to other neurons. */
		internal var inputs:Vector.<Synapse> = new Vector.<Synapse>();
		internal var outputs:Vector.<Synapse> = new Vector.<Synapse>();
		
		/** The current weighting at this neuron, determines how the signal should be adjusted as it passes through. */
		private var _weight:Number;
		
		/** The amount of error observed in the signal when training. */
		internal var error:Number;
		
		/** The amount weight should be shifted to account for any observed error. */
		private var _delta:Number = 0;
		//}
		
		
		//{ Initialization
		/**
		 * Creates a new neuron with the given weight.
		 * @param	weight
		 */
		public function Neuron(weight:Number)
		{
			this._weight = weight;
		}
		//}
		
		
		//{ Solving
		/**
		 * Recomputes the signal at this neuron by looking at the incoming signals.
		 */
		internal function pulse():void
		{
			// Recompute the signal based on the incoming signals
			signal = 0;
			for (var i:int = 0; i < inputs.length; ++i)
			{
				var input:Synapse = inputs[i];
				signal += input.signal;
			}
			signal += _weight;
			
			// Normalize the signal to a valid range
			normalize();
		}
		
		/**
		 * Normalizes the signal from (0,1) at this neuron using a sigmoid function.
		 */
		private function normalize():void
		{
			signal = 1 / (1 + Math.exp(-signal));	// sigmoid
		}
		//}
		
		
		//{ Training
		/**
		 * Backpropagates error and weighting adjustment through this neuron and its input synapses.
		 * @param	outputSignals	The expected output at leaf nodes.
		 * @param	index	The index of this neuron in its containing layer.
		 */
		internal function backpropagate(outputSignals:Vector.<Number>, index:int):void
		{
			// Calculate the error observed
			if (outputs.length == 0)
			{
				// leaf nodes use the desired output
				error = (outputSignals[index] - signal) * derivative();
			}
			else
			{
				// hidden nodes use the weighted error of their children
				error = 0;
				for (var o:int = 0; o < outputs.length; ++o)
				{
					var output:Synapse = outputs[o];
					error += (output.error) * derivative();
				}
			}
			
			// Determine how much to shift our weight based on the error
			_delta += error * _weight;
			
			// Backpropagate to each of the incoming synapses
			for (var i:int = 0; i < inputs.length; ++i)
			{
				inputs[i].backpropagate();
			}
		}
		
		/**
		 * Calculates how the velocity of the signal over the standard sigmoid range (0,1). 
		 * Used to calculate the direction and magnitude of error in backpropagation.
		 * @return The slope at signal in the sigmoid function.
		 */
		private function derivative():Number
		{
			return signal * (1.0 - signal);			// sigmoid derivative
		}
		
		/**
		 * Adjusts weighting based on the amount of error and adjustment recorded.
		 * @param	learningRate The rate at which to apply the recorded adjustment.
		 */
		internal function learn(learningRate:Number):void
		{
			// Adjust weighting based on the shifting we've noted
			_weight += _delta * learningRate;
			_delta = 0;
			
			// Adjust each of the incoming synapses
			for (var i:int = 0; i < inputs.length; ++i) 
			{
				inputs[i].learn(learningRate);
			}
		}
		//}
		
	}

}
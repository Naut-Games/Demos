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
	 * A layer of neurons within a feedforward neural network that learns through backpropagation.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	internal class NeuralLayer 
	{
		
		//{ Members
		/** The set of neurons contained within this layer. */
		internal var neurons:Vector.<Neuron>;
		//}
		
		
		//{ Initialization
		/**
		 * Creates a new neuron layer.
		 * @param	numNeurons	The number of neurons in this layer.
		 */
		public function NeuralLayer(numNeurons:int)
		{
			neurons = new Vector.<Neuron>(numNeurons, true);
			for (var n:int = 0; n < numNeurons; ++n) 
			{
				neurons[n] = new Neuron(Math.random());
			}
		}
		
		/**
		 * Connects this neuron layer to the next layer in the network.
		 * @param	nextLayer	The next layer in the network.
		 */
		internal function connect(nextLayer:NeuralLayer):void
		{
			for (var i:int = 0; i < neurons.length; ++i)
			{
				for (var j:int = 0; j < nextLayer.neurons.length; ++j)
				{
					new Synapse(neurons[i], nextLayer.neurons[j], Math.random());
				}
			}
		}
		//}
		
		
		//{ Access
		/**
		 * Sets all of the neuron signals in this layer.
		 * @param	signals	The signals to set the neurons to.
		 */
		internal function setSignals(signals:Vector.<Number>):void
		{
			for (var s:int = 0; s < signals.length; ++s)
			{
				neurons[s].signal = signals[s];
			}
		}
		
		/**
		 * Retrives the signals at each neuron in this layer.
		 * @return	The signals of each neuron in this layer.
		 */
		internal function getSignals():Vector.<Number>
		{
			var out:Vector.<Number> = new Vector.<Number>(neurons.length, true);
			
			for (var n:int = 0; n < neurons.length; ++n)
			{
				out[n] = neurons[n].signal;
			}
			
			return out;
		}
		//}
		
		
		//{ Solving
		/**
		 * Propagates the signal forward into the neurons of this layer.
		 */
		internal function pulse():void
		{
			for (var n:int = 0; n < neurons.length; ++n)
			{
				neurons[n].pulse();
			}
		}
		//}
		
		
		//{ Training
		/**
		 * Backpropagates error and weighting adjustment through this layer's neurons and their input synapses.
		 * @param	outputSignals	The expected output at leaf nodes.
		 */
		internal function backpropagate(outputSignals:Vector.<Number>):void
		{
			for (var n:int = 0; n < neurons.length; ++n)
			{
				neurons[n].backpropagate(outputSignals, n);
			}
		}
		
		/**
		 * Adjusts weighting based on the amount of error and adjustment recorded at each neuron and their input synapses.
		 * @param	learningRate The rate at which to apply the recorded adjustment.
		 */
		internal function learn(learningRate:Number):void
		{
			for (var n:int = 0; n < neurons.length; ++n)
			{
				neurons[n].learn(learningRate);
			}
		}
		//}
		
	}

}
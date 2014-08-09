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
	 * A basic 3 layer feedforward neural network.
	 * @author Spencer Evans	spencer@nautgames.com
	 */
	public class NeuralNet 
	{
		
		//{ Members
		/** All of the neuron layers present in this network. */
		protected var inputLayer:NeuralLayer;
		protected var hiddenLayer:NeuralLayer;
		protected var outputLayer:NeuralLayer
		
		/** The rate at which the network learns while training. */
		public var learningRate:Number = 3.0;
		//}
		
		
		//{ Initialization
		/**
		 * Creates a new empty neural net. 
		 */
		public function NeuralNet() { }
		
		/**
		 * Initializes the neural net to the specified size.
		 * @param	numInput	The number of input layer nodes.
		 * @param	numHidden	The number of hidden nodes.
		 * @param	numOutput	The number of output nodes.
		 */
		public function initialize(numInput:int, numHidden:int, numOutput:int):void
		{
			// Create the layers
			inputLayer = new NeuralLayer(numInput);
			hiddenLayer = new NeuralLayer(numHidden);
			outputLayer = new NeuralLayer(numOutput);
			
			// Connect all the layers
			inputLayer.connect(hiddenLayer);
			hiddenLayer.connect(outputLayer);
		}
		//}
		
		
		//{ Solving
		/**
		 * Sends signals through the network, effectively computing the output values.
		 * @param	signals	(optional) Specifies the input values to set before evaluation.
		 * @return	The set of output values found.
		 */
		public function evaluate(signals:Vector.<Number> = null):Vector.<Number>
		{
			if (signals != null) inputLayer.setSignals(signals);
			
			pulse();
			
			return outputLayer.getSignals();
		}
		
		/**
		 * Propagates the signal forward into the layers of this net.
		 */
		private function pulse():void
		{
			hiddenLayer.pulse();
			outputLayer.pulse();
		}
		//}
		
		
		//{ Training
		/**
		 * Trains the network using the provided input and expected output signals.
		 * @param	inputSets	The set of given input signal groups.
		 * @param	outputSets	The set of expected output signals for each input signal group.
		 * @param	iterations	The number of iterations to train for.
		 */
		public function train(inputSets:Vector.<Vector.<Number>>, outputSets:Vector.<Vector.<Number>>, iterations:Number = 1):void
		{
			// Run through each training set
			for (var i:int = 0; i < iterations; ++i)
			{
				for (var t:int = 0; t < inputSets.length; ++t)
				{
					inputLayer.setSignals(inputSets[t]);
					
					pulse();
					
					backpropagate(outputSets[t]);
				}
				
				learn();
			}
		}
		
		/**
		 * Backpropagates error and weighting adjustment through the network.
		 * @param	outputSignals	The expected output at leaf nodes.
		 */
		private function backpropagate(outputSignals:Vector.<Number>):void
		{
			outputLayer.backpropagate(outputSignals);
			hiddenLayer.backpropagate(outputSignals);
		}
		
		/**
		 * Adjusts weighting based on the amount of error and adjustment 
		 * recorded at each neuron and their input synapses.
		 */
		private function learn():void
		{
			hiddenLayer.learn(learningRate);
			outputLayer.learn(learningRate);
		}
		//}
		
	}

}
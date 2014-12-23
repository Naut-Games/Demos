NAUT Games - Demos
=====

This repository contains source files for technical demonstrations published by NAUT games. 

##About the Demos
You can find information about the demos detailed in the github project wiki @ https://github.com/naut-games/demos/wiki. A brief overview of the demos is listed below.

### Camera for 2D Scenes with Parallax
_Location: Demos/Camera2D_<br/>
_Language: AS3_<br/>
_Project Types: FlashDevelop, Flash IDE_<br/>
This demonstration shows off a simple camera class for easily transforming 2 dimensional scenes. The camera class features position, rotation, zoom, and parallax capabilities. The class is relatively efficient and suitable for real time games. We've used it in side on and top down scrolling games.

### Weak Referencing Objects
_Location: Demos/WeakReference_<br/>
_Language: AS3_<br/>
_Project Types: FlashDevelop, Flash IDE_<br/>
This demonstration contains a utility class for creating weak references to objects. The weak reference instance itself is a lightweight wrapper for the built in Dictionary class. When the flash player mark and sweep garbage collector runs, the object being weakly referenced will be marked and collected if only weak references are pointing to it. WeakReferences should be used sparingly. We've effectively used them in caching and object pooling.

### Random Number Generator
_Location: Demos/Random_<br/>
_Language: AS3_<br/>
_Project Types: FlashDevelop, Flash IDE_<br/>
This demonstration contains a seedable psuedo Random Number Generator (RNG) implemented using a Linear Congruential Generator (LCG) algorithm. This RNG is not suitable for encryption / security or generating large volumes of noise in real time. This generator does have many practical applications listed in the Random.as class header.

### Neural Network
_Location: Demos/NeuralNet_<br/>
_Language: AS3_<br/>
_Project Types: FlashDevelop, Flash IDE_<br/>
This demonstration contains a basic 3 layer feed-forward neural network that is trained via sigmoid function based back-propagation. A neural network of this type is suitable for most simple applications and specifically for games.

## Questions, Comments, Feature Requests...
Please email spencer@nautgames.com!

## Changelog
#### Updated: 2014-12-22
 * Added parallax capabilities to the Camera2D demo
 * Added the Camera2D tech demo

#### Updated: 2014-12-18
 * Added the WeakReference tech demo

#### Updated: 2014-08-09
 * Added the Random tech demo

#### Updated: 2014-08-08
 * Added the NeuralNet tech demo

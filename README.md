# Swift AI
A high-performance AI and Machine Learning library written entirely in Swift.
These tools have been optimized for use in both iOS and OS X applications, with support for more platforms coming soon!

This library is a work in progress, and more features and improvements will be added shortly.

### Features
- [x] Feed-Forward Neural Network
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [ ] Genetic Algorithms
- [ ] Fast Matrix Library
- [ ] Fourier Transform Functions



### Usage
Pick the files you need, drag them into your project. That was easy!


#### Multi-Layer Feed-Forward Neural Network
###### FFNN.swift
The `FFNN` class contains a fully-connected, 3-layer feed-forward neural network.  This neural net uses standard backpropagation for its training algorithm (stochastic gradient descent), and is designed for flexibility and use in performance-critical applications.

Creating an `FFNN` instance is easy...

```
  let network = FFNN(inputs: 100, hidden: 64, outputs: 10,
    learningRate: 0.7, momentum: 0.4, weights: nil)
```
You must provide six parameters to the initializer:
- `inputs`: The number of input nodes (aka, 'neurons'). This number corresponds to the dimensionality of the data that you plan to feed the network. If this example were to be used for handwriting recognition, `100` might be the number of pixels in each image being processed.
- `hidden`: The number of nodes in the hidden layer. The ideal number of hidden nodes depends heavily on the application, and should be determined by testing. If you're completely unsure, [(inputs * 2/3) + outputs] may be a good place to start.
- `outputs`: The number of output nodes. For classification problems (like recognizing handwritten digits), the number of outputs usually corresponds to the number of possible classifications. In this example, each output might correspond to one digit (0-9). The number of outputs depends entirely on the problem being applied.
- `learningRate`: The 'learning rate' to apply during the backpropagation phase of training. If you're unsure what this means, `0.7` is probably a good number.
- `momentum`: Another constant applied during backpropagation. If you're not sure, try `0.4`.
- `weights`: An optional array of `Float`s used to initialize the weights of the neural network. This allows you to 'clone' a pre-trained network, so that it's immediately prepared to solve problems without training first. When you're creating a new network from scratch, leave this parameter `nil` and random weights will assigned based on your input data.



### Compatibility
Swift AI currently depends on Apple's Accelerate framework for vector/matrix calculations and digital signal processing. With Swift becoming open-source later this year, it remains to be seen if additional frameworks will be released as well.

In order to provide support for multiple platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is possible, but SIMD instructions will be preferred for their significant performance boost.

### Notes
Compiler optimizations can greatly enhance the performance of Swift AI. Even the default 'Release' build settings can increase speed by up to 10x, but it is also recommended that Whole Module Optimization be enabled for maximum efficiency.

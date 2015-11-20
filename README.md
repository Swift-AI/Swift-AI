# Swift AI
A high-performance AI and Machine Learning library written entirely in Swift.
These tools have been optimized for use in both iOS and OS X applications, with support for more platforms coming soon!

This library is a work in progress and more features and improvements will be added regularly.

### Features
- [x] Feed-Forward Neural Network
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [ ] Genetic Algorithms
- [ ] Fast Matrix Library
- [ ] Fourier Transform Functions

### Compatibility
Swift AI currently relies on Apple's Accelerate framework for vector/matrix calculations and digital signal processing. With Swift becoming open-source later this year, it remains to be seen if any frameworks will be released as well.

In order to provide support for multiple platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is possible, but SIMD instructions are desirable for their significant performance boost.

### Usage
Pick the files you need, drag them into your project. That was easy!


#### ANN.swift: Feed-Forward Neural Network
The `ANN` class contains a fully-connected, feed-forward neural network.  This neural net uses a standard backpropagation training algorithm, and is designed for flexibility and performance-critical applications.
Put some instructions and examples here.


### Notes
Compiler optimizations can greatly enhance the performance of Swift AI. Even the default 'Release' build settings can increase speed by up to 10x, but it is also recommended that Whole Module Optimization be enabled as this can provide an additional boost.

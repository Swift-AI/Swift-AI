# Swift AI
Swift AI is a high-performance AI and Machine Learning library written entirely in Swift.
These tools have been optimized for use in both iOS and OS X applications, with support for more platforms coming soon!

This library is a work in progress, and more features will be added shortly.

### Features
- [x] [Feed-Forward Neural Network](https://github.com/collinhundley/Swift-AI/tree/master/Source#multi-layer-feed-forward-neural-network)
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [ ] Genetic Algorithms
- [ ] Fast Matrix Library
- [ ] Fourier Transform Functions

## Installation
Grab the files you need, drag them into your project. That was easy!

## Compatibility
Swift AI currently depends on Apple's Accelerate framework for vector/matrix calculations and digital signal processing. With Swift becoming open-source later this year, it remains to be seen if additional frameworks will be released as well.

In order to provide support for multiple platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is possible, but SIMD instructions will be preferred for their significant performance boost.

## Notes
Compiler optimizations can greatly enhance the performance of Swift AI. Even the default 'Release' build settings can increase speed by up to 10x, but it is also recommended that Whole Module Optimization be enabled for maximum efficiency.

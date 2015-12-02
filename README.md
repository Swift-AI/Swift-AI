![Swift AI Banner](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/SwiftAI.png?raw=true)

Swift AI is a high-performance AI and Machine Learning library written entirely in Swift.
These tools have been optimized for use in both iOS and OS X applications, with support for more platforms coming soon!

## Features
Swift AI includes a set of common tools used for machine learning and artificial intelligence research. These tools are designed to be flexible yet powerful, and suitable for everything from iOS apps to large-scale AI implementations.

- [x] [Feed-Forward Neural Network](https://github.com/collinhundley/Swift-AI/tree/master/Source#multi-layer-feed-forward-neural-network)
    * 3-layer network with options for customization.
    * [Example projects](https://github.com/collinhundley/Swift-AI/tree/master/Examples#swift-ai-examples) for iOS and OS X.
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [ ] Genetic Algorithms
- [ ] Fast Matrix Library
- [ ] Fourier Transform Functions


## Usage and Examples
We've created [example projects](https://github.com/collinhundley/Swift-AI/tree/master/Examples#swift-ai-examples) to demonstrate the usage and potential applications of Swift AI:
- [iOS](https://github.com/collinhundley/Swift-AI/tree/master/Examples#ios):
    * 2D function regression (feed-forward neural network)
    * Evolution simultaion (genetic algorithm)
- [OS X](https://github.com/collinhundley/Swift-AI/tree/master/Examples#os-x):
    * XOR logic gate modeling (feed-forward neural network)
    * 2D function regression (feed-forward neural network)
- Swift Playground:
    * Graphing - used in conjunction with OS X regression examples


## Installation
Grab the files you need, drag them into your project. That was easy!


## Compatibility
Swift AI currently depends on Apple's [Accelerate](https://developer.apple.com/library/mac/documentation/Accelerate/Reference/AccelerateFWRef/) framework for vector/matrix calculations and digital signal processing. With Swift becoming open-source later this year, it remains to be seen if additional frameworks will be released as well.

In order to provide support for multiple platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is possible, but SIMD instructions will be preferred for their significant performance boost.

## Notes
Compiler optimizations can greatly enhance the performance of Swift AI. Even Xcode's default 'Release' build settings can increase speed by up to 10x, but it is also recommended that [Whole Module Optimization](https://developer.apple.com/swift/blog/?id=27) be enabled for maximum efficiency.

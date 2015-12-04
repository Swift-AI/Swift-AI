[![Swift AI Banner](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Banner.png?raw=true)](https://github.com/collinhundley/Swift-AI#care-enough-to-donate)

Swift AI is a high-performance AI and Machine Learning library written entirely in Swift.
We currently support iOS and OS X, with support for more platforms coming soon!


## Features
Swift AI includes a set of common tools used for machine learning and artificial intelligence research. These tools are designed to be flexible, powerful and suitable for a wide range of applications.

- [x] [Feed-Forward Neural Network](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/FFNN.md#multi-layer-feed-forward-neural-network)
    * 3-layer network with options for customization.
    * [Example projects](https://github.com/collinhundley/Swift-AI/tree/master/Examples#swift-ai-examples) for iOS and OS X.
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [ ] Genetic Algorithms
- [x] [Fast Matrix Library](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/Matrix.md#matrix)
    * Matrix class with methods for common tasks
    * SIMD-accelerated operations
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

>**Why don't we use CocoaPods/Carthage?**

With Swift becoming open-source, we're waiting to see how these dependency managers will cooperate with other platforms. There are benefits and drawbacks to both, but for now it's quite easy to hand-pick the Swift AI classes you want to use. Plus, it saves space and compilation time!

## Compatibility
Swift AI currently depends on Apple's [Accelerate](https://developer.apple.com/library/mac/documentation/Accelerate/Reference/AccelerateFWRef/) framework for vector/matrix calculations and digital signal processing. With Swift becoming open-source later this year, it remains to be seen if additional frameworks will be released as well.

In order to provide support for multiple platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is possible, but SIMD instructions will be preferred for their significant performance boost.


## Care Enough to Donate?

Take a little, give a little. I don't usually like handouts, but time is the biggest constraint. More donations = less contract work = more time building great open-source projects!

>**What good will my money do?**

Your donation will help a college student get through school, and give you a warm, fuzzy feeling. Every contribution is very much appreciated.

[![Donate](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/DonateButton.png?raw=true)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3FCBZ7MXZJFG2&lc=US&item_name=Swift%20AI&currency_code=USD&bn=PP%2dDonationsBF%3aDonateButton%2epng%3fraw%3dtrue%3aNonHosted)



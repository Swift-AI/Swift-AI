![Swift AI Banner](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/SwiftAI.png?raw=true)

Swift AI is a high-performance AI and Machine Learning library written entirely in Swift.
We currently support iOS and OS X, with support for more platforms coming soon!


## Features
Swift AI includes a set of common tools used for machine learning and artificial intelligence research. These tools are designed to be flexible, powerful and suitable for a wide range of applications.

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


## Care Enough to Donate?

Take a little, give a little. This is your chance to make a difference!

>**What good will my donation do?**

Your money will help put a college student through school. More donations = less contract work = more time building great open-source projects!

[![Donate](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/DonateButton.png?raw=true)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3FCBZ7MXZJFG2&lc=US&item_name=Swift%20AI%20Development&currency_code=USD&bn=PP%2dDonationsBF%3aDonateButton%2epng%3fraw%3dtrue%3aNonHosted)



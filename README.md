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
    * [NSGA-II] (http://www.iitk.ac.in/kangal/Deb_NSGA-II.pdf)
- [x] [Fast Matrix Library](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/Matrix.md#matrix)
    * Matrix class with common operators
    * SIMD-accelerated operations
- [ ] Fourier Transform Functions


## Usage and Examples
We've created [example projects](https://github.com/collinhundley/Swift-AI/tree/master/Examples#swift-ai-examples) to demonstrate the usage and potential applications of Swift AI:
- [iOS](https://github.com/collinhundley/Swift-AI/tree/master/Examples#ios):
    * 2D function regression (feed-forward neural network)
    * Handwriting recognition (feed-forward neural network)
    * Evolution simultaion (genetic algorithm)
- [OS X](https://github.com/collinhundley/Swift-AI/tree/master/Examples#os-x):
    * XOR logic gate modeling (feed-forward neural network)
    * 2D function regression (feed-forward neural network)
- Swift Playground:
    * Graphing - used in conjunction with OS X regression examples


## Installation
Grab the files you need, drag them into your project. That was easy!

>**Why don't we use CocoaPods/Carthage?**

Swift is open-source now, and it remains to be seen how these dependency managers will cooperate with other platforms.

A better alternative will probably be the [Swift Package Manager](https://swift.org/package-manager/).

## Compatibility
Swift AI currently depends on Apple's [Accelerate](https://developer.apple.com/library/mac/documentation/Accelerate/Reference/AccelerateFWRef/) framework for vector/matrix calculations and digital signal processing.

In order to provide support for more platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is one possibility, but SIMD instructions will be preferred for their significant performance boost. Check back for more updates on this soon.

## Using Swift AI?
If you're using Swift AI in one of your own projects, let us know! We'll add a link to your profile/website/app right here on the front page.

## Contributing
Contributions to the project are welcome. Please review the [documentation](https://github.com/collinhundley/Swift-AI/tree/master/Documentation) before submitting a pull request, and strive to maintain consistency with the structure and formatting of existing code. Official guidelines with more details will be provided soon.

## Care Enough to Donate?

Take a little, give a little. I don't usually like handouts, but time is a big constraint. More donations = less contract work = more time building great open-source projects!

>**What good will my money do?**

Your donation will help a college student get through school, and give you a warm, fuzzy feeling. Every contribution is appreciated.

[![Donate](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/DonateButton.png?raw=true)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3FCBZ7MXZJFG2&lc=US&item_name=Swift%20AI&currency_code=USD&bn=PP%2dDonationsBF%3aDonateButton%2epng%3fraw%3dtrue%3aNonHosted)



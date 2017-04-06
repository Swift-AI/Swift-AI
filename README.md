[![Swift AI Banner](https://github.com/
hundley/Swift-AI/blob/master/SiteAssets/Banner.png?raw=true)](https://github.com/Swift-AI/Swift-AI#help-us-grow)

Swift AI is a high-performance machine learning library written entirely in Swift.
We currently support macOS, iOS and tvOS, with support for more platforms coming soon!

## Update 4/4/17
I'm in the process of bringing some major updates to Swift AI, but in the meantime you might find some inconsistencies in this documentation. I appreciate all your help and patience! If you'd like to help make these changes possible, consider making a [donation](https://github.com/Swift-AI/Swift-AI#help-us-grow).


## Features
Swift AI includes a set of common tools used for machine learning and artificial intelligence. These tools are designed to be flexible, powerful and suitable for a wide range of applications.

- [x] [Feed-Forward Neural Network](https://github.com/Swift-AI/NeuralNet)
    * 3-layer network with options for customization.
    * [Example projects](https://github.com/Swift-AI/Swift-AI/blob/master/Documentation/Examples.md) for iOS and macOS.
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [ ] Genetic Algorithms
- [ ] Fast Matrix Library
    * Matrix class supporting common operators
    * SIMD-accelerated operations
- [ ] Fourier Transform Functions


## What It's For

> "This is a really *cool* project, but what can I actually do with it? I know nothing about A.I."

I get this question a lot, so I want to address it here:

Swift AI focuses on a useful branch of artificial intelligence known as *machine learning*: the science of training computers to take actions without explicit programming. Used appropriately, these tools can give your applications abilities that would normally be impossible or *unrealistic* using conventional programming techniques.

As an example, consider an app that recognizes handwritten letters on a piece of paper: using the computer science you learned in school, you might be tempted to write each of the rules for classifying each character individually. This would consist of extracting pixel data from the image, reading them in individually, and writing an *extremely* complicated mathematical model that relates pixel darkness/position into a probability for the letter `A`, and then likewise for `B`, `C`, `D`, etc. Sound fun? Here's what your program might eventually look like:

```
if /* massive function for checking the letter A */ {
    return "A"
} else if /* massive, completely unique function for checking the letter B */ { 
    return "B"
} else if ...
```

Hopefully you've realized by now that this method simply isn't feasible. In the best case scenario, you might end up with thousands of lines of very unreliable code for recognizing only *your* exact handwriting. In comparison, Swift AI's [iOS example app](https://github.com/Swift-AI/Swift-AI/tree/master/Documentation/Examples.md#ios) demonstrates how far superior functionality can be accomplished with very few lines of code, using machine learning. And requiring exactly *zero* explicit rules to be written by the developer.

>**So how can Swift AI be used in the real world?**

Here are a few ideas to get you started:
- Handwriting recognition
- Gesture recognition
- Facial detection
- Drone stabilization and navigation systems
- Predicting and identifying medical conditions
- Song identification
- Speech recognition
- Video game AI
- Weather forecasting
- Fraud detection
- [Building smart robots!](https://www.youtube.com/watch?v=99DOwLcbKl8)


## Usage and Examples

Please see the [documentation](https://github.com/Swift-AI/Swift-AI/tree/master/Documentation) for detailed instructions on how to use the various components of Swift AI.

We've also created [example projects](https://github.com/Swift-AI/Swift-AI/tree/master/Documentation/Examples.md) to demonstrate the usage and potential applications of this library:
- [iOS](https://github.com/Swift-AI/Swift-AI/tree/master/Documentation/Examples.md#ios):
    * 2D function regression (feed-forward neural network)
    * Handwriting recognition (feed-forward neural network)
    * Evolution simulation (genetic algorithm)
- [macOS](https://github.com/Swift-AI/Swift-AI/tree/master/Documentation/Examples.md#macos):
    * XOR logic gate modeling (feed-forward neural network)
    * 2D function regression (feed-forward neural network)
    * Trainer for iOS handwriting recognizer (feed-forward neural network)
- Swift Playground:
    * Graphing - used in conjunction with macOS regression examples


## Installation
Grab the files you need, drag them into your project. That was easy!

>**Why don't we use CocoaPods/Carthage?**

Because we're migrating to the [Swift Package Manager](https://swift.org/package-manager/).

## Compatibility
Swift AI currently depends on Apple's [Accelerate](https://developer.apple.com/library/mac/documentation/Accelerate/Reference/AccelerateFWRef/) framework for vector/matrix calculations and digital signal processing.

In order to provide support for more platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is one possibility, but SIMD instructions will be preferred for their significant performance boost. Check back for more updates on this soon.

## Using Swift AI?
If you're using Swift AI in one of your own projects, let me know! I'll add a link to your profile/website/app right here on the front page. Feel free to email me at the address shown below.

- [SwiftOCR](https://github.com/garnele007/SwiftOCR)

## Contributing
Contributions to the project are welcome. Please review the [documentation](https://github.com/Swift-AI/Swift-AI/tree/master/Documentation) before submitting a pull request, and strive to maintain consistency with the structure and formatting of existing code. Official guidelines with more details will be provided soon.

## Contact
I build all things Swift - from iOS apps to cloud computing. You can reach me here:

![Email](https://github.com/Swift-AI/Swift-AI/blob/master/SiteAssets/Email.png?raw=true)

## Help us grow!
Building free software isn't always free. All contributions are greatly appreciated.

[![Donate](https://github.com/Swift-AI/Swift-AI/blob/master/SiteAssets/DonateButton.png?raw=true)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3FCBZ7MXZJFG2&lc=US&item_name=Swift%20AI&currency_code=USD&bn=PP%2dDonationsBF%3aDonateButton%2epng%3fraw%3dtrue%3aNonHosted)



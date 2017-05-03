![Banner](https://github.com/Swift-AI/Swift-AI/blob/master/SiteAssets/banner.png)

Swift AI is a high-performance deep learning library written entirely in Swift. We currently offer support for all Apple platforms, with Linux support coming soon.

## Tools
Swift AI includes a collection of common tools used for artificial intelligence and scientific applications:

 - [x] [NeuralNet](https://github.com/Swift-AI/NeuralNet)
    * A flexible, fully-connected neural network with support for deep learning
    * Optimized specifically for Apple hardware, using advanced parallel processing techniques
 - [ ] Convolutional Neural Network
 - [ ] Recurrent Neural Network
 - [ ] Genetic Algorithm Library
 - [ ] Fast Linear Algebra Library
 - [ ] Signal Processing Library

## Example Projects
We've created some example projects to demonstrate the usage of Swift AI. Each resides in their own repository and can be built with little or no configuration:

 - [NeuralNet-MNIST](https://github.com/Swift-AI/NeuralNet-MNIST)
    * A [NeuralNet](https://github.com/Swift-AI/NeuralNet) training example for the [MNIST](http://yann.lecun.com/exdb/mnist/) handwriting database
    * Trains a neural network to recognize handwritten digits
    * Built for macOS
 - [NeuralNet-Handwriting-iOS](https://github.com/Swift-AI/NeuralNet-Handwriting-iOS)
    * A demo for handwriting recognition using [NeuralNet](https://github.com/Swift-AI/NeuralNet)
    * Pre-trained; just download and run
    * Built for iOS

## Usage
Each module now contains its own documentation. We recommend that you read the docs carefully for detailed instructions on using the various components of Swift AI.

The example projects are another great resource for seeing real-world usage of these tools.

## Compatibility
Swift AI currently depends on Apple's [Accelerate](https://developer.apple.com/library/mac/documentation/Accelerate/Reference/AccelerateFWRef/) framework for vector/matrix calculations and digital signal processing.

In order to provide support for more platforms, alternative BLAS solutions are being considered.

## Contributing
Contributions to the project are welcome. We simply ask that you strive to maintain consistency with the structure and formatting of existing code.

## Contact
[Collin Hundley](https://github.com/collinhundley) is the author and maintainer of Swift AI. Feel free contact him directly via [email](mailto:collinhundley@gmail.com).

If you have a question about this library or are looking for guidance, we recommend [opening an issue](https://github.com/Swift-AI/Swift-AI/issues/new) so a member of the community can help!

## Consulting
If you're looking for for help with deep learning, computer vision, signal processing or other AI applications, you've come to the right place! Contact [Collin](https://github.com/collinhundley) for more information about consulting/contracting.

## Donating
Your donation to Swift AI will help us continue building excellent open-source tools. All contributions are appreciated!

[![Donate](https://github.com/Swift-AI/Swift-AI/blob/master/SiteAssets/donate.png)](https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=3FCBZ7MXZJFG2&lc=US&item_name=Swift%20AI&currency_code=USD&bn=PP%2dDonationsBF%3aDonateButton%2epng%3fraw%3dtrue%3aNonHosted)

[![Swift AI Banner](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Banner.png?raw=true)](https://github.com/collinhundley/Swift-AI#care-enough-to-donate)

# Examples
This collection of example projects has been prepared to demonstrate real-world usage of Swift AI.  If you have more ideas, open an [issue](https://github.com/collinhundley/Swift-AI/issues) or submit a [pull request](https://github.com/collinhundley/Swift-AI/pulls).  We'd love to hear your feedback!

## iOS
The Swift AI iOS app serves two purposes:
- Provide visual representations of the "learning" process involved in machine learning.
- Demonstrate the possibilities of integrating artificial intelligence into iOS apps.

**Important:** This app has been optimized for iPhone6/6s/+, and also supports iPhone 5/5s. I make no guarantee regarding compatibility with iPhone 4s, and it's likely that performance will suffer.

**iOS Simulator:** I recommend that you always build to a real iOS device, as some examples won't work well on the Simulator. These include examples requiring high graphics performance (such as Regression), examples using gestures (Handwriting), and any examples requiring the camera.

### Regression
##### Feed-Forward Neural Network

A neural network can perform a regression for any arbitrary function. This example shows how [FFNN](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/FFNN.md#multi-layer-feed-forward-neural-network) can "learn" the sine function using backpropagation.

![Sine.gif](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Sine.gif?raw=true)

> **What's happening?**

The green waveform represents the 'target' function - the one that we'd like to model. The red waveform represents the neural network's output. Over time, the network's output gets closer to the actual function as its error approaches zero. What you're seeing is a realtime update of the neural network's progress as it "learns" on your device.

> **How do I use it?**

You can control the target function by adjusting the slider:

![Sine-Slider.gif](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Sine-Slider.gif?raw=true) ![Sine-Slider2.gif](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Sine-Slider2.gif?raw=true)

- Tap 'Start' to begin the training process and view the network's progress - live!
- Tap 'Pause' to pause the training.
- Tap 'Reset' to completely reset the neural network with new, randomly-generated weights. This discards any training that has happened previously.
- Tap 'Info' for more information.

> **How does it work?**

Initially, you're given a randomly-generated neural network. Tapping 'Start' initiates a training process, which consists of two phases:
- **Update**: For every `x` position on the graph, the neural network is asked to make its 'best guess' for the corresponding `y` value. These points are plotted in red on the screen.
- **Backpropagation**: For every `x` position, the network's output `y` is compared to the 'target' value. The resulting error is propagated through the network and its weights are adjusted accordingly (more details in the [documentation](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/FFNN.md#training)).

Within a few seconds, the network is able to "learn" a good approximation of the target function. Note that the target values are never actually stored by the neural network - rather, it uses them to learn by example.

> **Mine got stuck!**

Yeah, that can happen. It's called a local minimum:

![LocalMinimum](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/LocalMinima.gif?raw=true).

A good [learning rate and momentum factor](https://github.com/collinhundley/Swift-AI/blob/master/Documentation/FFNN.md#standard) can help prevent that, but for this simple example it's best to just reset the network.

### Handwriting
##### Feed-Forward Neural Network

This example shows how an artificial neural network can be trained to recognize handwritten digits.

![Handwriting](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Handwriting.png?raw=true)

Draw a on the canvas with your finger, and the neural net will attempt to classify the character drawn. Here's how it works:

- The image that you create is first rasterized and downscaled to a resolution of 28x28. This downscaled image is shown on the bottom left of the screen, so you have an idea of what the neural network is actually "seeing."

> Why downscale the image?

  * The less information you feed a neural network, the less prone it is to error. Imagine that you're teaching a child basic arithmetic: they're more likely to succeed if you only give them exactly the information they need (addition, subtraction, multiplication, division) than if you discuss the theory of multivariate calculus. Reducing the number of pixels in our image reduces the *dimensionality* of our data, allowing the neural net to learn more efficiently. 28x28 happens to be a good size so that our dataset is much smaller, but the characters are still totally recognizable.
    
- The app has been packaged with a pre-trained neural network. It was trained with the [MNIST dataset](http://yann.lecun.com/exdb/mnist/), and as such it can only recognize handwritten **digits (0-9)**. It could easily be trained to recognize alphabetic characters, symbols, emojis, etc., but the MNIST data was readily available and it's sufficient for this small demonstration.
  * The trainer for this neural network is included in the [OS X app](https://github.com/collinhundley/Swift-AI/tree/master/Examples#os-x), so you're free to train it yourself and even use a different set of data.
    
- For each drawing given, the neural network is *forced* to classify it as a number between 0 and 9. So of course, sketching a letter, a smiley-face or an octopus isn't going to give you good results. With each classification, the level of confidence is shown beneath the output.


### Evolution

##### Genetic Algorithm

Genetic algorithm example coming soon!


### Additional Notes

> **What's this 'APKit' framework?**

APKit is a framework for creating views programmatically using Auto Layout, and contains abstractions for many common animation tasks.  It has no direct effect on Swift AI's implementation.


## OS X

Some information about the OS X project will go here :)

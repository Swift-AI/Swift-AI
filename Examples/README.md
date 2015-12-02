# Swift AI Examples
This collection of example projects has been prepared to demonstrate real-world usage of Swift AI.  If you have more ideas, open an [issue](https://github.com/collinhundley/Swift-AI/issues) or submit a [pull request](https://github.com/collinhundley/Swift-AI/pulls).  We'd love to hear your feedback!

## iOS
The Swift AI iOS app serves two purposes:
- Provide visual representations of the "learning" process involved in machine learning.
- Demonstrate the possibilities of integrating artificial intelligence into iOS apps.

The following examples are included in the app:

### Regression
##### Feed-Forward Neural Network

A neural network can perform a regression for any arbitrary function. This example shows how [FFNN](https://github.com/collinhundley/Swift-AI/tree/master/Source#multi-layer-feed-forward-neural-network) can "learn" the sine function using backpropagation.

![Sine.gif](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Sine.gif?raw=true)

> **What's happening?**

The green waveform represents the 'target' function - the one that we'd like to model. The red waveform represents the neural network's output. Over time, the network's output gets closer to the actual function as its error approaches zero. What you're seeing is a realtime update of the neural network's progress as it "learns" on your device.

> **How do I use it?**

You can control the target function by adjusting the slider:

![Sune-Sider.gif](https://github.com/collinhundley/Swift-AI/blob/master/SiteAssets/Sine-Slider.gif?raw=true)

- Tap 'Start' to begin the training process and view the network's progress - live!
- Tap 'Pause' to pause the training.
- Tap 'Reset' to completely reset the neural network with new, randomly-generated weights. This discards any training that has happened previously.

> **How does it work?**

Initially, you're given a randomly-generated neural network. Tapping 'Start' initiates a training process, which consists of two phases:
- **Update**: For every `x` position on the graph, the neural network is asked to make its 'best guess' for the corresponding `y` value. These points are plotted in red on the screen.
- **Backpropagation**: For every `x` position, the network's output `y` is compared to the 'target' value. The resulting error is propagated through the network and its weights are adjusted accordingly (more details in the [documentation](https://github.com/collinhundley/Swift-AI/tree/master/Source#training)).

Within a few seconds, the network is able to "learn" a good approximation of the target function. Note that the 'target' values are never actually stored by the neural network - rather, it uses them to learn by example.

> **Mine got stuck!**

Yeah, that can happen. It's called a [local minimum](http://mnemstudio.org/ai/nn/images/minima1.gif). A good [learning rate and momentum factor](https://github.com/collinhundley/Swift-AI/tree/master/Source#standard) can help prevent that, but for this app it's best to just reset the network.

### Evolution

##### Genetic Algorithm

Genetic algorithm example coming soon!


### Additional Notes

> **What's this 'APKit' framework?**

APKit is a framework for creating views programmatically using Auto Layout, and contains abstractions for many common animation tasks.  It has no direct effect on Swift AI's implementation.


## OS X

Some information about the OS X project will go here :)

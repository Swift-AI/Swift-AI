# Swift AI
Swift AI is a high-performance AI and Machine Learning library written entirely in Swift.
These tools have been optimized for use in both iOS and OS X applications, with support for more platforms coming soon!

This library is a work in progress, so more features will be added shortly.

### Features
- [x] Feed-Forward Neural Network
- [ ] Recurrent Neural Network
- [ ] Convolutional Network
- [ ] GPU-Accelerated Networks
- [ ] Genetic Algorithms
- [ ] Fast Matrix Library
- [ ] Fourier Transform Functions

## Installation
Pick the files you need, drag them into your project. That was easy!

## Usage

#### Multi-Layer Feed-Forward Neural Network
###### FFNN.swift
The `FFNN` class contains a fully-connected, 3-layer feed-forward neural network.  This neural net uses a standard backpropagation training algorithm (stochastic gradient descent), and is designed for flexibility and use in performance-critical applications.

It's fast, lightweight and perfect for use with both OS X and iOS!

Creating an `FFNN` instance is easy...

```
  let network = FFNN(inputs: 100, hidden: 64, outputs: 10,
                learningRate: 0.7, momentum: 0.4, weights: nil)
```
You must provide six parameters to the initializer:
- `inputs`: The number of input nodes (aka, 'neurons'). This number corresponds to the dimensionality of the data that you plan to feed the network. If the above example were to be used for handwriting recognition, `100` might be the number of pixels in each image being processed.
- `hidden`: The number of nodes in the hidden layer. The ideal number of hidden nodes depends heavily on the application, and should be determined by testing. If you're completely unsure, [(inputs * 2/3) + outputs] may be a good place to start.
- `outputs`: The number of output nodes. For classification problems (like recognizing handwritten digits), the number of outputs usually corresponds to the number of possible classifications. In this example, each output might correspond to one digit (0-9). The number of outputs depends entirely on the problem being applied.
- `learningRate`: The 'learning rate' to apply during the backpropagation phase of training. If you're unsure what this means, `0.7` is probably a good number.
- `momentum`: Another constant applied during backpropagation. If you're not sure, try `0.4`.
- `weights`: An optional array of `Float`s used to initialize the weights of the neural network. This allows you to 'clone' a pre-trained network, so that it's immediately prepared to solve problems without training first. When you're creating a new network from scratch, leave this parameter `nil` and random weights will calculated based on your input data.

You interact with your neural net using these five methods:
(More information can be found in the documentation as well)

**update** - Accepts a single set of input data, and returns the resulting output as calculated by the neural net.
```
let output: [Float] = try network.update(inputs: imagePixels)
```

**backpropagate** - Used to train the network manually. Accepts the single set of expected outputs (aka 'answers') corresponding to the most `update` call. Returns the total error, as calculated from the difference between the expected and actual outputs.
```
let error: Float = try network.backpropagate(answer: correctAnswer)
```

**train** - Initiates an automated training process on the neural network. Accepts all sets of inputs and corresponding answers to use during the training process and all sets of inputs and answers to be used for network validation, as well as an error threshold to determine when a sufficient solution has been found.

The validation data (`testInputs` and `testAnswers`) will NOT be used to train the network, but will be used to test the network's progress periodically. Once the desired error threshold on the validation data has been reached, the training will stop. An appropriate error threshold should take into account the number of validation sets, as error is accumulated over all sets of data. Ideally, the validation data should be randomly selected and representative of the entire search space.

Note: this method will block the calling thread until it is finished, but may safely be dispatched to a background queue.

```
let weights = try network.train(inputs: allImages, answers: allAnswers,
              testInputs: validationImages, testAnswers: validationAnswers,
              errorThreshold: 0.2)
```

**getWeights** - Returns a serialized array of the network's current weights.
```
let weights = network.getWeights()
```

**resetWithWeights** - Allows the user to reset the network with new specific weights. Accepts a serialized array of weights, as returned by the `getWeights()` method.
```
try network.resetWithWeights(preTrainedWeights)
```

##### Additional Information:
To achieve nonlinearity, `FFNN` uses the [sigmoid](https://en.wikipedia.org/wiki/Sigmoid_function) activation function for hidden and output nodes. Because of this property, you will achieve better results if the following points are taken into consideration:
- Input data should be [normalized](https://visualstudiomagazine.com/articles/2014/01/01/how-to-standardize-data-for-neural-networks.aspx) to have a mean of `0` and standard deviation of `1`.
- Outputs will always reside in the range (0, 1). For regression problems, a wider range is often needed and thus the outputs must be scaled accordingly.
- When providing 'answers' for backpropagation, this data must be scaled in reverse so that all outputs also reside in the range (0, 1).


## Compatibility
Swift AI currently depends on Apple's Accelerate framework for vector/matrix calculations and digital signal processing. With Swift becoming open-source later this year, it remains to be seen if additional frameworks will be released as well.

In order to provide support for multiple platforms (Linux, Windows, etc.), alternative BLAS solutions are being considered. A vanilla Swift implementation is possible, but SIMD instructions will be preferred for their significant performance boost.

## Notes
Compiler optimizations can greatly enhance the performance of Swift AI. Even the default 'Release' build settings can increase speed by up to 10x, but it is also recommended that Whole Module Optimization be enabled for maximum efficiency.

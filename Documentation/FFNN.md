
# Multi-Layer Feed-Forward Neural Network
###### FFNN.swift
The `FFNN` class contains a fully-connected, 3-layer feed-forward neural network.  This neural net uses a standard backpropagation training algorithm (stochastic gradient descent), and is designed for flexibility and use in performance-critical applications.

## Initialization

#### Standard
Creating an `FFNN` instance is easy...

```
let network = FFNN(inputs: 100, hidden: 64, outputs: 10,
learningRate: 0.7, momentum: 0.4, weights: nil,
activationFunction : .Sigmoid, errorFunction: .CrossEntropy(average: false))
```
You must provide eight parameters to the initializer:
- `inputs`: The number of input nodes (aka 'neurons'). This number corresponds to the dimensionality of the data that you plan to feed the network. If the above example were to be used for handwriting recognition, `100` might be the number of pixels in each image being processed.
- `hidden`: The number of nodes in the hidden layer. The ideal number of hidden nodes depends heavily on the application, and should be determined by testing. If you're completely unsure, [(inputs * 2/3) + outputs] might be a good place to start.
- `outputs`: The number of output nodes. For classification problems (like recognizing handwritten digits), the number of outputs usually corresponds to the number of possible classifications. In this example, each output might correspond to one digit (0-9). The number of outputs depends entirely on the problem being applied.
- `learningRate`: The 'learning rate' to apply during the backpropagation phase of training. If you're unsure what this means, `0.7` is probably a good number.
- `momentum`: Another constant applied during backpropagation. If you're not sure, try `0.4`.
- `weights`: An optional array of `Float`s used to initialize the weights of the neural network. This allows you to 'clone' a pre-trained network, and begin solving problems without training first. When you're creating a new network from scratch, leave this parameter `nil` and random weights will calculated based on your input data.
- `activationFunction`: One of the supported `ActivationFunction`s to apply to the hidden and output nodes.
- `errorFunction`: One of the supported `ErrorFunction`s for calculating error on a validation set during training.


#### From File
Alternatively, the following methods may be used to read/write a neural network from disk:

- `fromFile` - A static method used to initialize a `FFNN` from file. This is the easiest way to package an application with a pre-trained neural network.

This method accepts either an `NSURL` with the full filepath, or a `String` specifying only the filename. When a filename is given, it is assumed that the file resides in the user's default documents directory. This file will usually have been generated using the `writeToFile()` method below.
```
let network = FFNN.fromFile(fileURL)
```

- `writeToFile` - Writes the current state of the `FFNN` to the specified file. This includes the structure of the neural network itself, all of its current weights (preserving any training that has been performed), and all parameters (such as learning rate, activation function, etc.) that have been set.

As with `fromFile()`, this method accepts either an `NSURL` for a custom filepath, or a `String` with the desired filename to reside in the user's default documents directory.
```
network.writeToFile(fileURL)
```

## Updating

You update your `FFNN` using this method:

- `update` - Accepts a single set of input data, and returns the resulting output as calculated by the neural net.
```
let output: [Float] = try network.update(inputs: imagePixels)
```

## Training

You train `FFNN` using the following methods:

- `backpropagate` - Used to train the network manually. Accepts the single set of expected outputs (aka 'answers') corresponding to the most recent `update` call. Returns the total error, as calculated from the difference between the expected and actual outputs.
```
let error: Float = try network.backpropagate(answer: correctAnswer)
```

- `train` - Initiates an automated training process on the neural network. Accepts all sets of inputs and corresponding answers to use during the training process and all sets of inputs and answers to be used for network validation, as well as an error threshold to determine when a sufficient solution has been found.

The validation data (`testInputs` and `testAnswers`) will NOT be used to train the network, but will be used to test the network's progress periodically. Once the desired error threshold on the validation data has been reached, the training will stop. Ideally, the validation data should be randomly selected and representative of the entire search space.

Note: this method will block the calling thread until it is finished, but may safely be dispatched to a background queue.

```
let weights = try network.train(inputs: allImages, answers: allAnswers,
testInputs: validationImages, testAnswers: validationAnswers,
errorThreshold: 0.2)
```

## Modifying

A few methods and properties are provided to modify the state of the neural network:

- `getWeights` - Returns a serialized array of the network's current weights.
```
let weights = network.getWeights()
```

- `resetWithWeights` - Allows the user to reset the network with specified weights. Accepts a serialized array of weights, as returned by the `getWeights()` method.
```
try network.resetWithWeights(preTrainedWeights)
```

Additionally, `learningRate` and `momentumFactor` are both mutable properties on `FFNN` that may be safely tuned at any time.


## Additional Information
To achieve nonlinearity, `FFNN` uses a one of several activation functions for hidden and output nodes, as configured during initialization. Because of this property, you will achieve better results if the following points are taken into consideration:
- Input data should generally be [normalized](https://visualstudiomagazine.com/articles/2014/01/01/how-to-standardize-data-for-neural-networks.aspx) to have a mean of `0` and standard deviation of `1`.
- Except in the case of Linear activation, outputs will always reside in the range (0, 1). For regression problems, a wider range is often needed and thus the outputs must be scaled accordingly.
- When providing 'answers' for backpropagation, this data must be scaled in reverse so that all outputs also reside in the range (0, 1).  Again, this does not apply to networks using linear activation functions.

[Softmax](https://en.wikipedia.org/wiki/Softmax_function) activation will be added soon.

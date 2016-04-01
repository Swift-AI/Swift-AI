//
//  HandwritingLearnViewController.swift
//  Swift-AI-iOS
//
//  Created by Collin Hundley on 12/18/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import UIKit

class HandwritingLearnViewController: UIViewController {
    
    var network: FFNN!
    
    let handwritingLearnView = HandwritingLearnView()
    
    override func loadView() {
        self.view = self.handwritingLearnView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSBundle.mainBundle().URLForResource("handwriting-learn-ffnn", withExtension: nil)!
        self.network = FFNN.fromFile(url)
        
        self.handwritingLearnView.textField.delegate = self
        self.handwritingLearnView.textField.addTarget(self, action: #selector(textChanged), forControlEvents: .EditingChanged)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.handwritingLearnView.textField.keyboardType = .NumberPad
        self.handwritingLearnView.textField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.handwritingLearnView.textField.resignFirstResponder()
    }
    
}

// MARK: Neural network and drawing methods

extension HandwritingLearnViewController {
    
    private func generateCharacter(digit: Int) {
        guard let inputArray = self.digitToArray(digit) else {
            print("Error: Invalid digit: \(digit)")
            return
        }
        do {
            let output = try self.network.update(inputs: inputArray)
            let image = self.pixelsToImage(output)
            self.handwritingLearnView.canvas.image = image
        } catch {
            print(error)
        }
    }
    
    private func pixelsToImage(pixelFloats: [Float]) -> UIImage? {
        guard pixelFloats.count == 784 else {
            print("Error: Invalid number of pixels given: \(pixelFloats.count). Expected: 784")
            return nil
        }
        struct PixelData {
            let a: UInt8
            let r: UInt8
            let g: UInt8
            let b: UInt8
        }
        var pixels = [PixelData]()
        for pixelFloat in pixelFloats {
            pixels.append(PixelData(a: UInt8(pixelFloat * 255), r: 0, g: 0, b: 0))
        }
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)
        var data = pixels
        let providerRef = CGDataProviderCreateWithCFData(NSData(bytes: &data, length: data.count * sizeof(PixelData)))
        let cgim = CGImageCreate(28, 28, 8, 32, 28 * sizeof(PixelData), rgbColorSpace, bitmapInfo, providerRef, nil, true, CGColorRenderingIntent.RenderingIntentDefault)
        return UIImage(CGImage: cgim!)
    }
    
    
    private func digitToArray(digit: Int) -> [Float]? {
        guard digit >= 0 && digit <= 9 else {
            return nil
        }
        var array = [Float](count: 10, repeatedValue: 0)
        array[digit] = 1
        return array
    }
    
}



extension HandwritingLearnViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.handwritingLearnView.textField.text = ""
        return true
    }
    
    func textChanged(sender: UITextField) {
        if let digit = Int(self.handwritingLearnView.textField.text!) {
            self.generateCharacter(digit)
        }
        self.handwritingLearnView.textField.resignFirstResponder()
    }
    
}

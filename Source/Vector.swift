//
//  Vector.swift
//  Swift-AI-OSX
//
//  Created by Collin Hundley on 12/2/15.
//

import Accelerate


public class Vector {
    
    /// The vector as an array of `Double`.
    var flat = [Double]()
    
    /// Converts the receiver into a `Matrix` with one row and `size` columns.
    public var matrixView: Matrix {
        get {
            let m = Matrix(rows: 1, columns: self.size)
            m.flat.flat = self.flat
            return m
        }
    }
    
    /// The size of the vector (total number of elements).
    public var size: Int {
        get {
            return self.flat.count
        }
    }
    
    /// The textual representation of the vector.
    public var description: String {
        get {
            return self.flat.description
        }
    }
    
    public init(size: Int) {
        self.flat = [Double](repeating: 0.0, count: size)
    }
    
    /// Returns/sets the element value at the given index.
    public subscript(index: Int) -> Double {
        get {
            return self.flat[index]
        }
        set(value){
            self.flat[index] = value
        }
    }
    
    // TODO: Finish this.
    /// Computes the dot product of the receiver with another vector.
    public func dot(v: Vector) -> Double {
        var c: Double = 0.0
        vDSP_dotprD(self.flat, 1, self.flat, 1, &c, vDSP_Length(self.size))
        return 0.0
    }
    
    /// Returns a new `Vector` that is a copy of the receiver.
    public func copy() -> Vector {
        let v = Vector(size: self.size)
        v.flat = self.flat
        return v
    }
    
}

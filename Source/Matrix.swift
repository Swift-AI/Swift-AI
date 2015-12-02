//
//  Matrix.swift
//  Matrix
//
//  Created by Andrea Tullis on 30/11/15.
//  Copyright © 2015 Andrea Tullis. All rights reserved.
//

import Foundation
import Accelerate




public class Matrix {
    
    public let columns : Int
    public let rows : Int
    public let shape : (Int,Int)
    let n : Int
    var flat : Vector
    
    var vectorview: Vector {
        get {
            return self.flat
        }
    }
    // Select row vector from matrix
    public func row(index: Int) -> Vector {
        var v = self.flat.flat
        var r = [Double](count: self.columns, repeatedValue: 0)
        for column in 0..<self.columns
        {
            let position = index * self.columns + column
            r[column]=v[position]
        }
        
        let vector = Vector(size: r.count)
        vector.flat = r
        return vector
    }
    // Select column vector from matrix
    public func column(index: Int) -> Vector{
        var v = self.flat.flat
        var c = [Double](count: self.rows, repeatedValue: 0)
        for row in 0..<self.rows
        {
            let position = index + row * self.columns
            c[row]=v[position]
        }
        
        let vector = Vector(size: c.count)
        vector.flat = c
        return vector

    }
 
    public var description : String {
        get {
            return self.flat.flat.description
        }
    }
    
    public var transpose : Matrix {
        get {
            let m = Matrix(rows: self.columns, columns: self.rows)
            vDSP_mtransD(self.flat.flat,1, &m.flat.flat,1, vDSP_Length(self.rows), vDSP_Length(self.columns))
            m.flat = self.flat
            return m
        }
    }
    
    public init(rows: Int, columns: Int){
        
        self.columns = columns
        self.rows = rows
        self.shape = (rows,columns)
        self.n = columns * rows
        self.flat = Vector(size: self.n)
        
    }
    
    public subscript(row: Int, column: Int) -> Double { get{
        
            return self.flat.flat[row*self.columns + column]
        }
        set(newValue) {
            self.flat.flat[row*self.columns + column] = newValue
        }
    }
    
    public func copy() -> Matrix {
        let c = Matrix(rows: self.rows, columns: self.columns)
        c.flat = self.flat.copy()
        return c
    }
    
    
}


public class Vector {
    
    var flat = [Double]()

    public var matrixview : Matrix {
        get {
            let m = Matrix(rows: 1, columns: self.size)
            m.flat.flat = self.flat
            return m
        }
    }
    
    public var size: Int { get {
        return flat.count
        }
    }
    
    public var description : String {
        get{
            return self.flat.description
        }
    }
    
    // Computes the dot product of the vector with another vector
    public func dot(v: Vector) -> Double {
        var c : Double = 0.0
        vDSP_dotprD(self.flat, 1, self.flat, 1, &c, vDSP_Length(self.size))
        return 0.0
    }
    // Returns/sets the element value at the given index
    public subscript(index: Int) -> Double {
        get {
            return self.flat[index]
        }
        set(value){
            self.flat[index] = value
        }
    }
    // Returns a new object instance that is a copy of the current vector
    public func copy() -> Vector {
        let v = Vector(size: self.size)
        v.flat = self.flat
        return v
    }

    
    public init(size: Int){
        self.flat = [Double](count: size, repeatedValue: 0.0)
    }
    

    
}
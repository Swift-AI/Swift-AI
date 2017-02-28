//
//  Matrix.swift
//  Matrix
//
//  Created by Andrea Tullis on 30/11/15.
//

import Accelerate

public class Matrix {
    
    public let columns: Int
    public let rows: Int
    public let shape: (Int, Int)
    public let size: Int
    var flat: Vector
    
    public var vectorView: Vector {
        get {
            return self.flat
        }
    }
    
    public var description: String {
        get {
            return self.flat.flat.description
        }
    }
    
    public var transpose: Matrix {
        get {
            let m = Matrix(rows: self.columns, columns: self.rows)
            vDSP_mtransD(self.flat.flat, 1, &m.flat.flat, 1, vDSP_Length(self.rows), vDSP_Length(self.columns))
            return m
        }
    }
    
    public init(rows: Int, columns: Int) {
        self.columns = columns
        self.rows = rows
        self.shape = (rows, columns)
        self.size = columns * rows
        self.flat = Vector(size: self.size)
    }
    
    /// Returns/sets the item at the given row and column index.
    public subscript(row: Int, column: Int) -> Double {
        get {
            return self.flat.flat[row * self.columns + column]
        }
        set(newValue) {
            self.flat.flat[row * self.columns + column] = newValue
        }
    }
    
    // TODO: Guard against invalid indices for row/column accessors.
    
    /// Returns the receiver's row at the given index.
    public func row(index: Int) -> Vector {
        var v = self.flat.flat
        var r = [Double](repeating: 0, count: self.columns)
        for column in 0..<self.columns {
            let position = index * self.columns + column
            r[column] = v[position]
        }
        let vector = Vector(size: r.count)
        vector.flat = r
        return vector
    }
    
    /// Select column vector from matrix
    public func column(index: Int) -> Vector{
        var v = self.flat.flat
        var c = [Double](repeating: 0, count: self.rows)
        for row in 0..<self.rows {
            let position = index + row * self.columns
            c[row] = v[position]
        }
        let vector = Vector(size: c.count)
        vector.flat = c
        return vector
    }
    
    /// Returns a new `Matrix` that is a copy of the receiver.
    public func copy() -> Matrix {
        let c = Matrix(rows: self.rows, columns: self.columns)
        c.flat = self.flat.copy()
        return c
    }
    
}

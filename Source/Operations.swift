//
//  Operations.swift
//  Matrix
//
//  Created by Andrea Tullis on 30/11/15.
//  Copyright © 2015 Andrea Tullis. All rights reserved.
//

import Foundation
import Accelerate
// Vector negation
public prefix func-(m: Vector) -> Vector {
    
    var n = [Double](count: m.size, repeatedValue: 0.0)
    vDSP_vnegD(m.flat, 1, &n, 1, vDSP_Length(m.size))
    let v = Vector(size: m.size)
    v.flat = n
    return v
}

// Vector and Vector operators
public func +(lhs: Vector, rhs: Vector) -> Vector{
    var s = [Double](count: lhs.size, repeatedValue: 0.0)
    vDSP_vaddD(lhs.flat, 1, rhs.flat, 1, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

public func -(lhs: Vector, rhs: Vector) -> Vector{
    var s = [Double](count: lhs.size, repeatedValue: 0.0)
    vDSP_vsubD(lhs.flat, 1, rhs.flat, 1, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}


// Vector and scalar operators
public func +(lhs: Vector, rhs: Double) -> Vector{
    var scalar = rhs
    var s = [Double](count: lhs.size, repeatedValue: 0.0)
    vDSP_vsaddD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

public func -(lhs: Vector, rhs: Double) -> Vector{
    var s = [Double](count: lhs.size, repeatedValue: 0.0)
    var scalar = -rhs
    vDSP_vsaddD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

public func *(lhs: Vector, rhs: Double) -> Vector{
    var s = [Double](count: lhs.size, repeatedValue: 0.0)
    var scalar = -rhs
    vDSP_vsmulD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

public func /(lhs: Vector, rhs: Double) -> Vector{
    var s = [Double](count: lhs.size, repeatedValue: 0.0)
    var scalar = -rhs
    vDSP_vsdivD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

// Matrix negation
public prefix func-(m: Matrix) -> Matrix {
    let v = -m.flat
    let mat = Matrix(rows: m.rows, columns: m.columns)
    mat.flat = v
    return mat
}

// Matrix and Matrix operators
public func *(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.columns == rhs.rows, "Matrix sizes don't match")
    let v1 = lhs.flat.flat
    let v2 = rhs.flat.flat
    var r = [Double](count: lhs.rows*rhs.columns, repeatedValue: 1)
    vDSP_mmulD(v1, 1, v2, 1, &r, 1, vDSP_Length(lhs.rows), vDSP_Length(rhs.columns), vDSP_Length(rhs.rows))
    let m = Matrix(rows: lhs.rows, columns: rhs.columns)
    m.flat.flat = r
    return m

}

public func +(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix sizes don't match")
    let v1 = lhs.flat
    let v2 = rhs.flat
    let m = Matrix(rows: lhs.rows, columns: lhs.columns)
    m.flat =  v1+v2
    return m
}

public func -(lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix sizes don't match")
    let v1 = lhs.flat
    let v2 = rhs.flat
    let m = Matrix(rows: lhs.rows, columns: lhs.columns)
    m.flat =  v1-v2
    return m
}

// Matrix and scalar operators
public func +(lhs: Matrix, rhs: Double) -> Matrix {
    let v = lhs.flat+rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}

public func -(lhs: Matrix, rhs: Double) -> Matrix{
    let v = lhs.flat-rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}

public func *(lhs: Matrix, rhs: Double) -> Matrix{
    let v = lhs.flat*rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}
public func /(lhs: Matrix, rhs: Double) -> Matrix{
    let v = lhs.flat/rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}


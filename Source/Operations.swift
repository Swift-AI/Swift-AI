//
//  Operations.swift
//  Matrix
//
//  Created by Andrea Tullis on 30/11/15.
//

import Accelerate

// MARK: Vector operators

/// Vector negation (negates each element of the receiver).
public prefix func - (m: Vector) -> Vector {
    var n = [Double](repeating: 0.0, count: m.size)
    vDSP_vnegD(m.flat, 1, &n, 1, vDSP_Length(m.size))
    let v = Vector(size: m.size)
    v.flat = n
    return v
}

/// Vector addition.
public func + (lhs: Vector, rhs: Vector) -> Vector {
    var s = [Double](repeating: 0.0, count: lhs.size)
    vDSP_vaddD(lhs.flat, 1, rhs.flat, 1, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

/// Vector subtraction.
public func - (lhs: Vector, rhs: Vector) -> Vector {
    var s = [Double](repeating: 0.0, count: lhs.size)
    vDSP_vsubD(rhs.flat, 1, lhs.flat, 1, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

/// Element-wise vector addition.
public func + (lhs: Vector, rhs: Double) -> Vector {
    var scalar = rhs
    var s = [Double](repeating: 0.0, count: lhs.size)
    vDSP_vsaddD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

/// Element-wise vector subtraction.
public func - (lhs: Vector, rhs: Double) -> Vector {
    var s = [Double](repeating: 0.0, count: lhs.size)
    var scalar = -rhs
    vDSP_vsaddD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

/// Element-wise vector multiplication.
public func * (lhs: Vector, rhs: Double) -> Vector {
    var s = [Double](repeating: 0.0, count: lhs.size)
    var scalar = -rhs
    vDSP_vsmulD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}

/// Element-wise vector division.
public func / (lhs: Vector, rhs: Double) -> Vector {
    var s = [Double](repeating: 0.0, count: lhs.size)
    var scalar = -rhs
    vDSP_vsdivD(lhs.flat, 1, &scalar, &s, 1, vDSP_Length(lhs.size))
    let v = Vector(size: lhs.size)
    v.flat = s
    return v
}


// MARK: Matrix operators

/// Matrix negation.
public prefix func - (m: Matrix) -> Matrix {
    let v = -m.flat
    let mat = Matrix(rows: m.rows, columns: m.columns)
    mat.flat = v
    return mat
}

/// Matrix addition.
public func + (lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix sizes don't match")
    let v1 = lhs.flat
    let v2 = rhs.flat
    let m = Matrix(rows: lhs.rows, columns: lhs.columns)
    m.flat =  v1 + v2
    return m
}

/// Matrix subtraction.
public func - (lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.rows == rhs.rows && lhs.columns == rhs.columns, "Matrix sizes don't match")
    let v1 = lhs.flat
    let v2 = rhs.flat
    let m = Matrix(rows: lhs.rows, columns: lhs.columns)
    m.flat =  v1 - v2
    return m
}

/// Matrix multiplication.
public func * (lhs: Matrix, rhs: Matrix) -> Matrix {
    assert(lhs.columns == rhs.rows, "Matrix sizes don't match")
    let v1 = lhs.flat.flat
    let v2 = rhs.flat.flat
    var r = [Double](repeating: 1, count: lhs.rows * rhs.columns)
    vDSP_mmulD(v1, 1, v2, 1, &r, 1, vDSP_Length(lhs.rows), vDSP_Length(rhs.columns), vDSP_Length(rhs.rows))
    let m = Matrix(rows: lhs.rows, columns: rhs.columns)
    m.flat.flat = r
    return m
}

/// Element-wise matrix addition.
public func + (lhs: Matrix, rhs: Double) -> Matrix {
    let v = lhs.flat + rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}

/// Element-wise matrix subtraction.
public func - (lhs: Matrix, rhs: Double) -> Matrix{
    let v = lhs.flat-rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}

/// Element-wise matrix multiplication.
public func * (lhs: Matrix, rhs: Double) -> Matrix{
    let v = lhs.flat*rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}

/// Element-wise matrix division.
public func / (lhs: Matrix, rhs: Double) -> Matrix{
    let v = lhs.flat/rhs
    let mat = Matrix(rows: lhs.rows, columns: lhs.columns)
    mat.flat = v
    return mat
}


//
//  Storage.swift
//  Swift-AI-OSX
//
//  Created by Andrea on 11/24/15.
//

import Foundation

public protocol Storage {
    
    associatedtype StorageType
    func writeToFile(filename: String)
    func writeToFile(url: NSURL)
    static func fromFile(filename: String) -> StorageType?
    static func fromFile(url: NSURL) -> StorageType?

}
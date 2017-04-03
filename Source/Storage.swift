//
//  Storage.swift
//
//  Created by Andrea on 11/24/15.
//

/*
    NOTE: This protocol defines the `Storage` protocol for reading/writing Swift AI objects to file.
    Any class can adopt this protocol, and typically the extension is defined in its own source file called `ClassName+Storage.swift`.
*/


import Foundation

public protocol Storage {
    
    associatedtype StorageType
    func writeToFile(_ filename: String)
    func writeToFile(_ url: URL)
    static func fromFile(_ filename: String) -> StorageType?
    static func fromFile(_ url: URL) -> StorageType?

}

//
//  Storage.swift
//  Swift-AI-OSX
//
//  Created by Andrea on 11/24/15.
//

import Foundation

public protocol Storage {
    
    associatedtype StorageType
    func writeToFile(_ filename: String)
    func writeToFile(_ url: URL)
    static func fromFile(_ filename: String) -> StorageType?
    static func fromFile(_ url: URL) -> StorageType?

}

//
//  Storage.swift
//  Swift-AI-OSX
//
//  Created by Andrea on 11/24/15.
//  Copyright © 2015 Appsidian. All rights reserved.
//

import Foundation



public protocol Storage {
    
    typealias ItemType
    func write(filename : String)
    static func read(filename: String) -> ItemType?

}
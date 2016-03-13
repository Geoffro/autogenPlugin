//
//  Utils.swift
//  AutogenPlugin
//
//  Created by Geoff on 3/9/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

class Utils
{
    static func buildPath(basePath : String, file : String) -> String
    {
        // Most common case is to not already have the "/" at the end.
        var newPath : String = "\(basePath)/\(file)"

        if basePath.hasSuffix("/")
        {
            newPath = "\(basePath)\(file)"
        }

        return newPath
    }

    static func fileExists(path : String) -> Bool
    {
        return NSFileManager().fileExistsAtPath(path)
    }

    static func assertFileExists(path : String)
    {
        assert(fileExists(path))
    }
}
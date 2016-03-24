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
    static func fileExists(path : NSURL) -> Bool
    {
        var error : NSErrorPointer!

        let result = path.checkResourceIsReachableAndReturnError(error)

        return result
    }

    static func assertFileExists(path : NSURL)
    {
        assert(fileExists(path))
    }
}
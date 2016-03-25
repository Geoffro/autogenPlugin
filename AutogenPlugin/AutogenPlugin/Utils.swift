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
        var error : NSError?

        let result = path.checkResourceIsReachableAndReturnError(&error)

        if error != nil
        {
            print("File \(path) does not exist.\nDetails are here:\n")
            print(error)
        }

        return result
    }

    static func assertFileExists(path : NSURL)
    {
        assert(fileExists(path))
    }

    // Func removes all sub strings
    static func removeSubstrings(str : String, strReplace : String) -> String
    {
        return str.stringByReplacingOccurrencesOfString(strReplace, withString: "", options : NSStringCompareOptions.LiteralSearch, range : nil)
    }

    // Func pops the '..' elements out of the orginal string and returns the count of those elements.
    static func popDirCount(inout path : String) -> Int
    {
        let BackDir        = ".."
        let inputLength    = path.characters.count
        var count          = 0

        var range = NSRange(location : 0, length : inputLength)

        while (range.location != NSNotFound)
        {
            range = (path as NSString).rangeOfString(BackDir, options : [], range : range)

            if (range.location != NSNotFound)
            {
                range = NSRange(location : range.location + range.length,
                                length   : inputLength - (range.location + range.length))
                count += 1
            }
        }

        if count == 1
        {
            path = removeSubstrings(path, strReplace : BackDir)
        }
        else if count > 1
        {
            // We have multiple back dirs, need to remove all of them:
            let BackDirs = "../"
            path = removeSubstrings(path, strReplace : BackDirs)

            // To be sure, remove any remaining backsies
            path = removeSubstrings(path, strReplace : BackDir)
        }

        return count
    }

    static func popDirs(basePath : NSURL, appendPath : String) -> NSURL
    {
        var retPath       : NSURL   = basePath
        var newAppendPath : String  = appendPath

        let numPops : Int = popDirCount(&newAppendPath)

        for i : Int in 0..<numPops
        {
            retPath = retPath.URLByDeletingLastPathComponent!


            print("Popping path component, result is ", retPath)
            print("This is pop ", i)
        }

        retPath = NSURL(string : newAppendPath, relativeToURL : retPath)!

        return retPath
    }
}

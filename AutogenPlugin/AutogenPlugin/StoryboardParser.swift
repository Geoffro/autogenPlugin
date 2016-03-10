//
//  StoryboardParser.swift
//  AutogenPlugin
//
//  Created by Geoff on 3/8/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

// Storyboard element constants
struct SBE
{
    static let viewController = "viewController"
    static let segue          = "segue"
}

// Storyboard attribute constants
struct SBA
{
    static let storyboardIdentifier = "storyboardIdentifier"
    static let segueIdentifier      = "identifier"
}

class StoryboardParser
    :
    NSObject,
    NSXMLParserDelegate
{
    var storyboardIDs  = [String]()
    var namedSegues    = [String]()

    var parser                     : NSXMLParser!

    init(path : String)
    {
        super.init()

        let storyboardPath = NSURL(fileURLWithPath : path)
        parser             = NSXMLParser(contentsOfURL : storyboardPath)
        parser!.delegate   = self
    }

    func parse()
    {
        parser.parse()

        if _isDebugAssertConfiguration()
        {
            printParsedData()
        }
    }

    func parser(parser                      : NSXMLParser,
                didStartElement elementName : String,
                namespaceURI                : String?,
                qualifiedName qName         : String?,
                attributes attributeDict    : [String : String])
    {
        if elementName == SBE.viewController
        {
            if let id = attributeDict[SBA.storyboardIdentifier]
            {
                storyboardIDs.append(id)
            }
        }
        else if elementName == SBE.segue
        {
            if let id = attributeDict[SBA.segueIdentifier]
            {
                namedSegues.append(id)
            }
        }
    }

    // Dump all the data collected.
    func printParsedData()
    {
        if self.storyboardIDs.count > 0
        {
            print("Storyboard IDs:\n")

            for (_, id) in self.storyboardIDs.enumerate()
            {
                print(id)
            }
        }
        else
        {
            print("No Storyboard IDs found.\n")
        }

        if self.namedSegues.count > 0
        {
            print("Named Segues:\n")

            for (_, id) in self.namedSegues.enumerate()
            {
                print(id)
            }
        }
        else
        {
            print("No Named segues found.\n")
        }
    }
}

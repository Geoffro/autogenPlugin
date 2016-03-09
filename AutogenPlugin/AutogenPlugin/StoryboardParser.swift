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
}

// Storyboard attribute constants
struct SBA
{
    static let storyboardIdentifier = "storyboardIdentifier"
}

class StoryboardParser
    :
    NSObject,
    NSXMLParserDelegate
{
    var storyboardIDs = [String]()
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

#if DEBUG
        printParseData()
#endif // DEBUG
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
    }

#if DEBUG
    // Dump all the data collected.
    func printParsedData()
    {
        for (_, id) in self.storyboardIDs.enumerate()
        {
            print(id)
        }
    }
#endif // DEBUG
}

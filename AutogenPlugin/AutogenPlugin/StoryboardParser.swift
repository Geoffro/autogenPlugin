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
    private var m_storyboardIDs  = [String]()
    private var m_namedSegues    = [String]()

    private var m_parser                     : NSXMLParser!
    private var m_parsed                     : Bool         = false

    init(path : NSURL)
    {
        super.init()

        m_parser             = NSXMLParser(contentsOfURL : path)
        m_parser!.delegate   = self

        parse()
    }

    func storyboardIDs() -> [String]
    {
        return m_storyboardIDs
    }

    func namedSegues() -> [String]
    {
        return m_namedSegues
    }

    private func parse()
    {
        m_parser.parse()
        printParsedData()

        m_parsed = true
    }

    func parsed() -> Bool
    {
        return m_parsed
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
                m_storyboardIDs.append(id)
            }
        }
        else if elementName == SBE.segue
        {
            if let id = attributeDict[SBA.segueIdentifier]
            {
                m_namedSegues.append(id)
            }
        }
    }

    // Dump all the data collected.
    func printParsedData()
    {
        if m_storyboardIDs.count > 0
        {
            print("Storyboard IDs:\n")

            for id : String in m_storyboardIDs
            {
                print(id)
            }
        }
        else
        {
            print("No Storyboard IDs found.\n")
        }

        if m_namedSegues.count > 0
        {
            print("Named Segues:\n")

            for id : String in m_namedSegues
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

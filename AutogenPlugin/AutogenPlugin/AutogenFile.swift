//
//  AutogenFile.swift
//  AutogenPlugin
//
//  Created by Geoff on 3/15/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

struct Gen
{
    static let Segues          = "Segues"
    static let StoryboardIds   = "StoryboardIds"
    static let Images          = "Images"
    static let ApiKeys         = "ApiKeys"
}

class FileWriter
{
    private var m_genFileFullPath    : NSURL!
    private var m_imgMgr             : ImgMgr!
    private var m_storyboardData     : StoryboardParser!
    private var m_apiKeyMgr          : ApiKeyMgr!
    private var m_outfile            : NSFileHandle!
    private var m_fileOpen           : Bool = false

    static  var TAB = "    "

    init(imgMgr          : ImgMgr,
         storyboardData  : StoryboardParser,
         apiKeyMgr       : ApiKeyMgr,
         genFilePath     : NSURL)
    {
        m_imgMgr          = imgMgr
        m_storyboardData  = storyboardData

        m_genFileFullPath = genFilePath
        m_fileOpen        = true

        do
        {
            m_outfile  = try NSFileHandle(forWritingToURL : m_genFileFullPath)
        }
        catch
        {
            print("Error: Failed to open output file ", m_genFileFullPath.absoluteString)
            m_fileOpen = false
        }
    }

    func writeAutogenData()
    {
        self.writeHeader()

        self.writeStoryboardData()

        self.writeImageData()

        m_outfile.closeFile()

        m_fileOpen = false
    }

    // Func to write all the image names to a file.
    private func writeImageData()
    {
        assert(m_fileOpen)

        if m_imgMgr.images.count > 0
        {
            self.writeArrayToStruct(Gen.Images, array : m_imgMgr.images)
        }
        else
        {
            self.writeCommentLine("No images found.\n")
        }
    }

    // Func to write all the storyboard data to a file.
    private func writeStoryboardData()
    {
        assert(m_fileOpen)

        if m_storyboardData.namedSegues().count > 0
        {
            self.writeArrayToStruct(Gen.Segues, array : m_storyboardData.namedSegues())
        }
        else
        {
            self.writeCommentLine("No named segues found.\n")
        }

        if m_storyboardData.storyboardIDs().count > 0
        {
            self.writeArrayToStruct(Gen.Segues, array : m_storyboardData.storyboardIDs())
        }
        else
        {
            self.writeCommentLine("No storyboard IDs found.\n")
        }

        if m_apiKeyMgr.getKeys().count > 0
        {
            self.writeDictToStruct(Gen.ApiKeys, dict : m_apiKeyMgr.getKeys())
        }
    }


    private func writeHeader()
    {
        self.writeCommentLine("This file is autogenerated.\n\n")
        self.writeCommentLine("Do not edit, it will be overwritten.\n\n")
    }

    func writeDictToStruct(dictName : String, dict : Dictionary<String, String>)
    {
        self.writeTabLine("struct \(dictName)\n\(FileWriter.TAB){\n")

        for (key, val) in dict
        {
            self.writeTabLine("static let \(key) = \(val)\n")
        }

        self.writeTabLine("\(FileWriter.TAB)}\n\n")
    }

    // writeArrayToStruct (0).
    // Funct to write an array of image assets to file as an array.
    func writeArrayToStruct(structName : String, array : [ImgAsset])
    {
        assert(array.count > 0)

        self.writeTabLine("struct \(structName)\n\(FileWriter.TAB){\n")

        for item in array
        {
            self.writeTabLine("static let \(item.baseName) = \"\(item.baseName)\"\n")
        }

        self.writeTabLine("\(FileWriter.TAB)}\n\n")
    }

    // writeArrayToStruct (1)
    // Funct to write an array of strings to file as an array.
    func writeArrayToStruct(structName : String, array : [String])
    {
        assert(array.count > 0)

        self.writeTabLine("struct \(structName)\n\(FileWriter.TAB){\n")

        for item in array
        {
            self.writeTabLine("static let \(item) = \"\(item)\"\n")
        }

        self.writeTabLine("\(FileWriter.TAB)}\n\n")
    }

    //
    // File IO utility funcs:
    //

    // Converts a string to data and writes to file.
    private func write(s : String)
    {
        assert(m_fileOpen)

        if let writeString = s.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        {
            m_outfile.writeData(writeString)
            print(s)
        }
        else
        {
            print("Error: Failed to write \(s) to file.\n")
        }
    }

    private func writeTabLine(s : String)
    {
        self.write("\(FileWriter.TAB)\(s)")
    }

    // Writes a string as a single line comment.
    private func writeCommentLine(s : String)
    {
        self.write("\(FileWriter.TAB)//\(s)\n")
    }
}
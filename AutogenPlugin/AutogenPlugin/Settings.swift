//
//  Settings.swift
//  AutogenPlugin
//
//  Created by Geoff on 3/11/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

/*
    The settings file has a plist layout.

    Note: All paths are relative to the source directory.

    The layout is as follows:
    <dict>
        <key>GenerationFileDest</key>
        <string>Some path</string>
        <key>ImageAssetsPath</key>
        <string>Some path</string>
        <key>StoryboardsFileRoot</key>
        <string>Some path</string>
    </dict>
*/

class Settings
{
    var sourceDir        : String   = ""
    var settingsFilePath : String   = ""
    var genFileDest      : String   = ""
    var genFileName      : String   = ""
    var genFileFullPath  : String   = ""
    var imgDirPath       : String   = ""
    var storyboardRoot   : String   = ""
    var created          : Bool     = false

    static let instance  : Settings = Settings()

    struct Keys
    {
        static let GenFileName      = "GenerationFileName"
        static let GenFileDest      = "GenerationFileDest"
        static let ImgDirPath       = "ImageAssetsPath"
        static let StoryboardRoot   = "StoryboardsFileRoot"
    }

    private init()
    {

    }

    func create(sourceDir : String)
    {
        if (sourceDir != self.sourceDir) || (self.created == false)
        {
            self.sourceDir = sourceDir
            self.settingsFilePath = Utils.buildPath(self.sourceDir, file : ProjectItems.SettingsFileName)

            self.setDefaults()

            if NSFileManager().fileExistsAtPath(self.settingsFilePath)
            {
                loadSettings()
            }

            self.created = true
        }
    }

    // Default values are setup here.
    // We can't assert on any of these paths because they are defaults and they may not actually exist.
    func setDefaults()
    {
        // The name of the generation file.
        genFileName    = ProjectItems.DefaultAutogenFileName
        // The generated file will be placed in the settings directory by default.
        genFileDest    = Utils.buildPath(self.sourceDir, file : ProjectItems.SettingsFileName)
        // Images should be found in the source dir. There are multiple names for this dir.
        imgDirPath     = ImgMgr.findLocalImagePath(self.sourceDir)
        // Storyboards are going to be found in the source directory as well.
        storyboardRoot = Utils.buildPath(self.sourceDir, file : ProjectItems.StoryboardDir)
    }

    // Func to set a string when its value is found in the dict and the string isn't empty.
    func setStringIfNotEmpty(      dictString : AnyObject?,
                             inout outString  : String,
                                   isRelative : Bool        = true)  // Flag to set if the string needs a relative path.
    {
        if let curVal = dictString
        {
            let curString = curVal as! String

            if curString != ""
            {
                outString = isRelative ? Utils.buildPath(self.sourceDir, file: curString) : curString
            }
        }
    }

    func loadSettings()
    {
        if let dict = NSDictionary(contentsOfFile : self.settingsFilePath) as? Dictionary<String, AnyObject>
        {
            setStringIfNotEmpty(dict[Keys.GenFileName], outString : &self.genFileName, isRelative : false)
            setStringIfNotEmpty(dict[Keys.GenFileDest], outString : &self.genFileDest)
            Utils.assertFileExists(self.genFileDest)

            // Build the full path to the gen file.
            genFileFullPath = Utils.buildPath(self.genFileDest, file : genFileName)

            setStringIfNotEmpty(dict[Keys.ImgDirPath], outString : &self.imgDirPath)
            Utils.assertFileExists(self.imgDirPath)

            setStringIfNotEmpty(dict[Keys.StoryboardRoot], outString : &self.storyboardRoot)
            Utils.assertFileExists(self.storyboardRoot)
        }
    }
}
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
    var sourceDir             : NSURL!
    var settingsFilePath      : NSURL!
    var genFileDest           : NSURL!
    var genFileName           : String   = ""
    var genFileFullPath       : NSURL!
    var imgDirPath            : NSURL!
    var storyboardRoot        : NSURL!
    var storyboardName        : String   = ""
    var storyboardFullPath    : NSURL!
    var apiKeysLocation       : NSURL!
    var apiKeysFileName       : String   = ""
    var apiKeysFullPath       : NSURL!
    var created               : Bool     = false

    static let instance       : Settings = Settings()

    struct Keys
    {
        static let GenFileName      = "GenerationFileName"
        static let GenFileDest      = "GenerationFileDest"
        static let ImgDirPath       = "ImageAssetsPath"
        static let StoryboardRoot   = "StoryboardsFileRoot"
        static let StoryboardName   = "StoryboardFileName"
        static let ApiKeysLocation  = "ApiKeysLocation"
        static let ApiKeysFileName  = "ApiKeysFileName"
    }

    private init()
    {

    }

    func create(sourceDir : NSURL)
    {
        // If we update the src dir, then re-do the creation.
        // If it hasn't been created yet, we also need to create.
        if (sourceDir != self.sourceDir) || (self.created == false)
        {
            self.sourceDir        = sourceDir
            self.settingsFilePath = NSURL.init(string : ProjectItems.SettingsFileName, relativeToURL : self.sourceDir)

            self.setDefaults()

            if Utils.fileExists(self.settingsFilePath)
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
        genFileName        = ProjectItems.DefaultAutogenFileName
        // The generated file will be placed in the settings directory by default.
        genFileDest        = NSURL.init(string : ProjectItems.SettingsFileName, relativeToURL : self.sourceDir)
        // Images should be found in the source dir. There are multiple names for this dir.
        imgDirPath         = ImgMgr.findLocalImagePath(self.sourceDir)
        // Storyboards are going to be found in the source directory as well.
        storyboardRoot     = NSURL.init(string : ProjectItems.StoryboardDir, relativeToURL : self.sourceDir)
        storyboardName     = ProjectItems.DefaultStoryboardName
        storyboardFullPath = NSURL.init(string : self.storyboardName, relativeToURL : self.storyboardRoot)

        // Api Keys are going to be found in the source dir.
        apiKeysLocation    = NSURL.init(string : ProjectItems.DefaultApiKeyFileName, relativeToURL : self.sourceDir)
    }

    // Func to set a string when its value is found in the dict and the string isn't empty.
    func setPathIfNotEmpty(dictString : AnyObject?, outURL : NSURL) -> NSURL
    {
        if let curVal = dictString
        {
            let curString = curVal as! String

            if curString != ""
            {
                return NSURL.init(string : curString, relativeToURL : self.sourceDir)!
            }
        }

        return outURL
    }

    func setStringIfNotEmpty(      dictString       : AnyObject?,
                             inout outString        : String)
    {
        if let curVal = dictString
        {
            let curString = curVal as! String

            if curString != ""
            {
                outString = curString
            }
        }
    }

    // Func to read the configuration file and determine any project settings.
    func loadSettings()
    {
        if let dict = NSDictionary(contentsOfURL : self.settingsFilePath) as? Dictionary<String, AnyObject>
        {
            setStringIfNotEmpty(dict[Keys.GenFileName], outString : &self.genFileName)
            self.genFileDest = setPathIfNotEmpty(dict[Keys.GenFileDest], outURL : self.genFileDest)
            Utils.assertFileExists(self.genFileDest)

            // Build the full path to the gen file.
            genFileFullPath = NSURL.init(string : self.genFileName, relativeToURL : self.genFileDest)

            self.imgDirPath = setPathIfNotEmpty(dict[Keys.ImgDirPath], outURL : self.imgDirPath)
            Utils.assertFileExists(self.imgDirPath)

            self.storyboardRoot = setPathIfNotEmpty(dict[Keys.StoryboardRoot], outURL : self.storyboardRoot)
            Utils.assertFileExists(self.storyboardRoot)

            setStringIfNotEmpty(dict[Keys.StoryboardName], outString : &self.storyboardName)
            self.storyboardFullPath = NSURL.init(string : self.storyboardName, relativeToURL : self.storyboardRoot)
            Utils.assertFileExists(self.storyboardFullPath)

            self.apiKeysLocation = setPathIfNotEmpty(dict[Keys.ApiKeysLocation], outURL : self.apiKeysLocation)
            setStringIfNotEmpty(dict[Keys.ApiKeysFileName], outString : &self.apiKeysFileName)

            self.apiKeysFullPath = NSURL.init(string : self.apiKeysFileName, relativeToURL : self.apiKeysLocation)
        }
    }
}
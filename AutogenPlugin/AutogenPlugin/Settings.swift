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
    var settingsFilePath : String = ""
    var genFileDest      : String = ""
    var imgDirPath       : String = ""
    var storyboardRoot   : String = ""

    struct Keys
    {
        static let GenFileDest      = "GenerationFileDest"
        static let ImgDirPath       = "ImageAssetsPath"
        static let StoryboardRoot   = "StoryboardsFileRoot"
    }

    init(sourceDir : String)
    {
        self.settingsFilePath = Utils.buildPath(sourceDir, file : ProjectItems.SettingsFileName)

        if NSFileManager().fileExistsAtPath(self.settingsFilePath)
        {
            loadSettings()
        }
    }

    func loadSettings()
    {
        if let _ = NSDictionary(contentsOfFile : self.settingsFilePath) as? Dictionary<String, AnyObject>
        {
            // Determine the layout of the xml settings file and then update this accordingly.
        }
    }
}
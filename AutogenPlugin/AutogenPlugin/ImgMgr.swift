//
//  ImageManager.swift
//  AutogenPlugin
//
//  Created by Geoff on 3/9/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

class ImgMgr
{
    var imageDirFullPath : NSURL!
    var srcDir           : NSURL!

    var images = [ImgAsset]()

    init(sourceRoot : NSURL)
    {
        self.srcDir           = sourceRoot
        self.imageDirFullPath = ImgMgr.findLocalImagePath(self.srcDir)

        findProjectImageNames()
    }

    // Func to locate the image directory in the local workspace.
    // The images are assumed to be stored in:
    //     1. ProjectRoot/ProjectSrcDir/Assets.cassets
    //     2. ProjectRoot/ProjectSrcDir/Images.cassets
    static func findLocalImagePath(srcDir : NSURL) -> NSURL
    {
        var retImgDirPath : NSURL!

        let imgDirs = [ProjectItems.ImgDir, ProjectItems.ImgDirAlt]

        for dir : String in imgDirs
        {
            let imgDirPath = NSURL.init(string : dir, relativeToURL : srcDir)!

            if Utils.fileExists(imgDirPath)
            {
                retImgDirPath = imgDirPath
                break
            }
        }

        assert(retImgDirPath != "")

        return retImgDirPath
    }

    // Func to walk the image asset dir and grab the file names
    private func findProjectImageNames()
    {
        let fileMgr  = NSFileManager()

        do
        {
            let filelist = try fileMgr.contentsOfDirectoryAtURL(self.imageDirFullPath, includingPropertiesForKeys : nil, options : NSDirectoryEnumerationOptions.SkipsHiddenFiles)

            for filename : NSURL in filelist
            {
                if filename.pathExtension == ProjectItems.ImgSetExtension
                {
                    let fileNameString = filename.absoluteString
                    let fullPath = NSURL.init(string : fileNameString, relativeToURL: self.imageDirFullPath)!

                    let imgAsset = ImgAsset(baseName : fileNameString,
                                            path     : fullPath)

                    images.append(imgAsset)
                }
            }

            self.dumpImageNames()
        }
        catch
        {
            print("Error: Failed to load the contents of the image directory")
        }
    }

    private func dumpImageNames()
    {
        for img : ImgAsset in self.images
        {
            print(img.baseDirPath)
            print("\n")
        }
    }
}
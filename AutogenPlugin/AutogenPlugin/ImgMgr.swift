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
    var imageDirFullPath : String!
    var srcDir           : String!

    var images = [ImgAsset]()

    init(sourceRoot : String)
    {
        self.srcDir           = sourceRoot
        self.imageDirFullPath = ImgMgr.findLocalImagePath(self.srcDir)

        findProjectImageNames()
    }

    // Func to locate the image directory in the local workspace.
    // The images are assumed to be stored in:
    //     1. ProjectRoot/ProjectSrcDir/Assets.cassets
    //     2. ProjectRoot/ProjectSrcDir/Images.cassets
    static func findLocalImagePath(srcDir : String) -> String
    {
        let fileMgr = NSFileManager()

        var retImgDirPath : String = ""

        let imgDirs = [ProjectItems.ImgDir, ProjectItems.ImgDirAlt]

        for dir : String in imgDirs
        {
            let imgDirPath = Utils.buildPath(srcDir, file : dir)

            if fileMgr.fileExistsAtPath(imgDirPath)
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
            let filelist = try fileMgr.contentsOfDirectoryAtPath(self.imageDirFullPath)

            for filename : String in filelist
            {
                if NSURL(fileURLWithPath : filename).pathExtension == ProjectItems.ImgSetExtension
                {
                    let fullPath = Utils.buildPath(self.imageDirFullPath, file : filename)

                    let imgAsset = ImgAsset(baseName : filename,
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
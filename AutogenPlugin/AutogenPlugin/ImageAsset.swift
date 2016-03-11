//
//  ImageAsset.swift
//  AutogenPlugin
//
//  Created by Geoff on 3/10/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

enum ImgRes : String
{
    case X1      = "1x"
    case X2      = "2x"
    case X3      = "3x"
    case Invalid = "Invalid"
}

// This struct represents an actual underlying image
//     contained within the asset dir.
struct RawImg
{
    var name       : String
    var resolution : ImgRes

    init(name : String)
    {
        self.name       = name
        self.resolution = ImgRes.Invalid
    }
}

// This represents the image asset dir and its contents.
class ImgAsset
{
    var baseName     : String!
    var baseDirPath  : String!

    var imageNames  = [RawImg]()

    init(baseName : String, path : String)
    {
        self.baseName    = baseName
        self.baseDirPath = path
    }

    func appendRawImage(name : String)
    {
        var rawImg        = RawImg(name : name)
        rawImg.resolution = ImgAsset.determineResolution(rawImg.name)

        imageNames.append(rawImg)
    }

    static func determineResolution(imgName : String) -> ImgRes
    {
        let retVal = ImgRes.Invalid

        return retVal
    }
}
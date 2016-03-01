//
//  NSObject_Extension.swift
//
//  Created by Geoff on 2/29/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

extension NSObject
{
    class func pluginDidLoad(bundle: NSBundle)
    {
        let appName = NSBundle.mainBundle().infoDictionary?["CFBundleName"] as? NSString
        if appName == "Xcode"
        {
            if sharedPlugin == nil
            {
        		sharedPlugin = AutogenPlugin(bundle: bundle)
        	}
        }
    }
}
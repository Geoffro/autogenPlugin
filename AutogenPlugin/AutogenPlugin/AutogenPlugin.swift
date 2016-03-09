//
//  AutogenPlugin.swift
//
//  Created by Geoff on 2/29/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import AppKit

var sharedPlugin: AutogenPlugin?

class AutogenPlugin: NSObject
{
    var      bundle : NSBundle
    lazy var center = NSNotificationCenter.defaultCenter()

    var      autogenFile     : NSFileHandle!
    var      autogenFileName : String         = "testFile.swift"
    var      autogenFilePath : String!
    var      sourceDir       : String!
    var      projectPath     : NSString!

    init(bundle : NSBundle)
    {
        self.bundle = bundle

        super.init()
        center.addObserver(self, selector: Selector("createMenuItems"), name: NSApplicationDidFinishLaunchingNotification, object: nil)
    }

    deinit
    {
        removeObserver()
    }

    func removeObserver()
    {
        center.removeObserver(self)
    }

    func createMenuItems()
    {
        removeObserver()

        let item = NSApp.mainMenu!.itemWithTitle("Product")

        if item != nil
        {
            let actionMenuItem = NSMenuItem(title:"Sync Build", action:"syncAutogenData", keyEquivalent:"")
            actionMenuItem.target = self
            item!.submenu!.addItem(NSMenuItem.separatorItem())
            item!.submenu!.addItem(actionMenuItem)
        }
    }

    // Gets the workspace .xcodeproj
    func getProjectPath()
    {
        if let workspaceController = NSClassFromString("IDEWorkspaceWindowController") as? NSObject.Type
        {
            let windowControllers = workspaceController.valueForKey("workspaceWindowControllers") as? [NSObject]

            for windowController in windowControllers!
            {
                if (windowController.valueForKey("window")!.isEqual(NSApp.keyWindow))
                {
                    let workSpace       = windowController.valueForKey("_workspace")
                    let rFp             = workSpace!.valueForKey("representingFilePath")!
                    self.projectPath    = rFp.valueForKey("_pathString") as! NSString
                    break;
                }
            }
        }
    }

    // Func to get the path to the directories for the various items needed.
    func resolveResourcePaths()
    {
        getProjectPath()

        self.sourceDir = self.projectPath.stringByDeletingPathExtension as String

        self.autogenFilePath = "\(self.sourceDir)/\(autogenFileName)"
    }

    func syncAutogenData()
    {
        resolveResourcePaths()

        let text = "test data"

        do
        {
            try text.writeToFile(self.autogenFilePath, atomically : false, encoding : NSUTF8StringEncoding)
        }
        catch
        {
            print("Error: Failed to write file")
        }
    }
}


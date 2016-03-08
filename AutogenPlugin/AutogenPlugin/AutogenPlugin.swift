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
    var      autogenFilePath : String         = "testFile.swift"
    var      projectRoot     : String!

    init(bundle: NSBundle)
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
            let actionMenuItem = NSMenuItem(title:"Sync Build", action:"doMenuAction", keyEquivalent:"")
            actionMenuItem.target = self
            item!.submenu!.addItem(NSMenuItem.separatorItem())
            item!.submenu!.addItem(actionMenuItem)
        }
    }

    func getWorkSpacePath() -> String
    {
        var workspacePath : String! = ""

        if let workspaceController = NSClassFromString("IDEWorkspaceWindowController") as? NSObject.Type
        {
            let windowControllers = workspaceController.valueForKey("workspaceWindowControllers") as? [NSObject]

            for windowController in windowControllers!
            {
                if (windowController.valueForKey("window")!.isEqual(NSApp.keyWindow))
                {
                    let workSpace = windowController.valueForKey("_workspace")
                    let rFp       = workSpace!.valueForKey("representingFilePath")!
                    workspacePath = rFp.valueForKey("_pathString") as! String
                    break;
                }
            }
        }

        return workspacePath
    }

    func doMenuAction()
    {
        print(getWorkSpacePath())

        print(autogenFilePath)
        let fullPath = "\(getWorkSpacePath())/\(autogenFilePath)"
        print(fullPath)
        if let autogenFile = NSFileHandle(forWritingAtPath : fullPath)
        {
            autogenFile.writeData(("test data" as
                NSString).dataUsingEncoding(NSUTF8StringEncoding)!)

            autogenFile.closeFile()
            print("Write to file")
        }
        else
        {
            print("Failed to open file")
        }
    }
}


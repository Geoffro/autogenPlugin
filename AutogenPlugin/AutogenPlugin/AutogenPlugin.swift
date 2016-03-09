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
        var workspacePath : NSString! = ""

        if let workspaceController = NSClassFromString("IDEWorkspaceWindowController") as? NSObject.Type
        {
            let windowControllers = workspaceController.valueForKey("workspaceWindowControllers") as? [NSObject]

            for windowController in windowControllers!
            {
                if (windowController.valueForKey("window")!.isEqual(NSApp.keyWindow))
                {
                    let workSpace = windowController.valueForKey("_workspace")
                    let rFp       = workSpace!.valueForKey("representingFilePath")!
                    workspacePath = rFp.valueForKey("_pathString") as! NSString
                    break;
                }
            }
        }

        return workspacePath.stringByDeletingPathExtension as String
    }

    func doMenuAction()
    {
        let fullPath = "\(getWorkSpacePath())/\(autogenFilePath)"

        print(fullPath)

        let text = "test data"

        do
        {
            try text.writeToFile(fullPath, atomically : false, encoding : NSUTF8StringEncoding)
        }
        catch
        {
            print("Error: Failed to write file")
        }
    }
}


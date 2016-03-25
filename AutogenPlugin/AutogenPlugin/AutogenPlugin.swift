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

    var      sourceDir               : NSURL!
    var      projectPath             : NSURL!

    init(bundle : NSBundle)
    {
        self.bundle = bundle

        super.init()
        center.addObserver(self, selector: #selector(AutogenPlugin.createMenuItems), name: NSApplicationDidFinishLaunchingNotification, object: nil)
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
            let actionMenuItem = NSMenuItem(title:"Sync Build", action:#selector(AutogenPlugin.syncAutogenData), keyEquivalent:"")
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
                    self.projectPath    = NSURL(fileURLWithPath : rFp.valueForKey("_pathString") as! String)

                    Utils.assertFileExists(self.projectPath)

                    // Source dir is ProjectRoot/ProjectFileName without the .xcproj extension:
                    self.sourceDir = NSURL(string : self.projectPath.pathExtension!)
                    Utils.assertFileExists(self.sourceDir)

                    Settings.instance.create(self.sourceDir)

                    break;
                }
            }
        }
    }

    func syncAutogenData()
    {
        getProjectPath()

        let sbParser = StoryboardParser(path : Settings.instance.storyboardFullPath)

        let imgManager = ImgMgr(sourceRoot : self.sourceDir)

        let apiKeyMgr = ApiKeyMgr(path : Settings.instance.apiKeysLocation)

        let fileWriter = FileWriter(imgMgr : imgManager, storyboardData : sbParser, apiKeyMgr : apiKeyMgr, genFilePath : Settings.instance.genFileFullPath)

        fileWriter.writeAutogenData()
    }
}


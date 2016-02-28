//
//  AutogenPlugin.swift
//
//  Created by Geoff on 2/27/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import AppKit

var sharedPlugin: AutogenPlugin?

class AutogenPlugin: NSObject
{
    var bundle: NSBundle
    lazy var center = NSNotificationCenter.defaultCenter()

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

        var item = NSApp.mainMenu!.itemWithTitle("Edit")

        if item != nil
        {
            var actionMenuItem = NSMenuItem(title:"Do Action", action:"doMenuAction", keyEquivalent:"")
            actionMenuItem.target = self
            item!.submenu!.addItem(NSMenuItem.separatorItem())
            item!.submenu!.addItem(actionMenuItem)
        }
    }

    func doMenuAction()
    {
        let error = NSError(domain: "Hello World!", code:42, userInfo:nil)
        NSAlert(error: error).runModal()
    }
}


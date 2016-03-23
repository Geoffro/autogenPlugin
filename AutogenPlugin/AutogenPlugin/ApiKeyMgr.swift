//
//  ApiKeyMgr.swift
//  AutogenPlugin
//
//  Created by Geoff on 3/22/16.
//  Copyright © 2016 Geoff. All rights reserved.
//

import Foundation

class ApiKeyMgr
{
    private var m_apiKeysFullPath : String!

    private var m_apiKeys = Dictionary<String, String>()

    init (path : String)
    {
        m_apiKeysFullPath = path

        loadSettings()
    }

    func getKeys() -> Dictionary<String, String>
    {
        return m_apiKeys
    }


    private func loadSettings()
    {
        do
        {
            let jsonData = try NSData(contentsOfFile : m_apiKeysFullPath, options : NSDataReadingOptions.DataReadingMappedIfSafe)

            do
            {
                let jsonData : NSDictionary = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary

                for (key, val) in jsonData
                {
                    m_apiKeys[key as! String] = val as? String
                }
            }
            catch
            {
                print("ApiKeys json file could not be loaded\n")
            }
        }
        catch
        {
            print("Failed to open \(m_apiKeysFullPath)\n")
        }
    }
}
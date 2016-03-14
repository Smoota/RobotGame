//
//  Helpers.swift
//  SideScroller
//
//  Created by Justin Dike 2 on 10/23/15.
//  Copyright © 2015 CartoonSmart. All rights reserved.
//

import Foundation
import SpriteKit


class Helpers {
    
   
    static var maxLevels = 1
    static var loggedIntoGC:Bool = false
    
    static func parsePropertyListForLevelToLoad( levelToLookUp:Int, levelsName:String ) -> String {
        
        var nextLevel:String  = "Level1"
        
        
        let path = NSBundle.mainBundle().pathForResource("LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if (dict.objectForKey(levelsName) != nil) {
            
            if let levelData = dict.objectForKey(levelsName) as? [AnyObject] {
                
               
            
                var counter:Int = 1
                
                for theDictionary in levelData {
            
                    if (levelToLookUp == counter) {
            
                        // this is the current level we are interested in
                        
                        if (theDictionary is [String : AnyObject]) {
                        
                            if let currentDictionary:[String : AnyObject] = theDictionary as? [String : AnyObject] {
                        
                                
                                for (theKey, theValue) in currentDictionary {
                            
                                    if (theKey == "SKSFile") {
                                        
                                        if (theValue is String){
                                            
                                            nextLevel = theValue as! String
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                        
                        break
                
                    }
                    
                    counter++
                }
            }
        }
        
        return nextLevel
        
    }
    
    
    static func getMaxLevels( levelsName:String) -> Int {
        

        let path = NSBundle.mainBundle().pathForResource("LevelData", ofType: "plist")
        
        let dict:NSDictionary = NSDictionary(contentsOfFile: path!)!
        
        if (dict.objectForKey(levelsName) != nil) {
            
            if let levelData = dict.objectForKey(levelsName) as? [AnyObject] {
                
                maxLevels = levelData.count
                
              
            }
        }
        
        return maxLevels
        
    }

    
    
    
    static func colorFromHexString(rgba:String) -> UIColor {
        
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        
        
        if rgba.hasPrefix("#") {
            
            let hex:String = rgba.stringByReplacingOccurrencesOfString(
                "#",
                withString: "")
            
            
            let scanner = NSScanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                
                
            } else {
                
                print("Scan hex error")
                
            }
        } else {
            
            print("Invalid RGB string, missing '#' as prefix")
            
        }
        
        let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        return color
        
    }
    
}
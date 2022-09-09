//
//  Blacklist.swift
//  MAULibrary
//
//  Created by Thalia Aquino on 02/09/22.
//

import Foundation

struct Blacklist {
    static let block = ["920", "A01", "A02","A03", "A04", "A05", "A08", "A09", "A25", "A60",
                        "A61", "A62", "A63", "A64", "A65", "A66", "A67", "A69", "A71", "A74",
                        "A75", "A76", "A77", "A73", "B01", "B02", "B05", "E67", "E69", "G60",
                        "G67", "M08", "M13", "M15", "M14", "M21", "M28"]
    
    static let tryAgain = ["A07", "A10", "A20", "A22", "A23", "A24", "A27", "A28", "A29", "A30",
                           "A31", "A32", "A33", "A34", "A35", "A36", "A37", "A38", "A39", "A40",
                           "A41", "A42", "A43", "A44", "A45", "A46", "A47", "A48", "A49", "A50",
                           "A51", "A52", "A53", "A54", "A55", "A56", "A57", "A58", "A68", "B06",
                           "B96", "E27", "E89", "G67", "G64", "M06", "A26"]
    
    static let special = "A12"
    
    static func checkSpecialCase(list: [String]) -> Bool {
        return list.contains { code in
            return code == special
        }
    }
    
    static func checkBlockApp(list: [String]) -> Bool {
        for op in list {
            let b = block.contains { code in
                return code == op
            }
            
            if b {
                return true
            }
        }
        
        return false
    }
    
    static func checkTryAgain(list: [String]) -> Bool {
        for op in list {
            let b = tryAgain.contains { code in
                return code == op
            }
            
            if b {
                return true
            }
        }
        
        return false
    }
}

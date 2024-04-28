//
//  Bundle+.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/12/24.
//

import Foundation

extension Bundle {
    var apiKey: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile: file),
              let key = resource["API_KEY"] as? String else {
            return nil
        }
        return key
    }
    
    var youthcenterAPIkey: String? {
        guard let file = self.path(forResource: "Secrets", ofType: "plist"),
              let resource = NSDictionary(contentsOfFile:  file),
              let key = resource["YouthCenter_API_KEY"] as? String else {
            return nil
        }
        return key
    }
}

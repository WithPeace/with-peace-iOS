//
//  String+.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/22/24.
//

import Foundation

extension String {
    
    /// 한글 + 영어 조합만 사용 가능
    func koreaLangCheck() -> Bool {
        let pattern = "^[가-힣a-zA-Z]*$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
            let range = NSRange(location: 0, length: self.utf16.count)
            if regex.firstMatch(in: self, options: [], range: range) != nil {
                return true
            }
        }
        return false
    }
}

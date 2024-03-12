//
//  Const.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/12/24.
//

import Foundation

struct Const {
    private init() {}
}

//MARK: - Color
extension Const {
    struct CustomColor {
        private init() {}
        
        struct BrandColor1 {
            private init() {}
            
            static let mainPink = "Main_Pink"
            static let subPink = "Sub_Pink"
            static let subApricot = "Sub_Apricot"
            static let subBlue = "Sub_Blue"
        }
        
        struct BrandColor2 {
            private init() {}
            
            static let mainPurple = "Main_Purple"
            static let subPurple = "Sub_Purple"
            static let subSkyblue = "Sub_Skyblue"
            static let subBluegreen = "Sub_Bluegreen"
        }
        
        struct SystemColor {
            private init() {}
            
            static let black = "Black"
            static let gray1 = "Gray1"
            static let gray2 = "Gray2"
            static let gray3 = "Gray3"
            static let error = "Error"
            static let success = "Success"
        }
    }
}

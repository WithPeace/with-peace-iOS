//
//  Const.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/12/24.
//

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
            
            static let black = "BlackCustom"
            static let gray1 = "Gray1"
            static let gray2 = "Gray2"
            static let gray3 = "Gray3"
            static let error = "Error"
            static let success = "Success"
        }
    }
}

extension Const {
    struct CustomIcon {
        private init() {}
        
        struct ICBtnPostcreate {
            private init() {}
            
            static let btnPostcreateDoneSelect  = "btn-postcreate-done-select"
            static let btnPostcreateDone = "btn-postcreate-done"
            static let icSelect = "ic-select"
            static let icSignBack = "ic-sign-back"
            static let icCamera = "ic-camera"
        }
        
        struct ICCate {
            private init() {}
            
            static let icCateecoSelect = "ic-cate-eco-select"
            static let icCateeco = "ic-cate-eco"
            static let icCateFreeSelect = "ic-cate-free-select"
            static let icCateFree = "ic-cate-free"
            static let icCateHobbySelect = "ic-cate-hobby-select"
            static let icCateHobby = "ic-cate-hobby"
            static let icCateInfoSelect = "ic-cate-info-select"
            static let icCateInfo = "ic-cate-info"
            static let icCateLivingSelect = "ic-cate-living-select"
            static let icCateLiving = "ic-cate-living"
            static let icCateQuestionSelect = "ic-cate-question-select"
            static let icCateQuestion = "ic-cate-question"
        }
        
        struct ICCell {
            private init() {}
            
            static let btnPictureDelete = "btn-picture-delete"
            static let icPictureSelect = "ic-picture-select"
        }
        
        struct ICNavigationTabbar {
            private init() {}
            
            static let icBoardSelect = "ic-board-select"
            static let icBoard = "ic-board"
            static let icHomeSelect = "ic-home-select"
            static let icHome = "ic-home"
            static let icMypageSelect = "ic-mypage-select"
            static let icMypage = "ic-mypage"
            static let icRegist = "ic-regist"
        }
    }
}

extension Const {
    struct Logo {
        private init() {}
        
        struct MainLogo {
            private init() {}
            
            static let withpeaceLogo = "withpeace_Logo"
            static let googleLogo = "google_Logo"
            static let appleLogo = "apple_Logo"
        }
    }
}

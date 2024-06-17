//
//  YouthFilterData.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/24/24.
//

struct YouthFilterData: Equatable {
    var display: Int = 10
    var pageIndex: Int = 1
    var srchPolicyId: String? = nil
    var query: Quary? = nil
    var bizTycdSel: [BizTycdSel]? = nil
    var srchPolyBizSecd: [SrchPolyBizSecd]? = nil
    var keyword: [String]? = nil
}

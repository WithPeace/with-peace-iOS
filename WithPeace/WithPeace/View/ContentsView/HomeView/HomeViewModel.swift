//
//  HomeViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/9/24.
//

import Foundation
import RxSwift

//TODO: Page Index 관리에 대한 고민

struct FilteredData:Equatable {
    let display: Int = 10
    let pageIndex: Int = 1
    let srchPolicyId: String? = nil
    let query: Quary? = nil
    let bizTycdSel: [BizTycdSel]? = nil
    let srchPolyBizSecd: [SrchPolyBizSecd]? = nil
    let keyword: [String]? = nil
}

final class HomeViewModel {
    private let youthCenterRepository = YouthCenterRepository()
    
    private let disposeBag = DisposeBag()
    
    private let fetchDisplayDataCount = 10
    private var nowPageIndex = 1
    private let pageIndex = BehaviorSubject<Int>(value: 1)
    
    // INPUT
    let fetchAdditional: PublishSubject<Void>
    let refreshAction: PublishSubject<Void>
    let changeFilter = BehaviorSubject<FilteredData>(value: FilteredData())
    
    // OUTPUT
    let youthData = BehaviorSubject(value: [YouthPolicy]())
    let indicatorViewControll = PublishSubject<Void>()
    let refreshControll = PublishSubject<Void>()
    
    init() {
        let requesting = PublishSubject<Void>()
        let refreshing = PublishSubject<Void>()
        
        // requesting
        fetchAdditional = requesting.asObserver()
        refreshAction = refreshing.asObserver()
        
        //최초 진입 시 데이터 fetch
        self.youthCenterRepository.perform(display: fetchDisplayDataCount,
                                           pageIndex: nowPageIndex,
                                           srchPolicyId: nil,
                                           query: nil,
                                           bizTycdSel: nil,
                                           srchPolyBizSecd: nil,
                                           keyword: nil) { result in
            switch result {
            case .success(let data):
                self.youthData.onNext(data.youthPolicy)
                self.indicatorViewControll.onNext(())
                self.nowPageIndex += 1
            case .failure(let error):
                print(error)
            }
        }
        
        // 필터 상태에 따른 fetch (데이터 추가)
        fetchAdditional.withLatestFrom(changeFilter)
            .subscribe(onNext: { filterData in
                //TODO: pageIndex관리
                self.nowPageIndex += 1
                self.youthCenterRepository.perform(display: self.fetchDisplayDataCount,
                                                   pageIndex: self.nowPageIndex,
                                                   srchPolicyId: filterData.srchPolicyId,
                                                   query: filterData.query,
                                                   bizTycdSel: filterData.bizTycdSel,
                                                   srchPolyBizSecd: filterData.srchPolyBizSecd,
                                                   keyword: filterData.keyword) { result in
                    switch result {
                    case .success(let data):
                        if let currentData = try? self.youthData.value() {
                            self.youthData.onNext(currentData + data.youthPolicy)
                        } else {
                            self.youthData.onNext(data.youthPolicy)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }).disposed(by: disposeBag)
        
        // refresh Aciton
        
        refreshAction.withLatestFrom(changeFilter)
            .subscribe(onNext: { filterData in
                //TODO: pageIndex관리
                self.nowPageIndex = 1
                self.youthCenterRepository.perform(display: self.fetchDisplayDataCount,
                                                   pageIndex: 1,
                                                   srchPolicyId: filterData.srchPolicyId,
                                                   query: filterData.query,
                                                   bizTycdSel: filterData.bizTycdSel,
                                                   srchPolyBizSecd: filterData.srchPolyBizSecd,
                                                   keyword: filterData.keyword) { result in
                    switch result {
                    case .success(let data):
                        self.youthData.onNext(data.youthPolicy)
                        self.refreshControll.onNext(())
                    case .failure(let error):
                        print(error)
                  
                    }
                }
            }).disposed(by: disposeBag)
        
        changeFilter.subscribe(onNext: { filteredData in
            //TODO: pageIndex관리
            self.nowPageIndex = 1
            self.youthCenterRepository.perform(display: self.fetchDisplayDataCount,
                                               pageIndex: 1,
                                               srchPolicyId: filteredData.srchPolicyId,
                                               query: filteredData.query,
                                               bizTycdSel: filteredData.bizTycdSel,
                                               srchPolyBizSecd: filteredData.srchPolyBizSecd,
                                               keyword: filteredData.keyword) { result in
                switch result {
                case .success(let data):
                    self.youthData.onNext(data.youthPolicy)
                case .failure(let error):
                    print(error)
                }
            }
        }).disposed(by: disposeBag)
    }
}

/*
 display: Int, 출력건 10~100
 pageIndex: Int = 1, 조회 페이지
 srchPolicyId: String?, 정책 id -> 상세 구현시 필요
 query: Quary? = nil, 정책명, 정책소개 정보검색
 bizTycdSel: [BizTycdSel]? = nil, 정책유형 5개
 srchPolyBizSecd: [SrchPolyBizSecd]? = nil, 시도 코드
 keyword: [String]? = nil,
 */


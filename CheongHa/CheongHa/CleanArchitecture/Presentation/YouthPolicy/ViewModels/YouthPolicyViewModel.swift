//
//  YouthPolicyViewModel.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/9/24.
//

import Foundation
import RxSwift
import RxCocoa

//TODO: Page Index 관리에 대한 고민
final class YouthPolicyViewModel {
    private let youthCenterRepository = YouthCenterRepository()
    
    private let disposeBag = DisposeBag()
    
    private let fetchDisplayDataCount = 10
    private var nowPageIndex = 1
    private let pageIndex = BehaviorSubject<Int>(value: 1)
    
    // INPUT
    let fetchAdditional: PublishSubject<Void>
    let refreshAction: PublishSubject<Void>
    let tapFilterButton = PublishSubject<Void>()
    let changeFilter = BehaviorSubject<YouthFilterData>(value: YouthFilterData())
    let itemTapped = PublishSubject<String>()
    
    // OUTPUT
    let youthData = BehaviorSubject(value: [YouthPolicy]())
    let youthPolicies = BehaviorRelay<[PolicyData]>(value: [])
    let indicatorViewControll = PublishSubject<Void>()
    let refreshControll = PublishSubject<Void>()
    let popModal = PublishSubject<YouthFilterData>()
    let presentPolicyDetailVC = PublishRelay<PolicyDetailData?>()
    
    private let policyUsecase: PolicyUsecaseProtocol
    private let filterUsecase: FilterUsecaseProtocol
    
    init(
        policyUsecase: PolicyUsecaseProtocol,
        filterUsecase: FilterUsecaseProtocol
    ) {
        self.policyUsecase = policyUsecase
        self.filterUsecase = filterUsecase
        
        let requesting = PublishSubject<Void>()
        let refreshing = PublishSubject<Void>()
        
        // requesting
        fetchAdditional = requesting.asObserver()
        refreshAction = refreshing.asObserver()
        
        //최초 진입 시 데이터 fetch
        let query = FetchPoliciesQuery(pageIndex: nowPageIndex, display: fetchDisplayDataCount)
        policyUsecase.fetchPolicies(api: .fetchPolicies(query: query)).asObservable()
            .subscribe(with: self) { owner, policyDTO in
                guard let data = policyDTO.data else { return }
                owner.youthPolicies.accept(data)
                owner.indicatorViewControll.onNext(())
                owner.nowPageIndex += 1
            }
            .disposed(by: disposeBag)
        
        //최초 진입 시 데이터 fetch
//        self.youthCenterRepository.perform(display: fetchDisplayDataCount, // 10
//                                           pageIndex: nowPageIndex, // 1
//                                           srchPolicyId: nil,
//                                           query: nil,
//                                           bizTycdSel: nil,
//                                           srchPolyBizSecd: nil,
//                                           keyword: nil) { result in
//            switch result {
//            case .success(let data):
//                self.youthData.onNext(data.youthPolicy)
//                self.indicatorViewControll.onNext(())
//                self.nowPageIndex += 1
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        // 필터 상태에 따른 fetch (데이터 추가)
        fetchAdditional
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .withUnretained(self)
            .flatMap { owner, filterData in
                let query = FetchPoliciesQuery(
//                    region: "",
//                    classification: "",
                    pageIndex: owner.nowPageIndex,
                    display: owner.fetchDisplayDataCount
                )
                return policyUsecase.fetchPolicies(api: .fetchPolicies(query: query))
            }
            .subscribe(with: self) { owner, policyDTO in
                owner.nowPageIndex += 1
                
                guard let data = policyDTO.data else { return }
                owner.youthPolicies.accept(owner.youthPolicies.value + data)
            }
            .disposed(by: disposeBag)
        
//        // 필터 상태에 따른 fetch (데이터 추가)
//        fetchAdditional.withLatestFrom(changeFilter)
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { filterData in
//                //TODO: pageIndex관리
//                self.nowPageIndex += 1
//                self.youthCenterRepository.perform(display: self.fetchDisplayDataCount,
//                                                   pageIndex: self.nowPageIndex,
//                                                   srchPolicyId: filterData.srchPolicyId,
//                                                   query: filterData.query,
//                                                   bizTycdSel: filterData.bizTycdSel,
//                                                   srchPolyBizSecd: filterData.srchPolyBizSecd,
//                                                   keyword: filterData.keyword) { result in
//                    switch result {
//                    case .success(let data):
//                        if let currentData = try? self.youthData.value() {
//                            self.youthData.onNext(currentData + data.youthPolicy)
//                        } else {
//                            self.youthData.onNext(data.youthPolicy)
//                        }
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
//            }).disposed(by: disposeBag)

        refreshAction
            .withUnretained(self)
            .flatMap { owner, _ in
                let query = FetchPoliciesQuery(
//                    region: "",
//                    classification: "",
                    pageIndex: 1,
                    display: owner.fetchDisplayDataCount
                )
                return policyUsecase.fetchPolicies(api: .fetchPolicies(query: query))
            }
            .subscribe(with: self) { owner, policyDTO in
                guard let data = policyDTO.data else { return }
                owner.youthPolicies.accept(data)
                owner.refreshControll.onNext(())
            }
            .disposed(by: disposeBag)
        
//        // refresh Aciton
//        
//        refreshAction.withLatestFrom(changeFilter)
//            .subscribe(onNext: { filterData in
//                //TODO: pageIndex관리
//                self.nowPageIndex = 1
//                self.youthCenterRepository.perform(display: self.fetchDisplayDataCount,
//                                                   pageIndex: 1,
//                                                   srchPolicyId: filterData.srchPolicyId,
//                                                   query: filterData.query,
//                                                   bizTycdSel: filterData.bizTycdSel,
//                                                   srchPolyBizSecd: filterData.srchPolyBizSecd,
//                                                   keyword: filterData.keyword) { result in
//                    switch result {
//                    case .success(let data):
//                        self.youthData.onNext(data.youthPolicy)
//                        self.refreshControll.onNext(())
//                    case .failure(let error):
//                        print(error)
//                  
//                    }
//                }
//            }).disposed(by: disposeBag)
//        
//        changeFilter.subscribe(onNext: { filteredData in
//            //TODO: pageIndex관리
//            self.nowPageIndex = 1
//            self.youthCenterRepository.perform(display: self.fetchDisplayDataCount,
//                                               pageIndex: 1,
//                                               srchPolicyId: filteredData.srchPolicyId,
//                                               query: filteredData.query,
//                                               bizTycdSel: filteredData.bizTycdSel,
//                                               srchPolyBizSecd: filteredData.srchPolyBizSecd,
//                                               keyword: filteredData.keyword) { result in
//                switch result {
//                case .success(let data):
//                    self.youthData.onNext(data.youthPolicy)
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }).disposed(by: disposeBag)
//        
//        tapFilterButton.withLatestFrom(changeFilter)
//            .bind(to: popModal)
//            .disposed(by: disposeBag)
        
        itemTapped
            .withUnretained(self)
            .flatMap { owner, selectedPolicyId in
                let fetchPolicyParams = FetchPolicyParams(policyId: selectedPolicyId)
                return owner.policyUsecase.fetchPolicy(api: .fetchPolicy(params: fetchPolicyParams))
            }
            .subscribe(with: self) { owner, policyDetailDTO in
                guard let data = policyDetailDTO.data else { return }
                owner.presentPolicyDetailVC.accept(data)
            }
            .disposed(by: disposeBag)
    }
}
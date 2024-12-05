//
//  FilterViewModel.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/25/24.
//

import RxSwift
import RxCocoa

typealias FilterSectionType = [FilterSection:[FilterTagItem]]

final class FilterViewModel: ViewModelType {
    
    private let intialPolicyFieldSectionDatas: [FilterTagItem] = [
        .init(title: "일자리"),
        .init(title: "주거"),
        .init(title: "교육"),
        .init(title: "복지,문화"),
        .init(title: "참여,권리")
    ]
        
    private let initialRegionSectionDatas: [FilterTagItem] = [
        .init(title: "중앙부처"),
        .init(title: "서울"),
        .init(title: "부산"),
        .init(title: "대구"),
        .init(title: "인천"),
        .init(title: "광주"),
        .init(title: "대전"),
        .init(title: "울산"),
        .init(title: "경기"),
        .init(title: "강원"),
        .init(title: "충북"),
        .init(title: "충남"),
        .init(title: "전북"),
        .init(title: "전남"),
        .init(title: "경북"),
        .init(title: "경남"),
        .init(title: "제주"),
        .init(title: "세종")
    ]
    
    private lazy var initialSectionsValue: FilterSectionType = [
        .policyField: intialPolicyFieldSectionDatas,
        .separator: [.init()],
        .region: initialRegionSectionDatas
    ]
    
    private lazy var sections = BehaviorRelay<FilterSectionType>(value: initialSectionsValue)
    
    struct Input {
        let viewWillApear: Observable<Bool>
        let addPolicyTag: Observable<String>
        let addRegionTag: Observable<String>
        let cancelAllButtonTap: Observable<Void>
        let searchButtonTap: Observable<Void>
    }
    
    struct Output {
        let sections: Driver<FilterSectionType>
        let dismissSingal: Driver<Void>
    }
    
    var disposeBag = DisposeBag()
    
    private let filterUsecase: FilterUsecaseProtocol
    
    init(
        filterUsecase: FilterUsecaseProtocol
    ) {
        self.filterUsecase = filterUsecase
    }
    
    func transform(input: Input) -> Output {
        
        input.viewWillApear
            .withUnretained(self)
            .flatMap { owner, _ in
                owner.filterUsecase.fetchPolicyFilering()
            }
            .map { $0.data }
            .withLatestFrom(sections) { filteringData, sections in
                let selectedTags = (filteringData?.region ?? []) + (filteringData?.classification.map { $0.policyName } ?? [])
                let updatedSections = sections.mapValues { items in
                    return items.map { item in
                        var item = item
                        if selectedTags.contains(item.title) {
                            item.isSelected = true
                            return item
                        } else {
                            return item
                        }
                    }
                }
                return updatedSections
            }
            .bind(with: self) { owner, sections in
                owner.sections.accept(sections)
            }
            .disposed(by: disposeBag)
        
        input.addPolicyTag
            .withLatestFrom(sections) { selectedPolicyName, sections in
                var sections = sections
                sections[.policyField] = (sections[.policyField] ?? []).map {
                    var item = $0
                    if $0.title == selectedPolicyName {
                        item.isSelected.toggle()
                        return item
                    } else {
                        return $0
                    }
                }
                return sections
            }
            .bind(with: self) { owner, updatedSections in
                owner.sections.accept(updatedSections)
            }
            .disposed(by: disposeBag)
        
        input.addRegionTag
            .withLatestFrom(sections) { selectedRegionName, sections in
                var sections = sections
                sections[.region] = (sections[.region] ?? []).map {
                    var item = $0
                    if $0.title == selectedRegionName {
                        item.isSelected.toggle()
                        return item
                    } else {
                        return $0
                    }
                }
                return sections
            }
            .bind(with: self) { owner, updatedSections in
                owner.sections.accept(updatedSections)
            }
            .disposed(by: disposeBag)
        
        input.cancelAllButtonTap
            .bind(with: self) { owner, _ in
                owner.sections.accept(owner.initialSectionsValue)
            }
            .disposed(by: disposeBag)
        
        let dismissSingal = input.searchButtonTap
            .withLatestFrom(sections)
            .map { sections in
                let selectPolicyFieldTags = (sections[.policyField] ?? []).filter { $0.isSelected }.map { APIKeys.getPolicyCode(with: $0.title) }
                let selectRegionTags = (sections[.region] ?? []).filter { $0.isSelected }.map { APIKeys.getRegionCode(with: $0.title) }
                
                return ChangePolicyFileringQuery(regions: selectRegionTags, classifications: selectPolicyFieldTags)
            }
            .withUnretained(self)
            .flatMap { owner, query in
                owner.filterUsecase.changePolicyFilering(with: query)
            }
            .map { isChangeSucceed in
                guard let isChangeSucceed = isChangeSucceed.data else { return }
                if isChangeSucceed {
                    print("정책 필터링 성공")
                }
            }
    
        return Output(
            sections: sections.asDriver(onErrorJustReturn: [:]),
            dismissSingal: dismissSingal.asDriver(onErrorJustReturn: ())
        )
    }
}

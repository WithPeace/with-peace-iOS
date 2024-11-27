//
//  ViewModelType.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 11/7/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var disposeBag: DisposeBag { get }
    
    func transform(input: Input) -> Output
}

//
//  PostContentCell.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/28/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostContentCell: UITableViewCell {
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "내용을 입력해주세요"
        textView.textColor = .gray2
        textView.font = .systemFont(ofSize: 18, weight: .regular)
        textView.isScrollEnabled = false
        return textView
    }()
    
    var textViewDidChange: (() -> Void)?
    
    private var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configurConstraints()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    private func configurConstraints() {
        contentView.addSubview(contentTextView)
        
        contentTextView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(16)
            $0.horizontalEdges.equalToSuperview()
        }
    }
        
    private func bind() {        
        contentTextView.rx.didChange
            .bind(with: self) { owner, _ in
                owner.textViewDidChange?()
            }
            .disposed(by: disposeBag)
    }
    
    func setDatas(with data: String) {
        
    }
}

//
//  PostContentContainerView.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class PostContentContainerView: UIView {
    
    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "일찌기 나는 아무것도 아니었다."
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let postContentLabel: UILabel = {
        let label = UILabel()
        label.text = "돌아가는 팽이를 보고 싶어서, 그 팽이가 온전히 내 팽이이고 싶어서, 내 속도를 그대로 빼닮은 팽이의 회전을 여유롭게 관찰하고 싶어서, 그러니까 문방구에서 막상 팽이를 사오긴 했는데 요즘 누가 팽이 돌리나 눈치 보다 땅에다가는 못 풀고 눈으로 푸는 마음, 그 눈에서 돌아가는 팽이의 마음, 그거 시 같다."
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        [
            postTitleLabel,
            postContentLabel
        ].forEach { addSubview($0) }
        
        postTitleLabel.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        postContentLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(16)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}

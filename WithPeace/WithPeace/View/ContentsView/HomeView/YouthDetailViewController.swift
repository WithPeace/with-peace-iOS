//
//  YouthDetailViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/27/24.
//

import UIKit

final class YouthDetailViewController: UIViewController {
    
    private var titleChangeHeight: Double = .init()
    private let navigationTitle: String
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        return scrollView
    }()
    
    private let scrollContentsView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let topView: YouthDetailTopView = {
        let view = YouthDetailTopView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let firstView: YouthDetailContentView
    private let secondView: YouthDetailContentView
    private let thridView: YouthDetailContentView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        self.view.backgroundColor = .systemBackground
        self.scrollView.backgroundColor = .systemBackground
        self.scrollContentsView.backgroundColor = .systemBackground
        
        configureLeftBarButton()
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.titleChangeHeight = topView.calculateTitleHeight()
    }
    
    @objc
    func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureLeftBarButton() {
        let customBackButtonView = UIButton(type: .system)
        customBackButtonView.tintColor = .label
        customBackButtonView.setTitleColor(.label, for: .normal)
        customBackButtonView.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        customBackButtonView.sizeToFit()
        customBackButtonView.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let customBackButtonItem = UIBarButtonItem(customView: customBackButtonView)
        self.navigationItem.leftBarButtonItem = customBackButtonItem
    }
    
    init(youthPolicy: YouthPolicy) {
        var polyRlmCdToString = ""
        
        switch youthPolicy.polyRlmCd {
        case "023010":
            topView.setImage(UIImage(named: Const.Image.MainLogo.jobThumbnail))
            polyRlmCdToString = "일자리"
        case "023020":
            topView.setImage(UIImage(named: Const.Image.MainLogo.livingThumbnail))
            polyRlmCdToString = "주거"
        case "023030":
            topView.setImage(UIImage(named: Const.Image.MainLogo.eduThumbnail))
            polyRlmCdToString = "교육"
        case "023040":
            topView.setImage(UIImage(named: Const.Image.MainLogo.cultureThumbnail))
            polyRlmCdToString = "복지.문화"
        case "023050":
            topView.setImage(UIImage(named: Const.Image.MainLogo.participationThumbnail))
            polyRlmCdToString = "참여.권리"
        default:
            topView.setImage(UIImage(named: Const.Logo.MainLogo.cheonghaMainLogo))
        }
        
        topView.setTitle(youthPolicy.polyBizSjnm)
        topView.setBody(youthPolicy.polyItcnCn)
        navigationTitle = youthPolicy.polyBizSjnm
        
        self.firstView = .init(contents: [("정책번호", youthPolicy.bizId),
                                          ("정책분야", polyRlmCdToString),
                                          ("지원내용", youthPolicy.sporCn)])
        self.secondView = .init(contents: [("연령", youthPolicy.ageInfo),
                                           ("거주지 및 소득", youthPolicy.prcpCn),
                                           ("학력", youthPolicy.accrRqisCn),
                                           ("특화분야", youthPolicy.splzRlmRqisCn),
                                           ("추가 단서 사항", youthPolicy.aditRscn),
                                           ("참여 제한 대상", youthPolicy.prcpLmttTrgtCn)
                                          ])
        self.thridView = .init(contents: [("신청절차", youthPolicy.rqutProcCn),
                                          ("심사 및 발표", youthPolicy.jdgnPresCn),
                                          ("신청 사이트", youthPolicy.rqutUrla),
                                          ("제출 서류", youthPolicy.pstnPaprCn)])
        
        
        super.init(nibName: nil, bundle: nil)
        
        firstView.setTitle("정책을 한 눈에 확인해보세요")
        secondView.setTitle("신청 자격을 확인하세요")
        thridView.setTitle("이렇게 신청하세요")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        
        //ScrollView
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        //ScrollContentsView
        scrollView.addSubview(scrollContentsView)
        NSLayoutConstraint.activate([
            scrollContentsView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollContentsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContentsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        
        //TopView
        scrollContentsView.addSubview(topView)
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: scrollContentsView.topAnchor),
            topView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor, constant: 24),
            topView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor, constant: -24),
        ])
        
        scrollContentsView.addSubview(firstView)
        scrollContentsView.addSubview(secondView)
        scrollContentsView.addSubview(thridView)
        
        NSLayoutConstraint.activate([
            firstView.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 16),
            firstView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            secondView.topAnchor.constraint(equalTo: firstView.bottomAnchor, constant: 24),
            secondView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor),
            secondView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            thridView.topAnchor.constraint(equalTo: secondView.bottomAnchor, constant: 24),
            thridView.leadingAnchor.constraint(equalTo: scrollContentsView.leadingAnchor),
            thridView.trailingAnchor.constraint(equalTo: scrollContentsView.trailingAnchor),
            thridView.bottomAnchor.constraint(equalTo: scrollContentsView.bottomAnchor)
        ])
    }
}

extension YouthDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        if offset > titleChangeHeight {
            self.navigationItem.title = navigationTitle
        } else {
            self.navigationItem.title = ""
        }
    }
}

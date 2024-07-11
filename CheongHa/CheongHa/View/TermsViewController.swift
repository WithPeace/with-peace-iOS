//
//  TermsViewController.swift
//  CheongHa
//
//  Created by Dylan_Y on 6/29/24.
//

import UIKit

final class TermsViewController: UIViewController, WebViewRequestDelegate {
    
    private let contentView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: Const.Logo.MainLogo.cheonghaMainLogo)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = 
        """
        청하(청춘하랑)에 어서오세요!
        약관에 동의하시면 청하와의 여정을
        시작할 수 있어요!
        """
        
        label.textColor = UIColor(named: Const.CustomColor.SystemColor.black)
        label.numberOfLines = 3
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let agreementView: TermsSubView = {
        let view = TermsSubView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        
        button.layer.cornerRadius = 9
        button.setTitleColor(.white, for: .normal)
        button.setTitle("다음으로", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor(named: Const.CustomColor.BrandColor2.mainPurple)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        nextButton.addTarget(self, action: #selector(tapNextButton), for: .touchUpInside)
        configureLayout()
        
        agreementView.privacyPolicyView.webViewDelegate = self
        agreementView.termsOfUseView.webViewDelegate = self
    }
    
    private func configureLayout() {
        [imageView, titleLabel, agreementView].forEach { contentView.addSubview($0) }
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            imageView.widthAnchor.constraint(equalToConstant: 120),
            
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 24),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            agreementView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            agreementView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            agreementView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            agreementView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            agreementView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        view.addSubview(contentView)
        view.addSubview(nextButton)
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: safe.topAnchor, constant: 50),
            contentView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            contentView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
            
            nextButton.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -24),
            nextButton.bottomAnchor.constraint(equalTo: safe.bottomAnchor, constant: -40),
            nextButton.heightAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    @objc
    func tapNextButton() {
        if agreementView.allCheck {
            //TODO: NextPage
            DispatchQueue.main.async {
                let loginNickNameViewController = LoginNickNameViewController()
                self.navigationController?.pushViewController(loginNickNameViewController, animated: true)
            }
        } else {
            ToastMessageView(superView: self.view).presentStandardToastMessage("약관에 동의해주세요.")
        }
    }
    
    func pushView(urlString: String) {
        navigationController?.pushViewController(WebViewAssistantViewController(urlString: urlString),
                                                 animated: true)
    }
}

final class TermsSubView: UIView, CheckButtonSendable {
    
    private(set) var allCheck = false
    
    private let allAgreeView = AllAgreementView()
    private let separatorView = CustomSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
    
    private let agreeStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private(set) var termsOfUseView = CheckButtonView("[필수] 서비스 이용약관",
                                                         url: Const.URL.URLLink.termsOfUse)
    private(set) var privacyPolicyView = CheckButtonView("[필수] 개인정보처리방침",
                                                            url: Const.URL.URLLink.privacyPolicy)
    
    lazy var subSelectingView = [termsOfUseView, privacyPolicyView]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        delegateSetting()
        gestureRegist()
        configureLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Delegate Method
    func selectStateSend(_ isChecked: Bool) {
        if termsOfUseView.isChecked && privacyPolicyView.isChecked {
            allCheck = true
            if !allAgreeView.isAllChecked {
                allAgreeView.changeState()
            }
        } else {
            allCheck = false
            if allAgreeView.isAllChecked {
                allAgreeView.changeState()
            }
        }
    }
    
    @objc
    func tapAllCheck() {
        if allAgreeView.isAllChecked {
            allCheck = false
            termsOfUseView.changing(check: false)
            privacyPolicyView.changing(check: false)
        } else {
            allCheck = true
            termsOfUseView.changing(check: true)
            privacyPolicyView.changing(check: true)
        }
        allAgreeView.changeState()
    }
    
    private func delegateSetting() {
        termsOfUseView.checkButtonDelegate = self
        privacyPolicyView.checkButtonDelegate = self
    }
    
    private func gestureRegist() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapAllCheck))
        
        allAgreeView.addGestureRecognizer(gesture)
        allAgreeView.isUserInteractionEnabled = true
    }
    
    private func configureLayout() {
        [allAgreeView, separatorView, agreeStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview($0)
        }
        
        agreeStackView.addArrangedSubview(termsOfUseView)
        agreeStackView.addArrangedSubview(privacyPolicyView)
        
        NSLayoutConstraint.activate([
            allAgreeView.topAnchor.constraint(equalTo: self.topAnchor),
            allAgreeView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            allAgreeView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            separatorView.topAnchor.constraint(equalTo: allAgreeView.bottomAnchor, constant: 24),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            
            agreeStackView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 22),
            agreeStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            agreeStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            agreeStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

final class AllAgreementView: UIView {
    
    private(set) var isAllChecked = false
    
    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Const.CustomIcon.ICCheckBox.icCheckboxEmpty)
        
        return imageView
    }()
    
    private let allAgreementLabel: UILabel = {
        let label = UILabel()
        
        label.text = "모두 동의"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeState() {
        DispatchQueue.main.async {
            if self.isAllChecked { // check -> uncheck
                self.checkBoxImageView.image = UIImage(named: Const.CustomIcon.ICCheckBox.icCheckboxFill)
                self.allAgreementLabel.font = .boldSystemFont(ofSize: 16)
            } else {
                self.checkBoxImageView.image = UIImage(named: Const.CustomIcon.ICCheckBox.icCheckboxEmpty)
                self.allAgreementLabel.font = .systemFont(ofSize: 16)
            }
        }
        
        isAllChecked.toggle()
    }
    
    private func configureLayout() {
        self.addSubview(checkBoxImageView)
        self.addSubview(allAgreementLabel)
        
        checkBoxImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        checkBoxImageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            checkBoxImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            checkBoxImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            
            allAgreementLabel.topAnchor.constraint(equalTo: self.topAnchor),
            allAgreementLabel.leadingAnchor.constraint(equalTo: checkBoxImageView.trailingAnchor, constant: 8),
            allAgreementLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            allAgreementLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

protocol CheckButtonSendable {
    func selectStateSend(_ isChecked: Bool)
}

protocol WebViewRequestDelegate {
    func pushView(urlString: String)
}

final class CheckButtonView: UIView {
    
    var checkButtonDelegate: CheckButtonSendable?
    var webViewDelegate: WebViewRequestDelegate?
    
    private(set) var isChecked: Bool = false
    private var urlString: String? = nil
    
    private let frontView: UIView = {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Const.CustomIcon.ICCheckBox.icCheckboxEmpty)
        
        return imageView
    }()
    
    private let termsLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .label
        label.text = "[필수] 약관"
        label.font = .systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let webViewButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor(named: Const.CustomColor.SystemColor.gray2), for: .normal)
        
        return button
    }()
    
    init(_ labelText: String, url: String? = nil) {
        if let urlString = url {
            self.urlString = urlString
        }
        
        super.init(frame: .zero)
        
        self.termsLabel.text = labelText
        configureLayout()
        
        webViewButton.addTarget(self, action: #selector(tapWebViewButton), for: .touchUpInside)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapFrontView))
        frontView.addGestureRecognizer(gesture)
        frontView.isUserInteractionEnabled = true
    }
    
    @objc
    func tapFrontView() {
        self.changeState()
        checkButtonDelegate?.selectStateSend(isChecked)
    }
    
    @objc
    func tapWebViewButton() {
        //TODO: WebView
        print("webview tab")
        webViewDelegate?.pushView(urlString: urlString!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changing(check: Bool) {
        if check != isChecked {
            changeState()
        }
    }
    
    private func changeState() {
        DispatchQueue.main.async {
            if self.isChecked {
                self.imageView.image = UIImage(named: Const.CustomIcon.ICCheckBox.icCheckboxFill)
                self.termsLabel.font = .boldSystemFont(ofSize: 16)
            } else {
                self.imageView.image = UIImage(named: Const.CustomIcon.ICCheckBox.icCheckboxEmpty)
                self.termsLabel.font = .systemFont(ofSize: 16)
            }
        }
        isChecked.toggle()
    }
    
    private func configureLayout() {
        frontView.addSubview(imageView)
        frontView.addSubview(termsLabel)
        
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: frontView.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: frontView.leadingAnchor),
            
            termsLabel.topAnchor.constraint(equalTo: frontView.topAnchor),
            termsLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 8),
            termsLabel.bottomAnchor.constraint(equalTo: frontView.bottomAnchor),
            termsLabel.trailingAnchor.constraint(equalTo: frontView.trailingAnchor),
        ])
        
        self.addSubview(frontView)
        self.addSubview(webViewButton)
        
        NSLayoutConstraint.activate([
            frontView.topAnchor.constraint(equalTo: self.topAnchor),
            frontView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            frontView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            webViewButton.topAnchor.constraint(equalTo: self.topAnchor),
            webViewButton.leadingAnchor.constraint(equalTo: frontView.trailingAnchor, constant: 8),
            webViewButton.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
}

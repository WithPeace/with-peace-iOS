//
//  YouthFilterViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/21/24.
//

import UIKit
import RxSwift

final class YouthFilterViewController: UIViewController {
    
    private let seperatorView: CustomProfileSeparatorView = {
        let view = CustomProfileSeparatorView(colorName: Const.CustomColor.SystemColor.gray3)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private let dismissButton: UIButton = {
        let button = UIButton()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = UIColor(named: Const.CustomColor.SystemColor.black)
        button.setImage(UIImage(named: Const.CustomIcon.ICController.icExit), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "필터"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    
    private let allClearButton: UIButton = {
        let button = UIButton()
        
        button.setTitleColor(.black, for: .normal)
        button.setTitle("전체 해제", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let searchDoneButton: UIButton = {
        let button = UIButton()
        
        button.backgroundColor = .mainPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.setTitle("검색하기", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private var dataSource: (biz: [(BizTycdSel, Bool)], srch: [(SrchPolyBizSecd, Bool)]) = {
        var biz = [(BizTycdSel, Bool)]()
        for bizItem in BizTycdSel.allCases {
            biz.append((bizItem, false))
        }
        
        var srch = [(SrchPolyBizSecd, Bool)]()
        for srchItem in SrchPolyBizSecd.allCases {
            srch.append((srchItem, false))
        }
        
        return (biz, srch)
    }()
    
    private var firstIsFold = true {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private var secondIsFold = true {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let viewMode = YouthFilterViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableViewSetting()
        configureLayout()
        addTargetMethod()
    }

    
    private func tableViewSetting() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.id)
    }
    
    private func configureLayout() {
        view.addSubview(dismissButton)
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(seperatorView)
        view.addSubview(allClearButton)
        view.addSubview(searchDoneButton)
        
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            dismissButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            dismissButton.widthAnchor.constraint(equalTo: dismissButton.heightAnchor),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dismissButton.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: dismissButton.trailingAnchor,constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: dismissButton.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: -81),
        ])
        
        NSLayoutConstraint.activate([
            seperatorView.heightAnchor.constraint(equalToConstant: 4),
            seperatorView.topAnchor.constraint(equalTo: tableView.bottomAnchor),
            seperatorView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            allClearButton.topAnchor.constraint(equalTo: seperatorView.bottomAnchor),
            allClearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            allClearButton.centerYAnchor.constraint(equalTo: searchDoneButton.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchDoneButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                       constant: -24),
            searchDoneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -16),
            
            searchDoneButton.widthAnchor.constraint(equalToConstant: 120),
            searchDoneButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func addTargetMethod() {
        dismissButton.addTarget(self, action: #selector(tapDismissButton), for: .touchUpInside)
        allClearButton.addTarget(self, action: #selector(tapAllClearButton), for: .touchUpInside)
        searchDoneButton.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
    }
    
    @objc
    private func tapDismissButton() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
    
    @objc
    private func tapAllClearButton() {
        dataSource = {
            var biz = [(BizTycdSel, Bool)]()
            for bizItem in BizTycdSel.allCases {
                biz.append((bizItem, false))
            }
            
            var srch = [(SrchPolyBizSecd, Bool)]()
            for srchItem in SrchPolyBizSecd.allCases {
                srch.append((srchItem, false))
            }
            
            return (biz, srch)
        }()
        
        tableView.reloadData()
    }
    
    @objc
    private func tapSearchButton() {
        DispatchQueue.main.async {
            self.dismiss(animated: true)
        }
    }
}

extension YouthFilterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if firstIsFold {
                return 3
            } else {
                return dataSource.biz.count
            }
        case 1:
            if secondIsFold {
                return 7
            } else {
                return dataSource.srch.count
            }
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.id) as? CustomCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            cell.changeContents(title: BizTycdSel.allCases[indexPath.row].koreanName,
                                isClicked: dataSource.biz[indexPath.row].1)
        case 1:
            cell.changeContents(title: SrchPolyBizSecd.allCases[indexPath.row].koreanName,
                                isClicked: dataSource.srch[indexPath.row].1)
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            dataSource.biz[indexPath.row].1.toggle()
        case 1:
            dataSource.srch[indexPath.row].1.toggle()
        default:
            return
        }
        
        tableView.deselectRow(at: indexPath, animated: false)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YouthFilterHeaderView()
        
        switch section {
        case 0:
            headerView.change(title: "정책분야")
        case 1:
            headerView.change(title: "지역")
        default:
            return nil
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let footerView = YouthFilterFooterView()
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapFirstSectionView))
            
            footerView.addGestureRecognizer(tapGesture)
            footerView.changeWill(isFold: firstIsFold)
            
            return footerView
        case 1:
            let footerView = YouthFilterFooterView()
            let tapGesture = UITapGestureRecognizer(target: self,
                                                    action: #selector(tapSecondSectionView))
            
            footerView.addGestureRecognizer(tapGesture)
            footerView.changeWill(isFold: secondIsFold)
            
            return footerView
        default:
            return nil
        }
    }
    
    // Height 정의
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        37
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        40
    }
    
    @objc
    private func tapFirstSectionView() {
        self.firstIsFold.toggle()
    }
    
    @objc
    private func tapSecondSectionView() {
        self.secondIsFold.toggle()
    }
}

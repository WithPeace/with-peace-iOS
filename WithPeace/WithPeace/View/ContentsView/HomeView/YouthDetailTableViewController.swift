//
//  YouthDetailTableViewController.swift
//  WithPeace
//
//  Created by Dylan_Y on 5/29/24.
//

import UIKit

@available(*, deprecated, renamed: "X", message: "사용금지")
final class YouthDetailTableViewController: UITableViewController {
    
    private let youthPolicy: YouthPolicy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = .mainPurple
        self.navigationItem.title = "정책 정보"
    }
    
    init(youthPolicy: YouthPolicy) {
        self.youthPolicy = youthPolicy
        super.init(nibName: nil, bundle: nil)
        
        self.tableView.separatorStyle = .none
        self.tableView.register(YouthDetailCell.self,
                                forCellReuseIdentifier: YouthDetailCell.identifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            3
        case 1:
            6
        case 2:
            4
        default:
            0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: YouthDetailCell.identifier, for: indexPath) as? YouthDetailCell else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                cell.setTitle("정책번호")
                cell.setBody(youthPolicy.bizId)
            case 1:
                cell.setTitle("정책분야")
                cell.setBody(youthPolicy.polyBizSecd)
            case 2:
                cell.setTitle("지원내용")
                cell.setBody(youthPolicy.sporCn)
            default:
                break
            }
            break
        case 1:
            switch indexPath.row {
            case 0:
                cell.setTitle("연령")
                cell.setBody(youthPolicy.ageInfo)
            case 1:
                cell.setTitle("거주지 및 소득")
                cell.setBody(youthPolicy.prcpCn)
            case 2:
                cell.setTitle("학력")
                cell.setBody(youthPolicy.accrRqisCn)
            case 3:
                cell.setTitle("특화분야")
                cell.setBody(youthPolicy.splzRlmRqisCn)
            case 4:
                cell.setTitle("추가 단서 사항")
                cell.setBody(youthPolicy.aditRscn)
            case 5:
                cell.setTitle("참여 제한 대상")
                cell.setBody(youthPolicy.prcpLmttTrgtCn)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                cell.setTitle("신청절차")
                cell.setBody(youthPolicy.rqutUrla)
            case 1:
                cell.setTitle("심사및발표")
                cell.setBody(youthPolicy.jdgnPresCn)
            case 2:
                cell.setTitle("신청사이트")
                cell.setBody(youthPolicy.rqutUrla)
            case 3:
                cell.setTitle("제출 서류")
                cell.setBody(youthPolicy.pstnPaprCn)
            default:
                break
            }
        default:
            break
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = YouthDetailHeaderView()
        
        switch section {
        case 0:
            headerView.setTitle("정책을 한 눈에 확인해보세요")
        case 1:
            headerView.setTitle("신청 자격을 확인하세요")
        case 2:
            headerView.setTitle("이렇게 신청하세요")
        default:
            return UIView()
        }
        
        return headerView
    }
}


//
//  YouthCenterRepository.swift
//  WithPeace
//
//  Created by Dylan_Y on 4/24/24.
//

import Foundation

final class YouthCenterRepository: NSObject {
    private var currentElement: String?
    private var youthPolicyList = YouthPolicyList(youthPolicy: [YouthPolicy]())
    private var currentYouth = YouthPolicy()
    
    /// YouthCenter API
    ///
    /// - Parameters:
    ///     - display : 출력 defaultValue = 10, max = 100,
    ///     - pageIndex : 조회 페이지, defaultValue = 1
    func perform(display: Int,
                 pageIndex: Int = 1,
                 srchPolicyId: String?,
                 query: Quary? = nil,
                 bizTycdSel: [BizTycdSel]? = nil,
                 srchPolyBizSecd: [SrchPolyBizSecd]? = nil,
                 keyword: [String]? = nil,
                 completion: @escaping (Result<YouthPolicyList, YouthCenterError>) -> Void) {
        
        guard let apiKey = Bundle.main.youthcenterAPIkey else {
            return
        }
        
        var urlQueryItem = [URLQueryItem(name: "openApiVlak", value: apiKey),
                            URLQueryItem(name: "display", value: String(display)),
                            URLQueryItem(name: "pageIndex", value: String(pageIndex))
        ]
        
        if let srchPolicyId = srchPolicyId {
            urlQueryItem.append(URLQueryItem(name: "srchPolicyId", value: srchPolicyId))
        }
        
        if let query = query {
            urlQueryItem.append(URLQueryItem(name: "query", value: query.rawValue))
        }
        
        if let bizTycdSel = bizTycdSel {
            let resultBiz = bizTycdSel.map { $0.rawValue }.joined(separator: ",")
            urlQueryItem.append(URLQueryItem(name: "bizTycdSel", value: resultBiz))
        }
        
        if let srchPolyBizSecd = srchPolyBizSecd {
            let resultSrch = srchPolyBizSecd.map { $0.rawValue }.joined(separator: ",")
            urlQueryItem.append(URLQueryItem(name: "srchPolyBizeSecd", value: resultSrch))
        }
        
        if let keyword = keyword {
            let resultKeyword = keyword.joined(separator: ",")
            urlQueryItem.append(URLQueryItem(name: "keyword", value: resultKeyword))
        }
        
        let endpoint = EndPoint(baseURL: "www.youthcenter.go.kr",
                                path: "/opi/youthPlcyList.do",
                                port: nil,
                                queryItems: urlQueryItem,
                                method: .get)
        
        NetworkManager.shared.fetchData(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                self.parseXML(xmlData: data)
                completion(.success(self.youthPolicyList))
            case .failure(let error):
                debugPrint("NETWORK Error: ", error)
                completion(.failure(.defaultError))
            }
        }
    }
}

extension YouthCenterRepository: XMLParserDelegate {
    
    // XML 데이터 파싱 메서드
    private func parseXML(xmlData: Data) {
        let parser = XMLParser(data: xmlData)
        parser.delegate = self
        parser.parse()
    }
    
    // 시작 태그를 만났을 때 호출
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
//        print("시작태그 호출 메서드")
    }
    
    // 요소 내용을 만났을 때 호출
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "pageIndex":
            youthPolicyList.pageIndex = string
        case "totalCnt":
            youthPolicyList.totalCnt = string
        case "rnum":
            currentYouth.rnum = string
        case "bizID":
            currentYouth.bizID = string
        case "polyBizSecd":
            currentYouth.polyBizSecd = string
        case "polyBizTy":
            currentYouth.polyBizTy = string
        case "polyBizSjnm":
            currentYouth.polyBizSjnm = string
        case "polyItcnCN":
            currentYouth.polyItcnCN = string
        case "sporCN":
            currentYouth.sporCN = string
        case "sporScvl":
            currentYouth.sporScvl = string
        case "bizPrdCN":
            currentYouth.bizPrdCN = string
        case "prdRpttSecd":
            currentYouth.prdRpttSecd = string
        case "rqutPrdCN":
            currentYouth.rqutPrdCN = string
        case "ageInfo":
            currentYouth.ageInfo = string
        case "majrRqisCN":
            currentYouth.majrRqisCN = string
        case "empmSttsCN":
            currentYouth.empmSttsCN = string
        case "splzRlmRqisCN":
            currentYouth.splzRlmRqisCN = string
        case "accrRqisCN":
            currentYouth.accrRqisCN = string
        case "prcpCN":
            currentYouth.prcpCN = string
        case "aditRscn":
            currentYouth.aditRscn = string
        case "prcpLmttTrgtCN":
            currentYouth.prcpLmttTrgtCN = string
        case "rqutProcCN":
            currentYouth.rqutProcCN = string
        case "pstnPaprCN":
            currentYouth.pstnPaprCN = string
        case "jdgnPresCN":
            currentYouth.jdgnPresCN = string
        case "rqutUrla":
            currentYouth.rqutUrla = string
        case "rfcSiteUrla1":
            currentYouth.rfcSiteUrla1 = string
        case "rfcSiteUrla2":
            currentYouth.rfcSiteUrla2 = string
        case "mngtMson":
            currentYouth.mngtMson = string
        case "mngtMrofCherCN":
            currentYouth.mngtMrofCherCN = string
        case "cherCtpcCN":
            currentYouth.cherCtpcCN = string
        case "cnsgNmor":
            currentYouth.cnsgNmor = string
        case "tintCherCN":
            currentYouth.tintCherCN = string
        case "tintCherCtpcCN":
            currentYouth.tintCherCtpcCN = string
        case "etct":
            currentYouth.etct = string
        case "polyRlmCD":
            currentYouth.polyRlmCD = string
        default:
            break
        }
    }
    
    // 끝 태그를 만났을 때 호출
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "youthPolicy" {
            youthPolicyList.youthPolicy.append(currentYouth)
        }
        
        currentElement = nil
//        print("끝태그 메서드")
    }
    
    // 파싱 완료 시 호출
    func parserDidEndDocument(_ parser: XMLParser) {
//        print("Parsing Success")
    }
}

//MARK: -Request Query
extension YouthCenterRepository {
    enum Quary: String {
        case polyBizSjnm
        case polyItcnCn
    }
    
    enum BizTycdSel: String {
        case job = "023010"
        case living = "023020"
        case edu = "023030"
        case culture = "023040"
        case participation = "023050"
    }
    
    enum SrchPolyBizSecd: String {
        case seoul = "003002001"
        case busan = "003002002"
        case daegu = "003002003"
        case incheon = "003002004"
        case gwangju = "003002005"
        case daejeon = "003002006"
        case ulsan = "003002007"
        case gyeonggi = "003002008"
        case gangwon = "003002009"
        case chungbuk = "003002010"
        case chungnam = "003002011"
        case jeonbuk = "003002012"
        case jeonnam = "003002013"
        case gyeongbuk = "003002014"
        case gyeongnam = "003002015"
        case jeju = "003002016"
        case sejong = "003002017"
        
        var koreanName: String {
            switch self {
            case .seoul:
                "서울"
            case .busan:
                "부산"
            case .daegu:
                "대구"
            case .incheon:
                "인천"
            case .gwangju:
                "광주"
            case .daejeon:
                "대전"
            case .ulsan:
                "울산"
            case .gyeonggi:
                "경기"
            case .gangwon:
                "강원"
            case .chungbuk:
                "충북"
            case .chungnam:
                "충남"
            case .jeonbuk:
                "전북"
            case .jeonnam:
                "전남"
            case .gyeongbuk:
                "경북"
            case .gyeongnam:
                "경남"
            case .jeju:
                "제주"
            case .sejong:
                "세종"
            }
        }
    }
}

//MARK: -DTO
extension YouthCenterRepository {
    
    enum YouthCenterError: Error {
        case defaultError
    }

    // MARK: YouthDTO
    struct YouthDTO {
        var youthPolicyList: YouthPolicyList
    }

    // MARK: YouthPolicyList
    struct YouthPolicyList {
        var pageIndex: String = ""
        var totalCnt: String = ""
        var youthPolicy: [YouthPolicy]
    }

    // MARK: YouthPolicy
    struct YouthPolicy {
        var rnum: String = ""
        var bizID: String = ""
        var polyBizSecd: String = ""
        var polyBizTy: String = ""
        var polyBizSjnm: String = ""
        var polyItcnCN: String = ""
        var sporCN: String = ""
        var sporScvl: String = ""
        var bizPrdCN: String = ""
        var prdRpttSecd: String = ""
        var rqutPrdCN: String = ""
        var ageInfo: String = ""
        var majrRqisCN: String = ""
        var empmSttsCN: String = ""
        var splzRlmRqisCN: String = ""
        var accrRqisCN: String = ""
        var prcpCN: String = ""
        var aditRscn: String = ""
        var prcpLmttTrgtCN: String = ""
        var rqutProcCN: String = ""
        var pstnPaprCN: String = ""
        var jdgnPresCN: String = ""
        var rqutUrla: String = ""
        var rfcSiteUrla1: String = ""
        var rfcSiteUrla2: String = ""
        var mngtMson: String = ""
        var mngtMrofCherCN: String = ""
        var cherCtpcCN: String = ""
        var cnsgNmor: String = ""
        var tintCherCN: String = ""
        var tintCherCtpcCN: String = ""
        var etct: String = ""
        var polyRlmCD: String = ""
    }
}

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
    
    private var result = YouthPolicyList(youthPolicy: [YouthPolicy]())
    
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
            urlQueryItem.append(URLQueryItem(name: "srchPolyBizSecd", value: resultSrch))
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
                completion(.success(self.result))
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
        
        

//        youthPolicyList = YouthPolicyList(youthPolicy: [YouthPolicy]())
//        currentYouth = YouthPolicy()
//        result = .init(youthPolicy: [YouthPolicy]())
        
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
        case "bizId":
            currentYouth.bizId = string
        case "polyBizSecd":
            currentYouth.polyBizSecd = string
        case "polyBizTy":
            currentYouth.polyBizTy = string
        case "polyBizSjnm":
            currentYouth.polyBizSjnm = string
        case "polyItcnCn":
            currentYouth.polyItcnCn = string
        case "sporCn":
            currentYouth.sporCn = string
        case "sporScvl":
            currentYouth.sporScvl = string
        case "bizPrdCn":
            currentYouth.bizPrdCn = string
        case "prdRpttSecd":
            currentYouth.prdRpttSecd = string
        case "rqutPrdCn":
            currentYouth.rqutPrdCn = string
        case "ageInfo":
            currentYouth.ageInfo = string
        case "majrRqisCn":
            currentYouth.majrRqisCn = string
        case "empmSttsCn":
            currentYouth.empmSttsCn = string
        case "splzRlmRqisCn":
            currentYouth.splzRlmRqisCn = string
        case "accrRqisCn":
            currentYouth.accrRqisCn = string
        case "prcpCn":
            currentYouth.prcpCn = string
        case "aditRscn":
            currentYouth.aditRscn = string
        case "prcpLmttTrgtCn":
            currentYouth.prcpLmttTrgtCn = string
        case "rqutProcCn":
            currentYouth.rqutProcCn = string
        case "pstnPaprCn":
            currentYouth.pstnPaprCn = string
        case "jdgnPresCn":
            currentYouth.jdgnPresCn = string
        case "rqutUrla":
            currentYouth.rqutUrla = string
        case "rfcSiteUrla1":
            currentYouth.rfcSiteUrla1 = string
        case "rfcSiteUrla2":
            currentYouth.rfcSiteUrla2 = string
        case "mngtMson":
            currentYouth.mngtMson = string
        case "mngtMrofCherCn":
            currentYouth.mngtMrofCherCn = string
        case "cherCtpcCn":
            currentYouth.cherCtpcCn = string
        case "cnsgNmor":
            currentYouth.cnsgNmor = string
        case "tintCherCn":
            currentYouth.tintCherCn = string
        case "tintCherCtpcCn":
            currentYouth.tintCherCtpcCn = string
        case "etct":
            currentYouth.etct = string
        case "polyRlmCd":
            currentYouth.polyRlmCd = string
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
        print("Parsing Success")
        result = youthPolicyList
        youthPolicyList = .init(youthPolicy: [YouthPolicy]())
    }
}

//MARK: -Request Query
//extension YouthCenterRepository {
enum Quary: String {
    case polyBizSjnm
    case polyItcnCn
}

enum BizTycdSel: String, CaseIterable {
    case job = "023010"
    case living = "023020"
    case edu = "023030"
    case culture = "023040"
    case participation = "023050"
    
    var koreanName: String {
        switch self {
        case .job:
            "일자리"
        case .living:
            "주거"
        case .edu:
            "교육"
        case .culture:
            "복지.문화"
        case .participation:
            "참여.권리"
        }
    }
}

enum SrchPolyBizSecd: String, CaseIterable {
    case centralMinistry = "003001004"
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
        case .centralMinistry:
            "중앙부처"
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
//}

//MARK: -DTO
extension YouthCenterRepository {
    
    enum YouthCenterError: Error {
        case defaultError
    }
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
    var bizId: String = ""
    var polyBizSecd: String = ""
    var polyBizTy: String = ""
    var polyBizSjnm: String = ""
    var polyItcnCn: String = ""
    var sporCn: String = ""
    var sporScvl: String = ""
    var bizPrdCn: String = ""
    var prdRpttSecd: String = ""
    var rqutPrdCn: String = ""
    var ageInfo: String = ""
    var majrRqisCn: String = ""
    var empmSttsCn: String = ""
    var splzRlmRqisCn: String = ""
    var accrRqisCn: String = ""
    var prcpCn: String = ""
    var aditRscn: String = ""
    var prcpLmttTrgtCn: String = ""
    var rqutProcCn: String = ""
    var pstnPaprCn: String = ""
    var jdgnPresCn: String = ""
    var rqutUrla: String = ""
    var rfcSiteUrla1: String = ""
    var rfcSiteUrla2: String = ""
    var mngtMson: String = ""
    var mngtMrofCherCn: String = ""
    var cherCtpcCn: String = ""
    var cnsgNmor: String = ""
    var tintCherCn: String = ""
    var tintCherCtpcCn: String = ""
    var etct: String = ""
    var polyRlmCd: String = ""
    
    
    //중앙부처 003001 6자리로 표현됨
    func region() -> String {
        let prefix = String(polyBizSecd.prefix(9))
        
        switch prefix {
        case "003001004":
            return "중앙부처"
        case "003002001":
            return "서울"
        case "003002002":
            return "부산"
        case "003002003":
            return "대구"
        case "003002004":
            return "인천"
        case "003002005":
            return "광주"
        case "003002006":
            return "대전"
        case "003002007":
            return "울산"
        case "003002008":
            return "경기"
        case "003002009":
            return "강원"
        case "003002010":
            return "충북"
        case "003002011":
            return "충남"
        case "003002012":
            return "전북"
        case "003002013":
            return "전남"
        case "003002014":
            return "경북"
        case "003002015":
            return "경남"
        case "003002016":
            return "제주"
        case "003002017":
            return "세종"
        default:
            return "중앙부처"
        }
    }
}

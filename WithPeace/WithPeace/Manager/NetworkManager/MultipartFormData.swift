//
//  MultipartFormData.swift
//  WithPeace
//
//  Created by Dylan_Y on 3/29/24.
//

import Foundation

/// Multipart Form Data
///
/// 데이터 메서드 사용후 generateData -> endpoint Body에 주입
struct MultipartFormData {
    private let boundary = "Boundary-\(UUID().uuidString)"
    private var data: Data
    
    /// 데이터 생성
    func generateData() -> Data {
        var combineData = self.data
        
        combineData.append("--\(boundary)--\r\n", using: .utf8)
        
        return combineData
    }
    
    /// String 갑 입력
    mutating func createFormFiled(name: String, value: String) {
        var appendingData = Data()
        
        appendingData.append("--\(boundary)\r\n", using: .utf8)
        appendingData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n", using: .utf8)
        appendingData.append("\(value)\r\n", using: .utf8)
        
        self.data.append(appendingData)
    }
    
    /// Dictionay Type 입력
    mutating func createFormFiled(contents: [String:String]) {
        var appendingData = Data()
        
        for content in contents {
            let name = content.key
            let value = content.value
            
            appendingData.append("--\(boundary)\r\n", using: .utf8)
            appendingData.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n", using: .utf8)
            appendingData.append("\(value)\r\n", using: .utf8)
        }
        
        self.data.append(appendingData)
    }
    
    //TODO: fileData, mimeType 추상화
    mutating func addFilesBodyData(fieldName: String,
                                 fileName: String,
                                 mimeType: String,
                                 fileData: Data) {
        var appendingData = Data()
        
        appendingData.append("--\(boundary)\r\n")
        appendingData.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        appendingData.append("Content-Type: \(mimeType)\r\n\r\n")
        appendingData.append(fileData)
        appendingData.append("\r\n")
        
        self.data.append(appendingData)
    }
}

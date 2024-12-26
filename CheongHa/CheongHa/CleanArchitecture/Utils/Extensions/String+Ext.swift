//
//  String+Ext.swift
//  CheongHa
//
//  Created by SUCHAN CHANG on 12/26/24.
//

import Foundation

extension String {
    var convertToTimeAgoDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // Locale 설정 (권장)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC") // 시간대 설정 (옵션)

        // 문자열을 Date로 변환
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
}

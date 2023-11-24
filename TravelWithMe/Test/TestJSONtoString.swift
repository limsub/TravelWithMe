//
//  TestJSONtoString.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/24.
//

import Foundation

// struct
struct TourDates: Codable {
    let dates: [String]
}

let sample = ["20230910", "20231028"]

func encoding() {
    do {
        let data = TourDates(dates: sample)
        let jsonData = try JSONEncoder().encode(data)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON 변환 성공, 서버에 데이터 전송")
        }
    } catch {
        print("에러 발생")
    }
}

func decoding() {
    do {
//        let data = "{\"strings\": [\"Four\", \"Five\", \"Six\"]}"
        
        let data = "{\"dates\": [\"20230910\", \"20231023\"]}"
        
        if let jsonData = data.data(using: .utf8) {
            let decodedData = try JSONDecoder().decode(TourDates.self, from: jsonData)
            let receivedArray = decodedData.dates

        }
    } catch {
        print("에러 발생")
    }
}

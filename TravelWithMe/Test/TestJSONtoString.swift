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

struct TourLocations: Codable {
    let latitude: Double
    let longtitude: Double
}

let sample = ["20230910", "20231028"]


func encodingStructToString<T: Codable>(sender: T) {
    do {
        let jsonData = try JSONEncoder().encode(sender)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print("JSON 변환 성공, 서버에 데이터 전송하기")
            print("JSON String : ", jsonString)
        }
    } catch {
        print("에러 발생")
    }
    
}

func decodingStringToStruct<T: Codable>(type: T.Type, sender: String) -> T? {
    do {
        if let jsonData = sender.data(using: .utf8) {
            let decodedData = try JSONDecoder().decode(T.self, from: jsonData)
            print("Struct 변환 성공")
            print("Struct 타입 데이터 : ", decodedData)
            return decodedData
        }
    } catch {
        print("에러 발생")
    }
    
    return nil
}


/* Test Code */
//// Struct -> String
//let a = TourDates(dates: ["20230109", "20230110", "20231010"])
//let b = TourLocations(latitude: 23.0909, longtitude: 243.1234)
//
//encodingStructToString(sender: a)
//encodingStructToString(sender: b)
//
//// {"dates":["20230109","20230110","20231010"]}
//// {"longtitude":243.1234,"latitude":23.090900000000001}
//
//
//// String -> Struct
//let c = """
//{"dates":["20230109","20230110","20231010"]}
//"""
//let d = """
//{"longtitude":243.1234,"latitude":23.090900000000001}
//"""
//
//let e = decodingStringToStruct(type: TourDates.self, sender: c)
//let f = decodingStringToStruct(type: TourLocations.self , sender: d)
//
//print(e?.dates)
//print(f?.latitude)
//print(f?.longtitude)

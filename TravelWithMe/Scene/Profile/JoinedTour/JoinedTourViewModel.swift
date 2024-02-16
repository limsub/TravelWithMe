//
//  JoinedTourViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/8/23.
//

import Foundation

struct JoinedTourForMonth {
    let month: String
    var tours: [Datum]
}

class JoinedTourViewModel: TourItemsProtocol2 {

    
    var tourItems: [JoinedTourForMonth] = []
    
    var nextCursor = ""
    
    
    func fetchData(completionHandler: @escaping (Result<LookPostResponse, Error>) -> Void) {
        
        RouterAPIManager.shared.requestNormal(
            type: LookPostResponse.self,
            error: LookPostAPIError.self,
            api: .lookPost(
                query: LookPostQueryString(
                    next: nextCursor,
                    limit: "100"
                ),
                likePost: true
            )) { response in
                
                // 성공
                // - (VC) : tableView reload
                // - (VM) : 데이터 가공
                                
                // 실패
                // - (VC) : 얼럿 or 로그인 화면(refreshTokenError)
                // - (VM) : 할게 없어.
                
                // 결국, 실패 시 error 분기처리를 굳이 VM에서 하고 있을 필요가 없다.
                
                switch response {
                case .success(let result):
                    print("좋아요 누른 게시글 조회 성공")
                    
                    self.tourItems = self.manufactureData(result.data)
                    
                    completionHandler(.success(result))
                case .failure(let error):
                    
                    completionHandler(.failure(error))
                }
            }
    }
    
    func manufactureData(_ sender: [Datum]) -> [JoinedTourForMonth] {
        
        // 1. sender를 dates의 firstDate 기준으로 정렬한다
        let sortedArr = sender.sorted { d1, d2 in
            // * (1). dates 배열 뽑아오기
            let d1FirstDate = decodingStringToStruct(
                type: TourDates.self,
                sender: d1.dates
            )?.dates.first
            let d2FirstDate = decodingStringToStruct(
                type: TourDates.self ,
                sender: d2.dates
            )?.dates.first
            
            // * (2). firstDate끼리 비교한다
            return d1FirstDate ?? ""  > d2FirstDate ?? ""
        }
        
        
        // 2. 배열을 순회하며 "yyyyM"을 키값으로 가지는 딕셔너리 생성
        var groupedTours: [String: [Datum]] = [:]
        
        for tour in sortedArr {
            if let firstDate = decodingStringToStruct(
                type: TourDates.self,
                sender: tour.dates
            )?.dates.first, let monthKey = firstDate.toDate(to: .full)?.toString(of: .yearMonth) {
                
                // 이미 있을 때
                if var group = groupedTours[monthKey] {
                    group.append(tour)
                    groupedTours[monthKey] = group
                }
                
                // 없을 때
                else {
                    groupedTours[monthKey] = [tour]
                }
            }
        }
        
        // 3. 딕셔너리를 합쳐서 [JoinedTourForMonth] 배열 생성
        var joinedTours = groupedTours.map { (key, value) in
            return JoinedTourForMonth(month: key, tours: value)
        }
        
        // 4. 배열 정렬
        joinedTours.sort { $0.month > $1.month }
        
//        print("--- 정렬 완료? ---")
//        print(joinedTours)
            
        return joinedTours
    }
    
}

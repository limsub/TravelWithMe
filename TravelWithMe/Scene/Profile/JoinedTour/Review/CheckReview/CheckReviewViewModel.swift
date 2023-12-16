//
//  CheckReviewViewModel.swift
//  TravelWithMe
//
//  Created by 임승섭 on 12/10/23.
//

import Foundation


class CheckReviewViewModel {
    
    var tourItem: Datum? = nil
    
    
    func deleteReview(indexPath: IndexPath, completionHandler: @escaping (Result<DeleteReviewResponse, Error>) -> Void) {
        
        guard let postID = tourItem?.id, let commentID = tourItem?.comments[indexPath.row]._id else { return }
        
        RouterAPIManager.shared.requestNormal(
            type: DeleteReviewResponse.self,
            error: DeleteReviewAPIError.self,
            api: .deleteReview(postID: postID, commentID: commentID)) { response in
                switch response {
                case .success(let result):
                    completionHandler(.success(result))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
    }
}

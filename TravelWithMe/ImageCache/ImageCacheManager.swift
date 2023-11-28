//
//  ImageCacheManager.swift
//  TravelWithMe
//
//  Created by 임승섭 on 2023/11/28.
//

import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() { }
    
    
    
}

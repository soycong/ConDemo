//
//  DotRatingViewModel.swift
//  ConDemo
//
//  Created by 이명지 on 4/23/25.
//

import UIKit

final class DotRatingViewModel {
    private var ratingData: DotRatingData
    
    var title: String { ratingData.title }
    
    var myRating: Int { ratingData.myRating }
    
    var yourRating: Int { ratingData.yourRating }
    
    var labels: [String] { ratingData.labels }
    
    init(ratingData: DotRatingData) {
        self.ratingData = ratingData
    }
}

extension DotRatingViewModel {
    func updateData(_ ratingData: DotRatingData) {
        self.ratingData = ratingData
    }
}

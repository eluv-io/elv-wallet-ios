//
//  StarsView.swift
//  EluvioLiveIOS
//
//  Created by Wayne Tran on 2021-10-08.
//

import SwiftUI

struct StarsView: View {
  private static let MAX_RATING: Float = 5 // Defines upper limit of the rating
  let color = Color.indigo // The color of the stars
    let size: CGFloat
  let rating: Float
  private let fullCount: Int
  private let emptyCount: Int
  private let halfFullCount: Int

  init(size: CGFloat, rating: Float) {
    self.size = size
    self.rating = rating
    fullCount = Int(rating)
    emptyCount = Int(StarsView.MAX_RATING - rating)
    halfFullCount = (Float(fullCount + emptyCount) < StarsView.MAX_RATING) ? 1 : 0
  }

  var body: some View {
    HStack {
      ForEach(0..<fullCount) { _ in
         self.fullStar
       }
       ForEach(0..<halfFullCount) { _ in
         self.halfFullStar
       }
       ForEach(0..<emptyCount) { _ in
         self.emptyStar
       }
     }
  }

  private var fullStar: some View {
    Image(systemName: "star.fill")
          .resizable()
          .aspectRatio(contentMode:.fit)
          .frame(width:size)
          .foregroundColor(color)
  }

  private var halfFullStar: some View {
      Image(systemName: "star.lefthalf.fill")
          .resizable()
          .aspectRatio(contentMode:.fit)
          .frame(width:size)
          .foregroundColor(color)
  }

  private var emptyStar: some View {
    Image(systemName: "star")
          .resizable()
          .aspectRatio(contentMode:.fit)
          .frame(width:size)
          .foregroundColor(color)
  }
}

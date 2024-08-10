//
//  RootView.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation
import SwiftUI

public struct RootView: View {
    private let newsUseCase: NewsUseCase

    public init(newsUseCase: NewsUseCase) {
        self.newsUseCase = newsUseCase
    }

    public var body: some View {
        Text("RootView")
    }
}

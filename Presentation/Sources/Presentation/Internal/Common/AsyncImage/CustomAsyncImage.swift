//
//  CustomAsyncImage.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import SwiftUI

struct CustomAsyncImage: View {
    let url: URL

    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 12))
            } else if phase.error != nil {
                Image(systemName: "questionmark.diamond")
                    .imageScale(.large)
            } else {
                ProgressView()
            }
        }
    }
}

#Preview {
    CustomAsyncImage(url: URL(string: "https://media.wired.com/photos/66b3cac3a922a7712a7c43e0/191:100/w_1280,c_limit/Crash-Reports-Sec-140000036.jpg")!)
}

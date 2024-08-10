//
//  Text+.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import SwiftUI

extension Text {
    init(markdown: String) {
        self.init(LocalizedStringKey(markdown))
    }
}

#Preview {
    VStack {
        Text(markdown: "Regular")
        Text(markdown: "*Italic*")
        Text(markdown: "**Bold**")
    }
}

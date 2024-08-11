//
//  Text+.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import SwiftUI

extension Text {
    /// Creates a text view that displays markdowns.
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

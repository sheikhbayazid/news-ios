//
//  EmptyStateView.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import SwiftUI

enum EmptyStateType {
    case noData
    case networkError
}

struct EmptyStateView: View {
    let type: EmptyStateType

    var body: some View {
        ContentUnavailableView {
            Label(labelTitle, systemImage: labelSymbol)
        } description: {
            Text(description)
        }
    }

    var labelTitle: String {
        switch type {
        case .noData:
            "No Data"

        case .networkError:
            "Network Error"
        }
    }

    var labelSymbol: String {
        switch type {
        case .noData:
            "book"

        case .networkError:
            "wifi.slash"
        }
    }

    var description: String {
        switch type {
        case .noData:
            "Could not find any data. Please try again later."

        case .networkError:
            "Oops, something went wrong. Please try again later"
        }
    }
}

#Preview {
    VStack {
        EmptyStateView(type: .noData)
        EmptyStateView(type: .networkError)
    }
}

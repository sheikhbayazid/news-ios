//  swiftlint:disable line_length
//
//  PreviewNewsUseCase.swift
//  Presentation
//
//  Created by Sheikh Bayazid on 2024-08-10.
//

import AppFoundation

final class PreviewNewsUseCase: NewsUseCase {
    func getAllNewsArticles() async throws -> [NewsArticle] {
        [
            .init(
                source: .init(
                    id: nil,
                    name: "Apple 1"
                ),
                author: "Steve Wozniak",
                title: "Apple I",
                description: "The Apple Computer 1, later known predominantly as the Apple I, is an 8-bit motherboard-only personal computer designed by Steve Wozniak and released by the Apple Computer Company in 1976.",
                url: "https://en.wikipedia.org/wiki/Apple_I",
                urlToImage: "https://unsplash.com/photos/black-and-white-digital-device-PHH_0uw9-Qw",
                publishedAt: .now,
                content: "The Apple Computer 1 (Apple-1[a]), later known predominantly as the Apple I (written with a Roman numeral),[b] is an 8-bit motherboard-only personal computer designed by Steve Wozniak[5][6] and released by the Apple Computer Company (now Apple Inc.) in 1976. The company was initially formed to sell the Apple I – its first product – and would later become the world's largest technology company.[7] The idea of starting a company and selling the computer came from Wozniak's friend and Apple co-founder Steve Jobs.[8][9] One of the main innovations of the Apple I was that it included video display terminal circuitry and a keyboard interface on a single board, allowing it to connect to a low-cost composite video monitor instead of an expensive computer terminal, compared to most existing computers at the time. It was one of the first computers to have such video output, released at about the same time as the Sol-20, which has similar capability."
            ),
            .init(
                source: .init(
                    id: nil,
                    name: "Apple 2"
                ),
                author: "Steve Wozniak",
                title: "Apple II",
                description: "The Apple II series of microcomputers was initially designed by Steve Wozniak, manufactured by Apple Computer, and launched in 1977 with the Apple II model that gave the series its name. It was followed by the Apple II Plus, Apple IIe, Apple IIc, and Apple IIc Plus, with the 1983 IIe being the most popular..",
                url: "https://en.wikipedia.org/wiki/Apple_II",
                urlToImage: nil,
                publishedAt: .now,
                content: "The Apple II series of microcomputers was initially designed by Steve Wozniak, manufactured by Apple Computer (now Apple Inc.), and launched in 1977 with the Apple II model that gave the series its name. It was followed by the Apple II Plus, Apple IIe, Apple IIc, and Apple IIc Plus, with the 1983 IIe being the most popular. The name is trademarked with square brackets as Apple ][, then, beginning with the IIe, as Apple //. In terms of ease of use, features, and expandability, the Apple II was a major advancement over its predecessor, the Apple I, a limited-production bare circuit board computer for electronics hobbyists."
            )
        ]
    }
}

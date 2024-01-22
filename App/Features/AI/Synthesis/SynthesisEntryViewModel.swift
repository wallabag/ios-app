//
//  SynthesisEntryViewModel.swift
//  wallabag
//
//  Created by maxime marinel on 22/01/2024.
//

import Factory
import Foundation

final class SynthesisEntryViewModel: ObservableObject {
    @Injected(\.chatAssistant) private var chatAssistant
    @Published var synthesis = ""
    @Published var isLoading = false

    @MainActor
    func generateSynthesis(from entry: Entry) async throws {
        defer {
            isLoading = false
        }
        isLoading = true

        guard let content = entry.content?.withoutHTML else { return }

        synthesis = try await chatAssistant.generateSynthesis(content: content)
    }
}

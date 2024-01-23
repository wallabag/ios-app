//
//  TagSuggestionViewModel.swift
//  wallabag
//
//  Created by maxime marinel on 22/01/2024.
//

import Factory
import Foundation

final class TagSuggestionViewModel: ObservableObject {
    @Injected(\.wallabagSession) private var wallabagSession
    @Injected(\.chatAssistant) private var chatAssistant
    @Published var suggestions: [String] = []
    @Published var isLoading = false
    @Published var addingTags = false
    @Published var tagSelections = Set<String>()

    @MainActor
    func generateTags(from entry: Entry) async throws {
        defer {
            isLoading = false
        }
        isLoading = true

        guard let content = entry.content?.withoutHTML else { return }

        suggestions = try await chatAssistant.generateTags(content: content)
    }

    @MainActor
    func addTags(to entry: Entry) async throws {
        defer {
            addingTags = false
        }
        addingTags = true
        for tag in tagSelections {
            try await wallabagSession.add(tag: tag, for: entry)
        }
    }
}

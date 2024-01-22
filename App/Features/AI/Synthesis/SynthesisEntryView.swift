//
//  SynthesisEntryView.swift
//  wallabag
//
//  Created by maxime marinel on 11/12/2023.
//

import Factory
import SwiftUI

struct SynthesisEntryView: View {
    @StateObject private var viewModel = SynthesisEntryViewModel()
    let entry: Entry

    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                Text("Your assistant is working")
                ProgressView()
            } else {
                Text(viewModel.synthesis)
                    .padding()
                    .fontDesign(.serif)
            }
        }
        .navigationTitle("Synthesis")
        .task {
            do {
                try await viewModel.generateSynthesis(from: entry)
            } catch {
                print(error)
            }
        }
    }
}

// #Preview {
//    SynthesisEntryView(entry: .)
// }

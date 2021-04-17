import Combine
import Foundation
import SharedLib

class SearchViewModel: ObservableObject {
    @Published var search: String = ""
    @Published var retrieveMode = RetrieveMode(fromCase: WallabagUserDefaults.defaultMode)

    @Published var predicate = NSPredicate(value: true)

    var cancellable = Set<AnyCancellable>()

    init() {
        let searchThrottle = $search
            .debounce(for: 1.5, scheduler: DispatchQueue.main)
            .eraseToAnyPublisher()

        Publishers.CombineLatest($retrieveMode, searchThrottle)
            .sink { retrieveMode, search in
                if search != "" {
                    let predicateTitle = NSPredicate(format: "title CONTAINS[cd] %@", search)
                    let predicateContent = NSPredicate(format: "content CONTAINS[cd] %@", search)

                    let predicateCompound = NSCompoundPredicate(orPredicateWithSubpredicates: [predicateTitle, predicateContent])
                    self.predicate = predicateCompound
                } else {
                    self.predicate = retrieveMode.predicate()
                }
            }.store(in: &cancellable)
    }
}

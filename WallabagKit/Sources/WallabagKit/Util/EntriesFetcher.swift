import Foundation

public struct EntriesFetcher: AsyncSequence, AsyncIteratorProtocol {
    public typealias SyncProgress = Float
    public typealias Element = ([WallabagEntry], SyncProgress)
    private var page = 1
    private var perPage = 50
    private var kit: WallabagKit

    public init(_ kit: WallabagKit) {
        self.kit = kit
    }

    public mutating func next() async throws -> ([WallabagEntry], SyncProgress)? {
        try await fetchData()
    }

    private mutating func fetchData() async throws -> ([WallabagEntry], SyncProgress)? {
        defer {
            page += 1
        }
        let request = kit.request(for: WallabagEntryEndpoint.get(page: page, perPage: perPage), withAuth: true)
        let (data, _) = try await URLSession.shared.data(for: request)
        let result = try kit.decoder.decode(WallabagCollection<WallabagEntry>.self, from: data)
        return (result.items, (Float(result.page) / Float(result.pages)) * 100)
    }

    public func makeAsyncIterator() -> EntriesFetcher {
        self
    }
}

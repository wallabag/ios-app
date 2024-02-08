import Foundation

public struct WallabagToken: Decodable, Sendable {
    public let accessToken: String
    public let expiresIn: Int
    public let tokenType: String
    public let refreshToken: String
}

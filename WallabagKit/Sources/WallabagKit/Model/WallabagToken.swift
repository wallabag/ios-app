import Foundation

public struct WallabagToken: Decodable {
    public let accessToken: String
    public let expiresIn: Int
    public let tokenType: String
    public let refreshToken: String
}

import Foundation
import HTTPTypes
import OpenAPIRuntime
import OpenAPIURLSession

protocol ChatAssistantProtocol {
    func generateSynthesis(content: String) async throws -> String
    func generateTags(content: String) async throws -> [String]
}

struct ChatAssistant: ChatAssistantProtocol {
    var client: Client {
        get throws {
            try Client(
                serverURL: Servers.server1(),
                transport: URLSessionTransport(),
                middlewares: [AuthenticationMiddleware()]
            )
        }
    }

    var locale = Locale.current.identifier

    func generateSynthesis(content: String) async throws -> String {
        let response = try await client.wallabagSynthesis(body: .json(.init(body: content, language: locale)))

        return try response.ok.body.json.content ?? ""
    }

    func generateTags(content: String) async throws -> [String] {
        let response = try await client.wallabagTags(body: .json(.init(body: content, language: locale)))

        return try response.ok.body.json.tags ?? []
    }
}

private struct AuthenticationMiddleware: ClientMiddleware {
    @BundleKey("GPTBACK_KEY")
    private var gptBackKey

    func intercept(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID _: String,
        next: @Sendable (HTTPTypes.HTTPRequest, OpenAPIRuntime.HTTPBody?, URL) async throws -> (
            HTTPTypes.HTTPResponse,
            OpenAPIRuntime.HTTPBody?
        )
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = "Bearer \(gptBackKey)"

        return try await next(request, body, baseURL)
    }
}

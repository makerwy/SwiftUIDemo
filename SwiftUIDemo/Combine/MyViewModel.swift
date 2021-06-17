//
//  MyViewModel.swift
//  SwiftUIDemo
//
//  Created by wy on 2021/6/17.
//

import Foundation
import Combine

class MyViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var repositories = [GithubRepository]()
    @Published var loading = false
    
    var cancellable: AnyCancellable?
    var cancellable1: AnyCancellable?
    
    let myBackgroundQueue = DispatchQueue(label: "myBackgroundQueue")
    
    init() {
        cancellable = $inputText.throttle(for: 1.0, scheduler: myBackgroundQueue, latest: true)
//            .removeDuplicates()
            .print("Github input")
            .map({ input -> AnyPublisher<[GithubRepository], Never> in
                let originalString = "https://api.github.com/search/repositories?q=\(input)"
                let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let url = URL(string: escapedString)!
                return GithubApi.fetch(url: url)
                    .decode(type: GithubRepositoryResponse.self, decoder: JSONDecoder())
                    .map {
                        print($0.items)
                        return $0.items
                    }
                    .replaceError(with: [])
                    .eraseToAnyPublisher()
            })
            .switchToLatest()
            .receive(on: RunLoop.main)
            .assign(to: \.repositories, on: self)
        
        cancellable1 = GithubApi.networkPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.loading, on: self)
    }
    
}

struct GithubRepository: Codable, Identifiable {
    let id: Int
    let full_name: String
    let description: String?
    let stargazers_count: Int
    let language: String
}

struct GithubRepositoryResponse: Codable {
    let items: [GithubRepository]
}

struct GithubApi {
    static let networkPublisher = PassthroughSubject<Bool, Never>()
    
    static func fetch(url: URL) -> AnyPublisher<Data, GithubAPIError> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .handleEvents(receiveCompletion: { _ in
                networkPublisher.send(false)
            }, receiveCancel: {
                networkPublisher.send(false)
            }, receiveRequest: { _ in
                networkPublisher.send(true)
            })
            .tryMap { (data, response) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw GithubAPIError.unknown
                }
                switch httpResponse.statusCode {
                case 401:
                    throw GithubAPIError.apiError(reason: "Unauthorized")
                case 403:
                    throw GithubAPIError.apiError(reason: "Resource forbidden")
                case 404:
                    throw GithubAPIError.apiError(reason: "Resource not found")
                case 405..<500:
                    throw GithubAPIError.apiError(reason: "client error")
                case 500..<600:
                    throw GithubAPIError.apiError(reason: "server error")
                default: break
                }
                return data
            }
            .mapError { error in
                if let err = error as? GithubAPIError {
                    return err
                }
                if let err = error as? URLError {
                    return GithubAPIError.networkError(from: err)
                }
                return GithubAPIError.unknown
            }
            .eraseToAnyPublisher()

    }
}

enum GithubAPIError: Error, LocalizedError {
    case unknown
    case apiError(reason: String)
    case networkError(from: URLError)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "Unknown error"
        case .apiError(let reason):
            return reason
        case .networkError(let from):
            return from.localizedDescription
        }
    }
}

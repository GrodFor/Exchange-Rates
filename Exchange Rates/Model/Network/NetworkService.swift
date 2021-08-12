//
//  NetworkService.swift
//  Exchange Rates
//
//  Created by Vladislav Sitsko on 12.08.21.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError : String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

typealias Parameters = [String: Any]
typealias HTTPHeaders = [String: String]
typealias NetworkServiceCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?)->()

//MARK: - NetworkService
class NetworkService: NSObject {
    
    static let shared = NetworkService()
    private var task: URLSessionDataTask?
    
    func fetchExchangeRates(completion: @escaping NetworkServiceCompletion) {
        request("https://alpha.as50464.net:29870/moby-pre-44/core",
                bodyParameters: [
                    "uid":"563B4852-6D4B-49D6-A86E-B273DD520FD2",
                    "type":"ExchangeRates",
                    "rid":"BEYkZbmV"],
                urlParameters: [
                    "r":"BEYkZbmV",
                    "d":"563B4852-6D4B-49D6-A86E-B273DD520FD2",
                    "t":"ExchangeRates",
                    "v":"44"],
                additionalHeaders: [
                    "User-Agent": "Test GeekBrains iOS 3.0.0.182 (iPhone 11; iOS 14.4.1; Scale/2.00; Private)"], completion: completion)
    }
    
    private func request(_ route: String, bodyParameters: Parameters, urlParameters: Parameters, additionalHeaders: HTTPHeaders?, completion: @escaping NetworkServiceCompletion) {
        task?.cancel()
        do {
            let request = try self.buildRequest(from: route, bodyParameters: bodyParameters, urlParameters: urlParameters, additionalHeaders: additionalHeaders)
            task = URLSession.shared.dataTask(with: request, completionHandler: completion)
        } catch {
            completion(nil, nil, error)
        }
        task?.resume()
    }
    
    private func buildRequest(from route: String, bodyParameters: Parameters, urlParameters: Parameters, additionalHeaders: HTTPHeaders?) throws -> URLRequest {
        
        guard let url = URL(string: route) else {
            throw NetworkError.missingURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.post.rawValue
        do {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            try self.configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &request)
            self.addAdditionalHeaders(additionalHeaders, request: &request)
            return request
        } catch {
            throw error
        }
    }
}

private extension NetworkService {
    func configureParameters(bodyParameters: Parameters, urlParameters: Parameters, request: inout URLRequest) throws {
        do {
            try encodeUrlParameters(urlRequest: &request, with: urlParameters)
            try encodeBodyParameters(urlRequest: &request, with: bodyParameters)
        } catch {
            throw error
        }
    }
    
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func encodeUrlParameters(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        
        guard let url = urlRequest.url else {
            throw NetworkError.missingURL
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
    }
    
    func encodeBodyParameters(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}

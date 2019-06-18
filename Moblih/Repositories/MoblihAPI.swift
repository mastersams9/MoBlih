//
//  MoblihAPI.swift
//  Moblih
//
//  Created by Sami Benmakhlouf on 09/06/2019.
//  Copyright © 2019 Sami Benmakhlouf. All rights reserved.
//

import Foundation

enum MoblihAPIMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum MoblihAPIError: Error {
    case network
    case server
    case noData
    case unknown
}

protocol MoblihAPIProtocol {
    func request(urlString: String,
                 method: MoblihAPIMethod,
                 accessToken: String?,
                 parameters: [String: Any],
                 success: ((Data) -> Void)?,
                 failure: ((MoblihAPIError) -> Void)?)
}

struct MoblihAPI {}

// MARK: - MoblihAPIProtocol

extension MoblihAPI: MoblihAPIProtocol {
    
    func request(urlString: String,
                 method: MoblihAPIMethod,
                 accessToken: String?,
                 parameters: [String: Any],
                 success: ((Data) -> Void)?,
                 failure: ((MoblihAPIError) -> Void)?) {
        guard let url = URL(string: urlString) else {
            failure?(.unknown)
            return
        }
        URLSession.launchRequestURL(url, method: method, accessToken: accessToken, parameters: parameters) { dataOpt, response, error in

            switch (response as? HTTPURLResponse)?.statusCode ?? -1 {
            case 200...210:
                guard let data = dataOpt else {
                    DispatchQueue.main.async {
                        failure?(.noData)
                    }
                    return
                }
                DispatchQueue.main.async {
                    success?(data)
                }
            case 400...403:
                DispatchQueue.main.async {
                    failure?(.server)
                }
            case 404:
                DispatchQueue.main.async {
                    failure?(.noData)
                }
            case 500:
                DispatchQueue.main.async {
                    failure?(.server)
                }
            default:
                switch (error as NSError?)?.code {
                case -1009:
                    DispatchQueue.main.async {
                        failure?(.network)
                    }
                case 500:
                    DispatchQueue.main.async {
                        failure?(.server)
                    }
                default:
                    DispatchQueue.main.async {
                        failure?(.unknown)
                    }
                }
            }
        }

    }
}

private extension URLSession {
    static func launchRequestURL(_ url: URL,
                                 method: MoblihAPIMethod,
                                 accessToken: String?,
                                 parameters: [String: Any],
                                 completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 108000.0
        sessionConfig.timeoutIntervalForResource = 108000.0
        sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
        sessionConfig.urlCache = nil
        let session = URLSession(configuration: sessionConfig)

        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let accessToken = accessToken {
            request.setValue("token \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        request.httpMethod = method.rawValue

        if !parameters.isEmpty {
            let parametersData = try? JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = parametersData
        }

        let task: URLSessionDataTask = session.dataTask(with: request,
                                    completionHandler: completionHandler)

        task.resume()
    }
}


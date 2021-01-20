//
//  AsiaServiceManager.swift
//  BiWF
//
//  Created by pooja.q.gupta on 26/06/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import Foundation

class AssiaServiceManager {
    
    static let shared: AssiaServiceManager = {
        let instance = AssiaServiceManager()
        return instance
    }()
    
    var accessToken = "" //Store access token here.
    
    // Temporary function to be used to recieved auth token for Assia until Salesforce auth token can be used
    func getAccessToken(completion: @escaping (String) -> Void) {
        if accessToken.isEmpty {
            let urlString = EnvironmentPath.asiaAccessToken.rawValue
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = HTTPMethod.post.rawValue
                let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
                    guard let wSelf = self,
                        let data = data else {
                        completion("")
                        return }
                    do {
                        let authResponse = try JSONDecoder().decode(AssiaAuthResponse.self, from: data)
                        wSelf.accessToken = authResponse.accessToken
                        completion(authResponse.accessToken)
                    } catch {}
                }
                
                dataTask.resume()
            }
        } else {
            completion(accessToken)
            print("using saved token")
        }
    }
    
    func handleResponse(with data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let error = error {
            return .failure(error)
        }
        guard let response = response as? HTTPURLResponse else {
            return (.failure(HTTPError.noResponse))
        }
        if let httpError = ServiceManager.shared.getHTTPError(forStatusCode: response.statusCode) {
            return (.failure(httpError))
        }
        guard let data = data else {
            return (.failure(HTTPError.noData))
        }
        return (.success(data))
    }
}

// Temporary struct to be used with NetworkAssiaServiceManager's getAccessToken function
struct AssiaAuthResponse: Codable {
    let accessToken: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
    }
}



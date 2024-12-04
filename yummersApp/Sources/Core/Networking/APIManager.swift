//
//  NetworkClient.swift
//  terapilah
//
//  Created by mac.bernanda on 16/08/24.
//

// TODO : singleton of http client

import Alamofire
import Foundation

class APIManager {
    private let sessionManager: Session
    static let networkEnviroment: NetworkEnvironment = .dev
    
    private static var sharedApiManager: APIManager = {
        let apiManager = APIManager(sessionManager: Session())
        return apiManager
    }()
    
    class func shared() -> APIManager {
        return sharedApiManager
    }
    
    private init(sessionManager: Session) {
        self.sessionManager = sessionManager
    }
    
    func call<T>(
        type: EndPointType,
        params: Parameters? = nil,
        completion: @escaping (Result<T, Error>) -> () ) where T: Codable {
            self.sessionManager.request(type.url,
                                        method: type.httpMethod,
                                        parameters: params,
                                        encoding: type.encoding,
                                        headers: type.headers)
            .validate()
            .responseData { response in
                print(response.request)
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let decodedData = try decoder.decode(T.self, from: data)
                        completion(.success(decodedData))
                    } catch let decodingError {
                        completion(.failure(decodingError))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    
}

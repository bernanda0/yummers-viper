//
//  generate_scenario.swift
//  terapilah
//
//  Created by mac.bernanda on 19/08/24.
//
import Alamofire
import Foundation

enum MealEndpoint {
//    case text
    case search
}

extension MealEndpoint: EndPointType {
    var baseURL: String {
        switch APIManager.networkEnviroment {
            case .dev: return "https://www.themealdb.com/api/json/"
            case .production: return ""
            case .stage: return ""
        }
    }
    
    var version: String {
        return "v1/"
    }
    
    var key : String {
        return "1/"
    }
    
    var path: String {
        switch self {
            
        case .search:
            return "search.php"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .search:
            return .get
        
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .search:
            return ["Content-Type": "application/json",
                    "X-Requested-With": "XMLHttpRequest"]
        }
    }
    
    var url: URL {
        switch self {
        default:
            return URL(string: self.baseURL + self.version + self.key + self.path)!
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .search:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        
        }
    }
    
}

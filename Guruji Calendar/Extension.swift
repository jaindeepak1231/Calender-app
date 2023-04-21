//
//  Extension.swift
//  JyotiCabs
//
//  Created by Vivek Goswami on 25/01/17.
//  Copyright © 2017 TriSoft Developers. All rights reserved.
//

import Foundation
import Alamofire

extension String: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}

//
//  ApiResponseModel.swift
//  ThrumpIt
//
//  Created by Satish Kumar R Kancherla on 12/2/17.
//  Copyright © 2017 Thrumpit. All rights reserved.
//

import Foundation
import ObjectMapper

class ApiResponse: Mappable{
    required init?(map: Map) {}

    var data: Any?
    var returnCodeDesc: String?
    var returnCode = 0
    var error: ApiError?
    
    func mapping(map: Map) {
        data    <- map["data"]
        returnCodeDesc       <- map["returnCodeDesc"]
        returnCode      <- map["returnCode"]
        error      <- map["error"]
    }
}

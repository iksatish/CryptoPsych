//
//  AuthenticatorService.swift
//  ThrumpIt
//
//  Created by Satish Kancherla on 12/19/17.
//  Copyright © 2017 Thrumpit. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class AuthenticatorService: NSObject{
    static let instance = AuthenticatorService()
    
    func register(params: [String : AnyObject], success:@escaping (JSON) -> Void, failure:@escaping (ApiError) -> Void){
        let url = String(format:"\(BASE_URL)\(URI_REGISTER)")
        ApiClient.requestPOSTURL(url, params: params, headers: nil, success: { (json) in
            success(json)
        },failure: { (error) in
            failure(error)
        })
    }
    
    func signIn(params: [String : AnyObject], success:@escaping (JSON) -> Void, failure:@escaping (ApiError) -> Void){
        let url = String(format:"\(BASE_URL)\(URI_LOGIN)")
        ApiClient.requestPOSTURL(url, params: params, headers: nil, success: { (json) in
            guard let info = Mapper<ApiResponse>().map(JSONObject: json.rawValue), info.returnCode == 1, info.returnCodeDesc == SUCCESSKEY else{
                failure(ApiError())
                return
            }
            success(json)
        },failure: { (error) in
            failure(error)
        })
    }
    
    

}

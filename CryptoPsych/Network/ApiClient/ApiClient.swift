//
//  ApiClient.swift
//  CryptoPsych
//
//  Created by Satish Kumar R Kancherla on 10/26/17.
//  Copyright © 2017 Thrumpit. All rights reserved.
//

import Foundation
import ObjectMapper
import Alamofire
import SwiftyJSON

class ApiClient: NSObject{
    class func requestGETURL(isAuthenticationNeeded:Bool = false, _ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (ApiError) -> Void) {
        Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
            ApiClient.handlingResponse(responseObject: responseObject, success: { (json) in
                success(json)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (ApiError) -> Void){
        
        Alamofire.request(strURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: ["Content-Type":"application/json"]).responseJSON { (responseObject) -> Void in
            ApiClient.handlingResponse(responseObject: responseObject, success: { (json) in
                success(json)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    class func requestDELURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (ApiError) -> Void) {
        Alamofire.request(strURL, method: .delete).responseJSON { (responseObject) -> Void in
            ApiClient.handlingResponse(responseObject: responseObject, success: { (json) in
                success(json)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    class func requestPUTURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (ApiError) -> Void) {
        Alamofire.request(strURL, method: .put).responseJSON { (responseObject) -> Void in
            ApiClient.handlingResponse(responseObject: responseObject, success: { (json) in
                success(json)
            }, failure: { (error) in
                failure(error)
            })
        }
    }
    
    class func handlingResponse(responseObject: DataResponse<Any>, success:@escaping (JSON) -> Void, failure:@escaping (ApiError) -> Void){
        if responseObject.result.isSuccess{
            let resJson = JSON(responseObject.result.value!)
            if let info = Mapper<ApiResponse>().map(JSONObject: resJson.rawValue){
                if info.returnCode == 1, info.returnCodeDesc == SUCCESSKEY{
                    success(resJson)
                }else{
                    failure(info.error ?? ApiError())
                }
            }
        }else{
            failure(ApiError())
        }
    }
    

}



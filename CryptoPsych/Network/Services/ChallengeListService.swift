//
//  ChallengeListService.swift
//  ThrumpIt
//
//  Created by Satish Kancherla on 12/18/17.
//  Copyright © 2017 Thrumpit. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper
let SUCCESSKEY = "Success"

class ChallengeListService: NSObject{
    static let instance = ChallengeListService()
    
    func getChallengeList(success:@escaping (ChallengeListModel) -> Void, failure:@escaping (ApiError) -> Void){
        let url = "\(BASE_URL)\(URI_CHL_LIST)"
        ApiClient.requestGETURL(url, success: { (json) in
            guard let info = Mapper<ApiResponse>().map(JSONObject: json.rawValue), let list = Mapper<ChallengeListModel>().map(JSONObject: info.data) else{
                failure(ApiError())
                return
            }
            success(list)
        }) { (error) in
            failure(error)
        }
    }
}

//
//  ChallengeModel.swift
//  ThrumpIt
//
//  Created by Satish Kancherla on 12/18/17.
//  Copyright © 2017 Thrumpit. All rights reserved.
//

import Foundation
import ObjectMapper

class ChallengeListModel: Mappable{

    required init?(map: Map) {}
    var challenges: [ChallengeModel]?
    var totalRecords = 0
    var pageNo = 0
    var totalPages = 0

    func mapping(map: Map) {
        challenges    <- map["challenges"]
        totalRecords       <- map["totalRecords"]
        pageNo      <- map["pageNo"]
        totalPages      <- map["totalPages"]
    }
}


class ChallengeModel: Mappable{
    required init?(map: Map) {}
    
    var zingSessionId = 0
    var description: String?
    var title: String?
    var startDate: Double?
    var isActive: String?
    var zingsAllocated = 0
    var viewersCount = 0
    var opponent: ChlUserModel?
    var challenger: ChlUserModel?
    
    func mapping(map: Map) {
        zingSessionId    <- map["zingSessionId"]
        description       <- map["description"]
        title      <- map["title"]
        startDate      <- map["startDate"]
        isActive      <- map["isActive"]
        zingsAllocated      <- map["zingsAllocated"]
        viewersCount      <- map["viewersCount"]
        opponent      <- map["opponent"]
        challenger      <- map["challenger"]

    }
}

class ChlUserModel: Mappable{
    required init?(map: Map) {}
    var score = 0
    var isLastZingUser = false
    var isCurrentUser = false
    var user: UserModel?
    func mapping(map: Map) {
        score    <- map["score"]
        isLastZingUser       <- map["isLastZingUser"]
        isCurrentUser      <- map["isCurrentUser"]
        user      <- map["user"]
    }
}

class UserModel: Mappable{
    required init?(map: Map) {}
    var userId = 0
    var name: String?
    var isCurrentUserFollowing = false
    var isCurrentUser = false
    var isCurrentUserFollowingChallenger = false
    var isCurrentUserFollowingOpponent = false
    var uid: String?
    var description: String?
    var type: String?
    var emailAddress: String?
    var isActive: String?
    
    func mapping(map: Map) {
        userId    <- map["userId"]
        name       <- map["name"]
        isCurrentUserFollowing      <- map["isCurrentUserFollowing"]
        isCurrentUser      <- map["isCurrentUser"]
        isCurrentUserFollowingChallenger      <- map["isCurrentUserFollowingChallenger"]
        isCurrentUserFollowingOpponent      <- map["isCurrentUserFollowingOpponent"]
    }
}

class ApiError: Mappable{
    required init?(map: Map) {}
    var code = -1
    var msg: String?
    
    func mapping(map: Map) {
        code    <- map["code"]
        msg       <- map["msg"]
    }
    init(){
        msg = "Service error, please try again!"
    }
}

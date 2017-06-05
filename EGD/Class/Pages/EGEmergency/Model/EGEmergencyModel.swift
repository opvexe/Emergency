//
//  EGEmergencyModel.swift
//  EGD
//
//  Created by jieku on 2017/5/29.
//
//

import UIKit

class EGEmergencyModel: EGBaseModel {
    
    var click_count :Int?
//    var description :String?
    var favorite :Int?
    var favorite_count :Int?
    var group_id :String?
    var image_url :String?
    var locationId :String?
    var locationName :String?
    var makingTime :String?
    var recipe_id :Int?
    var recipe_type :Int?
    var recommend_type :Int?
    var share_count :Int?
    var rid : Int?
    var source :EGHomeModel?

}

class EGHomeModel: EGBaseModel{
    
    var authorImageUrl :String?
    var authorName :String?
    var authorSummary :String?
    var displayAuthor :Int?
    var authorId :Int?
    var str_date :String?
    var title :String?
}

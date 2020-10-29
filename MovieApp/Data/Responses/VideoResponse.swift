//
//  VideoResponse.swift
//  MovieApp
//
//  Created by Aditya Haryanov on 28/10/20.
//

import Foundation

struct VideoResponse : Codable {
    
    var id : String
    var key : String
    var name : String
    var site : String
    var size : Int
    var type : String
    
    func toEntity() -> Video {
        return Video(id: id, key: key, name: name, site: site, size: size, type: type)
    }
    
}

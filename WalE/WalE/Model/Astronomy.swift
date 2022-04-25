//
//  Astronomy.swift
//
//  Created by Pooja Soni on 25/04/22.
//

import Foundation


struct Astronomy: Codable, Equatable{
    /// The title of the astronomy
    let title: String

    /// The description of the astronomy of the date
    let description: String

    /// The image URL the post lives at.
    let imageURL: URL?
    
    /// The hd image URL the post lives at.
    let imageHDURL: URL
    
    /// The type of the media, by default keeping it as image only
    let mediaType: String
    
    ///date of the astronomy
    let date: String
    
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "explanation"
        case imageURL = "url"
        case imageHDURL = "hdurl"
        case date = "date"
        case mediaType = "media_type"
    }
}

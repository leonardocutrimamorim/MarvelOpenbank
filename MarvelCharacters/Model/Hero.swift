//
//  Hero.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 13/12/20.
//

import Foundation

struct Hero: Decodable {
    let id: Int
    let name: String?
    let description: String?
    let imageURL: String?
}

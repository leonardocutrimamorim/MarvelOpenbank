//
//  MarvelKeys.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 13/12/20.
//

import Foundation

struct MarvelKeys {
    //URL Paths
    static let baseUrl = "https://gateway.marvel.com/v1/public"
    static let characters = "/characters"
    
    //Amount of info on a request
    static let limit = "limit"
    static let offset = "offset"
    
    //Request identification
    static let timestamp = "ts"
    static let hash = "hash"
    static let publicKey = "apikey"
    static let marvelPublicKey = "672d19693d83d6a10865984376e74c39"
    static let marvelPrivateKey = "12a203b4cc3ef54e6da6760981bc90050a9c1eda"
}

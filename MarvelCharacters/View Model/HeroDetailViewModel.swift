//
//  HeroDetailViewModel.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 15/12/20.
//

import UIKit

final class HeroDetailViewModel {
    let name: String
    let description: String
    let placeholderImage: UIImage = #imageLiteral(resourceName: "marvel")

    
    private let hero: Hero
    private let marvelService: MarvelAPIServiceProtocol
    
    init(marvelService: MarvelAPIServiceProtocol, hero: Hero) {
        
        self.hero = hero
        self.marvelService = marvelService
        
        
        if let name = hero.name, !name.isEmpty {
            self.name = name
        } else {
            self.name = "Name unavailable"
        }
        
        if let description = hero.description, !description.isEmpty {
            self.description = description
        } else {
            self.description = "Description unavailable"
        }
        
        
    }
    
    
    func fetchHeroDetailImage(_ completion: @escaping(UIImage) -> Void) {
        guard let imageURL = hero.imageURL else {
            completion(#imageLiteral(resourceName: "marvel"))
            return
        }
        
        marvelService.fetchImage(imgURL: imageURL, with: .heroList) { result in
            switch result {
            case .failure: completion(#imageLiteral(resourceName: "marvel"))
            case .success(let image): completion(image)
            }
        }
    }

    
}

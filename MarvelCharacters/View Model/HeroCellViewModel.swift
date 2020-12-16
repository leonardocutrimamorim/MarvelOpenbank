//
//  HeroCellViewModel.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 15/12/20.
//

import UIKit

final class HeroCellViewModel {
    let name: String
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
    }
    
    func fetchImage(completion: @escaping(UIImage) -> Void) {
        guard let imageURL = hero.imageURL else {
            completion(#imageLiteral(resourceName: "marvellogo"))
            return
        }
        
        marvelService.fetchImage(imgURL: imageURL, with: .heroList) { result in
            switch result {
            case .failure: completion(#imageLiteral(resourceName: "marvellogo"))
            case .success(let image): completion(image)
            }
        }
    }
    
    func getHeroDetailViewModel() -> HeroDetailViewModel {
        return HeroDetailViewModel(marvelService: marvelService, hero: hero)
    }
}


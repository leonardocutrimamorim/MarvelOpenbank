//
//  HeroListViewModel.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 15/12/20.
//

import UIKit

final class HeroListViewModel {
    private var isFetching: Bool = false
    private let marvelService: MarvelAPIServiceProtocol
    
    private let defaultAmountOfHeroes: Int = 20
    
    var hasReachedMaxAmountOfHeroes: Bool = false
    
    var heroesCellViewModel: [HeroCellViewModel] = []
    
    init(marvelService: MarvelAPIServiceProtocol) {
        self.marvelService = marvelService
    }
    
    func getHeroDetailViewModel(forRow row: Int) -> HeroDetailViewModel {
        let heroVM = heroesCellViewModel[row]
        return heroVM.getHeroDetailViewModel()
    }
    
    func fetchHeroes(_ completion: @escaping(Result<[IndexPath]>) -> Void) {
        guard !isFetching else { return }
        isFetching = true
        
        guard !hasReachedMaxAmountOfHeroes else {
            completion(.success([]))
            return
        }
        
        let offset = heroesCellViewModel.count
        let amount = defaultAmountOfHeroes
        marvelService.requestCharacters(offset: offset,
                                        amount: amount) { [unowned self] result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
                
            case .success(let response):
                self.hasReachedMaxAmountOfHeroes = response.totalAmount <= offset + amount
                let newHeroes = response.0
                let newHeroesVM = newHeroes.map { HeroCellViewModel(marvelService: self.marvelService, hero: $0) }
                self.heroesCellViewModel.append(contentsOf: newHeroesVM)
                let indexPaths = self.getIndexPathsToInsert(newHeroes: newHeroesVM)
                completion(.success(indexPaths))
            }
            self.isFetching = false
        }
    }
    
    /// Calculate index paths that collection view needs to reload based on new heroes
    private func getIndexPathsToInsert(newHeroes: [HeroCellViewModel]) -> [IndexPath] {
        let startIndex = heroesCellViewModel.count - newHeroes.count
        let endIndex = startIndex + newHeroes.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}

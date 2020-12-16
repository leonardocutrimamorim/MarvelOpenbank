//
//  CharacterViewController.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 15/12/20.
//

import UIKit

class CharacterViewController: UIViewController {

    @IBOutlet weak var characterImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var heroDetailViewmodel: HeroDetailViewModel!
    
    
    func setup(with viewModel: HeroDetailViewModel) {
        self.heroDetailViewmodel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = heroDetailViewmodel.name
        descriptionLabel.text = heroDetailViewmodel.description
        fetchHeroImage()
    }
    
    func setupViewModel() {
        fetchHeroImage()
    }
    
    
    func fetchHeroImage() {
        characterImageView.image = heroDetailViewmodel.placeholderImage
        heroDetailViewmodel.fetchHeroDetailImage { [weak self] image in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.characterImageView.image = image
            }
        }
    }


}

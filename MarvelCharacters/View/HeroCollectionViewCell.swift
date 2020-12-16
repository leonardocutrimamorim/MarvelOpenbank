//
//  HeroCollectionViewCell.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 15/12/20.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var shadowView: UIView!
    
    private var heroViewModel: HeroCellViewModel!
    
    func setViewModel(_ heroVM: HeroCellViewModel) {
        heroViewModel = heroVM
        self.heroNameLabel.text = heroVM.name
        heroImage.image = heroVM.placeholderImage
        fetchHeroImage()
    }
    
    func fetchHeroImage() {
        heroViewModel.fetchImage { [unowned self] image in
            DispatchQueue.main.async {
                self.heroImage.image = image
            }
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        shadowView.layer.addShadow(with: #colorLiteral(red: 0.1803921569, green: 0.1803921569, blue: 0.1803921569, alpha: 1), alpha: 0.23, xOffset: 0, yOffset: 0, blur: 15, spread: 0)
//    }
}

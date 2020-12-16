//
//  HeroListViewController.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 15/12/20.
//

import UIKit

private let cellId = "heroCell"
private let footerViewId = "footerView"
private let heroDetailSegue = "characterSegue"

class HeroListViewController: UIViewController {
    private var vm: HeroListViewModel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let spinner = UIActivityIndicatorView(style: .gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let marvelService = MarvelAPIService()
        let viewModel = HeroListViewModel(marvelService: marvelService)
        
        setupViewModel(viewModel)
        setupCollectionView()
        setupSpinner()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func setupSpinner() {
        spinner.color = UIColor.white
        spinner.hidesWhenStopped = true
    }
    
    func setupViewModel(_ viewModel: HeroListViewModel) {
        vm = viewModel
        fetchHeroes()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == heroDetailSegue,
            let vc = segue.destination as? CharacterViewController,
            let heroDetailVM = sender as? HeroDetailViewModel {
            vc.heroDetailViewmodel = heroDetailVM
        }
    }
    
    func fetchHeroes() {
        vm.fetchHeroes { [unowned self] result in
            self.spinner.stopAnimating()
            
            switch result {
            case .failure(let error):
                self.present(error: error)
                
            case .success(let indexPaths):
                self.collectionView.insertItems(at: indexPaths)
            }
        }
    }
    

}

extension HeroListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.heroesCellViewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as?
            HeroCollectionViewCell else { return UICollectionViewCell() }
        let heroVM = vm.heroesCellViewModel[indexPath.row]
        cell.setViewModel(heroVM)
        return cell
    }
    
    // Adds activity indicator at bottom of collection view to present a loading animation while fetching extra heroes.
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: footerViewId,
                                                                             for: indexPath)
            spinner.translatesAutoresizingMaskIntoConstraints = false
            footerView.addSubview(spinner)
            spinner.centerXAnchor.constraint(equalTo: footerView.centerXAnchor).isActive = true
            spinner.centerYAnchor.constraint(equalTo: footerView.centerYAnchor).isActive = true
            return footerView
        default:
           assert(false, "Unexpected element kind")
        }
    }
}

extension HeroListViewController: UICollectionViewDelegateFlowLayout {
    // Calculating collection view cell size to make sure two collumns are presented
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  50
        let collectionViewSize = collectionView.frame.size.width - padding
        
        return CGSize(width: collectionViewSize/2, height: collectionViewSize)
    }
}

extension HeroListViewController: UICollectionViewDelegate {
    // If last cell is about to be displayed, try to fetch extra heroes to present to user
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard !vm.hasReachedMaxAmountOfHeroes else { return }
        
        let numRows = collectionView.numberOfItems(inSection: 0)
        if (indexPath.row == numRows - 1) {
            spinner.startAnimating()
            fetchHeroes()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let heroDetailVM = vm.getHeroDetailViewModel(forRow: indexPath.row)
        performSegue(withIdentifier: heroDetailSegue, sender: heroDetailVM)

    }
}

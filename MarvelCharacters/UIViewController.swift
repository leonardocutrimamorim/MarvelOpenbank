//
//  UIViewController.swift
//  MarvelCharacters
//
//  Created by Leonardo Amorim on 15/12/20.
//

import UIKit

extension UIViewController {
    func present(message: String) {
        let alert = UIAlertController(title: "Marvel Heroes", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func present(error: Error) {
        present(message: error.localizedDescription)
    }
}

//
//  CollectionViewController.swift
//  Tori
//
//  Created by Helder on 03/24/2021.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    var names = [String]()
    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadBirdNames()
        loadBirdImages()
        
        collectionView.reloadData()
    }

    func loadBirdNames() {
        if let path = Bundle.main.path(forResource: "names", ofType: "txt") {
            do {
                let content = try String(contentsOfFile: path)
                names = content.components(separatedBy: "\n")
            } catch {
                print("Error loading bird names")
            }
        }
    }
    
    func loadBirdImages() {
        if let path = Bundle.main.path(forResource: "images", ofType: "txt") {
            do {
                let content = try String(contentsOfFile: path)
                images = content.components(separatedBy: "\n")
            } catch {
                print("Error loading bird images")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (names.count + images.count ) / 2
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath)
        if let cardCell = cell as? CardCollectionViewCell {
            cardCell.isTurnedUp = false
            if indexPath.row % 2 == 0 {
                cardCell.frontName = names[indexPath.row]
            } else {
                if let image =  UIImage(named: images[indexPath.row - 1]) {
                    cardCell.frontImage = image
                    cardCell.frontImageView.image = image
                }
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}

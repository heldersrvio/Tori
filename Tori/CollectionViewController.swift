//
//  CollectionViewController.swift
//  Tori
//
//  Created by Helder on 03/24/2021.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    var order = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    var names = [String]()
    var images = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadBirdNames()
        loadBirdImages()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 160, height: 240)
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 15
        collectionView.collectionViewLayout = layout
        
        collectionView.reloadData()
    }

    func loadBirdNames() {
        if let path = Bundle.main.path(forResource: "names", ofType: "txt") {
            do {
                let components = try String(contentsOfFile: path).components(separatedBy: "\n").filter({ string -> Bool in
                    return string != ""
                })
                order = Array(components.shuffled().map({ name -> Int in
                    return components.firstIndex(of: name) ?? 0
                })[0...8])
                names = order.map({ index -> String in
                    components[index]
                }).shuffled()
            } catch {
                print("Error loading bird names")
            }
        }
    }
    
    func loadBirdImages() {
        if let path = Bundle.main.path(forResource: "images", ofType: "txt") {
            do {
                let components = try String(contentsOfFile: path).components(separatedBy: "\n").filter({ string -> Bool in
                    return string != ""
                })
                images = order.map({ index -> String in
                    components[index]
                }).shuffled()
            } catch {
                print("Error loading bird images")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count + images.count
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Card", for: indexPath)
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 3
        cell.layer.cornerRadius = 5
        if let cardCell = cell as? CardCollectionViewCell {
            cardCell.isTurnedUp = false
            cardCell.imageView.layer.cornerRadius = 5
            cardCell.imageView.contentMode = .scaleAspectFill
            cardCell.imageView.clipsToBounds = true
            if indexPath.row % 2 == 0 {
                cardCell.frontName = names[indexPath.row / 2]
                cardCell.imageView.image = UIImage(named: "cardbackground")
            } else {
                if let image =  UIImage(named: images[indexPath.row / 2]) {
                    cardCell.frontImage = image
                    cardCell.imageView.image = image
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

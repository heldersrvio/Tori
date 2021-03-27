//
//  CollectionViewController.swift
//  Tori
//
//  Created by Helder on 03/24/2021.
//
import Foundation
import UIKit

class CollectionViewController: UICollectionViewController {
    var order = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    var turnedUpCards: [Int] = []
    var hiddenCards: [Int] = []
    var names = [String]()
    var images = [String]()
    var cards = [Card]()
    @IBOutlet weak var congratulationsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = UIColor(red: 0.77, green: 1, blue: 0.62, alpha: 1)

        loadBirdNames()
        loadBirdImages()
        cards = (names + images).map({ string -> Card in
            Card(string: string, type: names.contains(string) ? "name" : "image")
        }).shuffled()
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
                })
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
                })
            } catch {
                print("Error loading bird images")
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
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
            cardCell.backgroundColor = UIColor.white
            cardCell.imageView.layer.cornerRadius = 5
            cardCell.imageView.contentMode = .scaleAspectFill
            cardCell.imageView.clipsToBounds = true
            if cards[indexPath.row].type == "name" {
                cardCell.frontImage = returnNameImage(for: cards[indexPath.row].string)
            } else {
                if let image =  UIImage(named: cards[indexPath.row].string) {
                    cardCell.frontImage = image
                }
            }
            if turnedUpCards.contains(indexPath.row) {
                cardCell.imageView.image = cardCell.frontImage
                if turnedUpCards.count == 2 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        [weak self] in
                        if self?.turnedUpCards.count == 2 {
                            if let firstTurnedUpCardIndex = self?.turnedUpCards[0], let secondTurnedUpCardIndex = self?.turnedUpCards[1], let firstTurnedUpCard = self?.cards[firstTurnedUpCardIndex], let secondTurnedUpCard = self?.cards[secondTurnedUpCardIndex] {
                                if firstTurnedUpCard.type != secondTurnedUpCard.type {
                                    if (firstTurnedUpCard.type == "name" && self?.names.firstIndex(of: firstTurnedUpCard.string) == self?.images.firstIndex(of: secondTurnedUpCard.string)) || (firstTurnedUpCard.type == "image" && self?.names.firstIndex(of: secondTurnedUpCard.string) == self?.images.firstIndex(of: firstTurnedUpCard.string)) {
                                        self?.hiddenCards.append(firstTurnedUpCardIndex)
                                        self?.hiddenCards.append(secondTurnedUpCardIndex)
                                    }
                                }
                            }
                            self?.turnedUpCards = []
                            self?.collectionView.reloadData()
                        }
                    }
                }
            } else {
                cardCell.imageView.image = UIImage(named: "cardbackground")
            }
            if hiddenCards.contains(indexPath.row) {
                cardCell.frame = CGRect(x: cardCell.frame.minX, y: cardCell.frame.minY, width: cardCell.frame.width, height: 0)
            }
            if hiddenCards.count == cards.count {
                let labelAttributedString = NSAttributedString(string: "おめでとう", attributes: [
                    NSAttributedString.Key.strokeColor: UIColor.black,
                    NSAttributedString.Key.foregroundColor: UIColor.white,
                    NSAttributedString.Key.strokeWidth: -2.0,
                    NSAttributedString.Key.font: UIFont(name: "YuGo-Bold", size: 60)!
                    ]
                )
                congratulationsLabel.attributedText = labelAttributedString
                congratulationsLabel.isHidden = false
            }
        }
    
        return cell
    }
    
    func returnNameImage(for name: String) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 140, height: 220))
        return renderer.image { ctx in
            UIColor.black.set()
            ctx.fill(CGRect(x: 0, y: 0, width: 140, height: 220))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs = [
                NSAttributedString.Key.font: UIFont(name: "YuGo-Bold", size: 36)!,
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.foregroundColor: UIColor.white
            ]
            let string = NSString(string: name)
            string.draw(with: CGRect(x: 0, y: 85, width: 140, height: 50), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !hiddenCards.contains(indexPath.row) && turnedUpCards.count < 2 {
            turnedUpCards.append(indexPath.row)
            collectionView.reloadData()
        }
    }

}

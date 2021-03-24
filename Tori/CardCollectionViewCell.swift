//
//  CardCollectionViewCell.swift
//  Tori
//
//  Created by Helder on 03/24/2021.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    var frontImage: UIImage?
    var frontName: String?
    var isTurnedUp = false
    
    @IBOutlet weak var frontImageView: UIImageView!
}

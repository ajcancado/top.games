//
//  GameCell.swift
//  TopGames
//
//  Created by Arthur Junqueira Cançado on 28/02/2018.
//  Copyright © 2018 Arthur Junqueira Cançado. All rights reserved.
//

import UIKit

class GameCell: UICollectionViewCell {

    @IBOutlet weak var gameLogo: UIImageView!
    
    @IBOutlet weak var gameName: UILabel!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.groupTableViewBackground
        
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gameLogo.image = UIImage()
        gameName.text = Constants.Messages.empty
    }
}

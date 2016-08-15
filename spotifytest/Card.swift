//
//  Card.swift
//  BrainTeaser
//
//  Created by Adriana Gonzalez on 4/21/16.
//  Copyright © 2016 Adriana Gonzalez. All rights reserved.
//

import UIKit

class Card: UIView {

  
    let shapes = ["shape1", "shape2", "shape3"]
    var currentShape: String!
    
    @IBOutlet weak var shapeImage: UIImageView!
    @IBOutlet weak var checkImg: UIImageView!
    
    @IBInspectable var cornerRadius: CGFloat = 3.0 {
        didSet{
            setupView()
        }
    }
    
    override func awakeFromNib() {
        setupView()
        selectShape()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    func setupView(){
        self.layer.cornerRadius = cornerRadius
        self.layer.shadowOpacity = 0.8
        self.layer.shadowRadius = 5.0
        self.layer.shadowOffset = CGSizeMake(0.0, 2.0)
        self.layer.shadowColor = UIColor(red: 157.0/255.0, green: 157.0/255.0, blue: 157.0/255.0, alpha: 1.0).CGColor
        self.setNeedsLayout()
    }
    
    func selectShape(){
    }
    
    func showCorrect(){
        checkImg.image = UIImage(named: "check")
    }
    
    func showWrong(){
        checkImg.image = UIImage(named: "delete")

    }
}

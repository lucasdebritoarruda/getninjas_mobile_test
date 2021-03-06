//
//  Button Extensions.swift
//  getninjas_mobile_test
//
//  Created by Lucas de Brito on 30/09/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit

extension UIButton{
    
    public convenience init(title: String, titleColor: UIColor, backGroundColor: UIColor, borderColor: UIColor){
        self.init()
        let attString = NSMutableAttributedString(attributedString: NSAttributedString(string:title, attributes:[NSAttributedStringKey.font:UIFont.systemFont(ofSize:16), .foregroundColor: titleColor]))
        self.setAttributedTitle(attString, for: .normal)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
        self.backgroundColor = backGroundColor
    }
    
}

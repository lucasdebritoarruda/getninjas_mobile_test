//
//  ConstraintExtensions.swift
//  getninjas_mobile_test
//
//  Created by Lucas de Brito on 27/09/2018.
//  Copyright © 2018 Lucas de Brito. All rights reserved.
//

import UIKit

extension UIView {
    
    func addConstraintsWithVisualFormat(format:String, views:UIView...){
        var viewsDictionary = [String : UIView]()
        for (index,view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
}

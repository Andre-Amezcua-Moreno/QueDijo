//
//  FormTextField.swift
//  QueDijo
//
//  Created by Andrea Amezcua Moreno on 12/3/19.
//  Copyright © 2019 Andrea Amezcua Moreno. All rights reserved.
//

import UIKit

class FormTextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let underlineView = UIView()
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        //        underlineView.backgroundColor = .brown
        underlineView.backgroundColor = UIColor(red: 185/255.0, green: 185/255.0, blue: 185/255.0, alpha: 1)
        
        addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            
            underlineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            underlineView.heightAnchor.constraint(equalToConstant: 1)
            ])
    }

}



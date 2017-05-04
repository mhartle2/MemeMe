//
//  TableViewCell.swift
//  MemeMe
//
//  Created by Marc on 5/3/17.
//  Copyright © 2017 Marc. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        self.textLabel?.frame = CGRect(x: 130, y: 45, width: 245, height: 30)
    }
    
}

//
//  UITableView+Additions.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

extension UITableView {
    
    class func ITTableView(backgroundColor: UIColor, delegate: Any?) -> UITableView {
        
        let tableView = UITableView.init(frame: .zero, style: .grouped)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.backgroundColor = backgroundColor
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.showsHorizontalScrollIndicator = false
        
        tableView.separatorColor = UIColor.clear
        
        tableView.delegate = delegate as? UITableViewDelegate
        
        tableView.dataSource = delegate as? UITableViewDataSource
        
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        tableView.rowHeight = 60
        
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        
        tableView.sectionFooterHeight = 0.01
        
        tableView.alwaysBounceVertical = false
        
        tableView.isScrollEnabled = false
        
        return tableView
    }
}

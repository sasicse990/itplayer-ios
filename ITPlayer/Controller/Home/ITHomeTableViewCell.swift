//
//  ITHomeTableViewCell.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ITHomeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    fileprivate weak var titleLable: UILabel!
    
    fileprivate var hasSetupConstraints: Bool = false
    
    var videoList: Dictionary<String, Any?>? {
        
        didSet {
            titleLable.text = videoList!["title"] as? String
        }
    }

    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none

        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - UI and Constraints methods
    
    fileprivate func setupViews() {
        let titleLbl = UILabel.defaultLabel(backgroundcolor: UIColor.clear, textColor: UIColor.black, textFont: UIFont.systemFont(ofSize: 16, weight: .medium))
        titleLbl.text = "Testing"
        
        contentView.addSubview(titleLbl)
        
        self.titleLable = titleLbl
    }
    
    fileprivate func setupConstraints() {
        titleLable.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0).isActive = true
        titleLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0).isActive = true
        titleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    override func updateConstraints() {
        if hasSetupConstraints == false {
            setupConstraints()
            hasSetupConstraints = true
        }
        
        super.updateConstraints()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }
}



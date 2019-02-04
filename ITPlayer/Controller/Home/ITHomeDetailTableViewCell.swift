//
//  ITHomeDetailTableViewCell.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import SDWebImage

class ITHomeDetailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    fileprivate weak var videoImageView: UIImageView!
    
    fileprivate weak var titleLable: UILabel!
    
    fileprivate weak var playImageView: UIImageView!
    
    fileprivate var hasSetupConstraints: Bool = false
    
    var videoList: ITVideos? {
        
        didSet {
            if let image = videoList?.thumb {
                videoImageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: ""))
            }

            titleLable.text = videoList?.videoDescription
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
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        imageView.layer.cornerRadius = 10.0
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        let playImageView = UIImageView()
        playImageView.translatesAutoresizingMaskIntoConstraints = false
        playImageView.image = UIImage(named: "icnPlay")
        
        let titleLbl = UILabel.defaultLabel(backgroundcolor: UIColor.clear, textColor: UIColor.black, textFont: UIFont.systemFont(ofSize: 16, weight: .medium))
        titleLbl.text = "Testing"
        
        contentView.addSubview(imageView)
        imageView.addSubview(playImageView)
        contentView.addSubview(titleLbl)
        
        self.videoImageView = imageView
        self.playImageView = playImageView
        self.titleLable = titleLbl
    }
    
    fileprivate func setupConstraints() {
        videoImageView.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 20.0).isActive = true
        videoImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20.0).isActive = true
        videoImageView.widthAnchor.constraint(equalToConstant: 60.0).isActive = true
        videoImageView.heightAnchor.constraint(equalToConstant: 60.0).isActive = true
        videoImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -20.0).isActive = true
        
        playImageView.centerXAnchor.constraint(equalTo: videoImageView.centerXAnchor).isActive = true
        playImageView.centerYAnchor.constraint(equalTo: videoImageView.centerYAnchor).isActive = true
        playImageView.widthAnchor.constraint(equalToConstant: 24.0).isActive = true
        playImageView.heightAnchor.constraint(equalToConstant: 24.0).isActive = true

        titleLable.topAnchor.constraint(equalTo: contentView.topAnchor , constant: 20.0).isActive = true
        titleLable.leftAnchor.constraint(equalTo: videoImageView.rightAnchor, constant: 20.0).isActive = true
        titleLable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20.0).isActive = true
        titleLable.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20.0).isActive = true
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



//
//  ITHomeViewController.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ITHomeViewController: UIViewController {

    // MARK: - Properties

    // MARK: - Lifecycle
    
    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - User Interactions
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - UI and Constraints methods

    fileprivate func setupViews() {
        view.backgroundColor = .white

        setupConstraints()
    }

    fileprivate func setupConstraints() {
        
    }
}



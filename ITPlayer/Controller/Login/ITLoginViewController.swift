//
//  ViewController.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

class ITLoginViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNeedsStatusBarAppearanceUpdate()
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - User Interactions
    
    // function which is triggered when handleTap is called
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    // MARK: - Override Methods
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - UI and Constraints methods
    
    fileprivate func setupViews() {
        view.backgroundColor = UIColor.gray
        
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
       
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
    }
}


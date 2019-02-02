//
//  ITHomeViewController.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit

import Alamofire

class ITHomeViewController: UIViewController {

    // MARK: - Properties

    fileprivate weak var videoListTableView: UITableView!

    // MARK: - Lifecycle
    
    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        title = "Home"
    }
    
    // MARK: - User Interactions
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    fileprivate func fetchData() {
        guard let url = URL(string: "​https://interview-e18de.firebaseio.com/media.json?print=pretty​") else {
            return
        }
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil)
            .validate()
            .responseJSON { response in
                guard response.result.isSuccess else {
                    print("Error")
                        //completion(nil)
                    return
                }
                
                guard let value = response.result.value as? [String: Any],
                    let rows = value["rows"] as? [[String: Any]] else {
                        print("Malformed data received from fetchAllRooms service")
                        return
                }
        
    }
    }
    
    // MARK: - UI and Constraints methods

    fileprivate func setupViews() {
        view.backgroundColor = .white

        let videoListTableView = UITableView.ITTableView(backgroundColor: UIColor.clear, delegate: self)
        videoListTableView.register(ITHomeTableViewCell.self, forCellReuseIdentifier: ITHomeTableViewCell.reuseIdentifier)
        videoListTableView.sectionHeaderHeight = 0.1

        view.addSubview(videoListTableView)
        
        self.videoListTableView = videoListTableView

        setupConstraints()
    }

    fileprivate func setupConstraints() {
        videoListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoListTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        videoListTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        videoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ITHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: ITHomeTableViewCell.reuseIdentifier, for: indexPath) as? ITHomeTableViewCell
            
            return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

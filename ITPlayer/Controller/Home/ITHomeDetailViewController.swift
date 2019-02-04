//
//  ITHomeDetailViewController.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import AVKit

class ITHomeDetailViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate var preferencesManager: PreferencesManagerProtocol = UserDefaultsManager.shared
    
    fileprivate weak var videoListTableView: UITableView!
    
    fileprivate weak var activityView: UIActivityIndicatorView!
    
    fileprivate var selectedIndex: Int = -1
    
    var tableViewDataArray = [ITVideos]()
    
    // MARK: - Lifecycle
    
    // Custom initializers go here
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        title = "HomeDetail"
    }
    
    // MARK: - User Interactions
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    fileprivate func addVideosInQueue() {
        var queue: [AVPlayerItem] = []
        
        var count = 0
        
        var canAddVideos: Bool = false

        for item in tableViewDataArray {
            count += 1
            
            if selectedIndex == count - 1 || canAddVideos {
                canAddVideos = true
            if let videoUrl = item.videoUrl {
                queue.append(AVPlayerItem(url: URL(string: videoUrl)!))
            }
            }
        }
        
        let player = AVQueuePlayer(items: queue)
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    // MARK: - UI and Constraints methods
    
    fileprivate func setupViews() {
        view.backgroundColor = .white
        
        let activityView = UIActivityIndicatorView(style: .white)
        activityView.color = UIColor.gray
        activityView.center = view.center
        
        let videoListTableView = UITableView.ITTableView(backgroundColor: UIColor.clear, delegate: self)
        videoListTableView.register(ITHomeDetailTableViewCell.self, forCellReuseIdentifier: ITHomeDetailTableViewCell.reuseIdentifier)
        videoListTableView.rowHeight = UITableView.automaticDimension
        videoListTableView.separatorColor = UIColor.gray
        videoListTableView.separatorStyle = .singleLine
        
        view.addSubview(videoListTableView)
        view.addSubview(activityView)
        
        self.videoListTableView = videoListTableView
        self.activityView = activityView
        
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        videoListTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoListTableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        videoListTableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        videoListTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}

extension ITHomeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITHomeDetailTableViewCell.reuseIdentifier, for: indexPath) as? ITHomeDetailTableViewCell
        
        let dict = tableViewDataArray[indexPath.row]
        
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        if indexPath.row == tableViewDataArray.count - 1 {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        } else {
            cell?.separatorInset = UIEdgeInsets(top: 0, left: 20.0, bottom: 0, right: 0)
        }
        
        cell?.videoList = dict
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        addVideosInQueue()
    }
}



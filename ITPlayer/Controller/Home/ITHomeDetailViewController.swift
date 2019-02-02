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
    
    var tableViewDataArray = [Dictionary<String, Any>]()
    
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
        
        let dict = tableViewDataArray[indexPath.row]
        if let videoUrl = dict["url"] as? String {
        let videoURL = URL(string: videoUrl)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = ITPlayerViewController()
        playerViewController.player = player
        playerViewController.delegate = self
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
        }
    }
}

extension ITHomeDetailViewController: AVPlayerViewControllerDelegate {
    
    func playerViewControllerWillStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    func playerViewControllerDidStartPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, failedToStartPictureInPictureWithError error: Error) {
        
    }
    
    func playerViewControllerWillStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    func playerViewControllerDidStopPictureInPicture(_ playerViewController: AVPlayerViewController) {
        
    }
    
    func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: AVPlayerViewController) -> Bool {
        return true
    }
    
    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        
    }
    
    func playerViewControllerDidEndDismissalTransition(_ playerViewController: AVPlayerViewController) {
        print("dismissed")
    }
}


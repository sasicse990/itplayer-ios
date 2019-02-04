//
//  ITHomeDetailViewController.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import AVKit
import CoreMedia

class ITHomeDetailViewController: UIViewController {
    
    // MARK: - Properties
    fileprivate var preferencesManager: PreferencesManagerProtocol = UserDefaultsManager.shared
    
    fileprivate weak var videoListTableView: UITableView!
    
    fileprivate weak var activityView: UIActivityIndicatorView!
    
    fileprivate var selectedIndex: Int = -1
    
    fileprivate var player = AVQueuePlayer()
    
    var timeObserverToken: Any?
    
    var tableViewDataArray = [ITVideos]()
    
    var selectedVideo: ITVideos?
    
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
    
    // Remove Observer
    deinit {
        NotificationCenter.default.removeObserver(self)
        
        removePeriodicTimeObserver()
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
                    let playeritem = AVPlayerItem(url: URL(string: videoUrl)!)
                    let float64 = Double(item.playBackTime)
                    let timeScale = CMTimeScale(NSEC_PER_SEC)
                    playeritem.seek(to: CMTime(seconds: float64, preferredTimescale: timeScale), completionHandler: nil)
                    queue.append(playeritem)
                }
            }
        }
        
        player = AVQueuePlayer(items: queue)
        
        let timeScale = CMTimeScale(NSEC_PER_SEC)
        let time = CMTime(seconds: 0.1, preferredTimescale: timeScale)
        
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: time,
                                                           queue: .main) {
                                                            [weak self] time in
                                                            // update player transport UI
                                                            
                                                            let asset = self?.player.currentItem?.asset
                                                            if asset == nil {
                                                                return
                                                            }
                                                            if let urlAsset = asset as? AVURLAsset {
                                                                for item in (self?.tableViewDataArray)! {
                                                                    if urlAsset.url == URL(string: item.videoUrl!) {
                                                                        item.playBackTime = time.durationText
                                                                        
                                                                        CoreDataStack.shared.saveContexts()
                                                                    }
                                                                }
                                                            }
                                                            
                                                            print(time.durationText)
        }
        
        let playerViewController = AVPlayerViewController()
        
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
    
    func removePeriodicTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
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

extension CMTime {
    var durationText:Float {
        let totalSeconds = CMTimeGetSeconds(self)
        
        return Float(totalSeconds)
    }
}


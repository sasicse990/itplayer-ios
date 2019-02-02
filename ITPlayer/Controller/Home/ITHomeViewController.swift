//
//  ITHomeViewController.swift
//  ITPlayer
//
//  Created by Admin on 01/02/19.
//  Copyright © 2019 Test. All rights reserved.
//

import UIKit
import Firebase

class ITHomeViewController: UIViewController {

    // MARK: - Properties
    fileprivate var preferencesManager: PreferencesManagerProtocol = UserDefaultsManager.shared

    fileprivate weak var videoListTableView: UITableView!
    
    fileprivate weak var activityView: UIActivityIndicatorView!

    fileprivate var tableViewDataArray = [Dictionary<String, Any>]()

    // MARK: - Lifecycle
    
    // Custom initializers go here

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        fetchData {
            DispatchQueue.main.async {
                self.activityView.stopAnimating()
                
                self.videoListTableView.reloadData()
            }
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        title = "Home"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutAction(_ :)))
    }
    
    // MARK: - User Interactions
    
    @objc fileprivate func logoutAction(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            preferencesManager.isUserLogged = false
            preferencesManager.removeSavedData()
            AppDelegate.sharedDelegate()?.setupViewControllers()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    // MARK: - Public methods
    
    // MARK: - Private methods
    
    fileprivate func fetchData(compltionHandler: (() -> Void)? = nil) {
        activityView.startAnimating()
        if let url = URL(string: "https://interview-e18de.firebaseio.com/media.json?print=pretty") {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let unwrappedData = data else { return }
                do {
                    let str = try JSONSerialization.jsonObject(with: unwrappedData, options: .allowFragments)
                    self.tableViewDataArray = str as! [Dictionary<String, Any>]
                    print(str)
                    if self.tableViewDataArray.count > 0 {
                        for item in self.tableViewDataArray {
                            if let aId = item["id"] as? String {
                                let video = ITVideos.fetchRequest(for: Int64(aId) ?? 0)
                                
                                video.populateWithDetails(representation: item)
                                
                                CoreDataStack.shared.saveContexts()
                            }
                        }
                    }
                    if let handler = compltionHandler {
                        handler()
                    }
                } catch {
                    if let handler = compltionHandler {
                        handler()
                    }
                    print("json error: \(error)")
                }
            }
            task.resume()
        }
    }
    
    // MARK: - UI and Constraints methods

    fileprivate func setupViews() {
        view.backgroundColor = .white

        let activityView = UIActivityIndicatorView(style: .white)
        activityView.color = UIColor.gray
        activityView.center = view.center
        
        let videoListTableView = UITableView.ITTableView(backgroundColor: UIColor.clear, delegate: self)
        videoListTableView.register(ITHomeTableViewCell.self, forCellReuseIdentifier: ITHomeTableViewCell.reuseIdentifier)
        videoListTableView.rowHeight = 50.0

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

extension ITHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return tableViewDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ITHomeTableViewCell.reuseIdentifier, for: indexPath) as? ITHomeTableViewCell
        let dict = tableViewDataArray[indexPath.row]
        
        cell?.videoList = dict
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict = tableViewDataArray[indexPath.row]
        
        let videoList = ITVideos.fetchVideoList()
        
        if let videoID = dict["id"] as? String {
    
        let array = videoList.filter { (representation) -> Bool in
            return representation.id != Int64(videoID)
        }
        
        let homeDetailVC = ITHomeDetailViewController()
        
        homeDetailVC.tableViewDataArray = array
        
        navigationController?.pushViewController(homeDetailVC, animated: true)
        }
    }
}

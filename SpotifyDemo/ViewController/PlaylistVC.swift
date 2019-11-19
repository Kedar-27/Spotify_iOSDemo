//
//  PlaylistVC.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 13/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit

class PlaylistVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "PlaylistVC"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    @IBOutlet weak var playlistTableView: UITableView!
    
    
    // MARK: - Properties
    
    var playlistItems = [PlaylistItem](){
        didSet{
            self.playlistTableView.reloadData()
        }
    }
    
    // MARK: - Data Injections
    
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupVC()
        self.getCurrentUserPlaylist()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupUI()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func setupVC(){
        self.playlistTableView.delegate = self
        self.playlistTableView.dataSource = self
        
        
        
    }
    
    func setupUI(){
         self.navigationItem.title = "Playlists"
        
    }
    
    
    
    
    
    
    
    
    // MARK: - Network Call


    func getCurrentUserPlaylist(){
        SpotifyHelper.shared.getListOfCurrentUserPlaylist(accessToken: SpotifyHelper.shared.sessionManager.session?.accessToken ?? "", limit: 10, offset: 0) { (data, error, code) in
            
            guard error == nil ,let data = data else {
                if (error?.localizedDescription) != nil{
                    // Alert.showAlert(on: self ?? UIViewController(), with: Constants.current.appName, message: message)
                }
                
                return
            }
            
            if code == 200{
                
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: data as! NSDictionary, options: .prettyPrinted)
                    let downloadedJson = try JSONDecoder().decode(PlaylistsResponseModel.self, from: jsonData)
                    
                    
                    self.playlistItems = downloadedJson.items
                    
                    
                    
                }catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                    
                }
            }else{
          
                
                }
            
            }
    }

}
extension PlaylistVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.playlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let data = self.playlistItems[indexPath.row]
        

        cell.textLabel?.text = data.name
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let data = self.playlistItems[indexPath.row]
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: TracksListVC.storyboardName, bundle: nil)
            let tracksListVC = storyBoard.instantiateViewController(withIdentifier: TracksListVC.storyboardIdentifier) as? TracksListVC
            tracksListVC?.selectedPlaylistID = data.id
            self.navigationController?.pushViewController(tracksListVC!, animated: true)
        }
        
        
    }
    
    
    
    
}

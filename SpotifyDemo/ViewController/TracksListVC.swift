//
//  TracksListVC.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 13/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit

class TracksListVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "TracksListVC"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    @IBOutlet weak var tracksTableView: UITableView!
    
    
    // MARK: - Properties
    var tracks = [PlaylistsTrack](){
        didSet{
            self.tracksTableView.reloadData()
        }
    }
    
    
    // MARK: - Data Injections
    var selectedPlaylistID = ""
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupVC()
        self.getPlaylistTracks()
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
        self.tracksTableView.delegate = self
        self.tracksTableView.dataSource = self
        
        
        
    }
    
    func setupUI(){
        self.navigationItem.title = "Playlist Tracks"
    }
    
    // MARK: - Network Call
    
    
    func getPlaylistTracks(){
        SpotifyHelper.shared.getPlaylistTrack(accessToken: SpotifyHelper.shared.sessionManager.session?.accessToken ?? "", playlistId: self.selectedPlaylistID , limit: 10, offset: 0) { (data, error, code) in
            
            guard error == nil ,let data = data else {
                if (error?.localizedDescription) != nil{
                    // Alert.showAlert(on: self ?? UIViewController(), with: Constants.current.appName, message: message)
                }
                
                return
            }
            
            if code == 200{
                
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: data as! NSDictionary, options: .prettyPrinted)
                    let downloadedJson = try JSONDecoder().decode(PlaylistTrackResponseModel.self, from: jsonData)
                    
                    
                    self.tracks = downloadedJson.items
                    
                    
                    
                }catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                    
                }
            }else{
                
                
            }
            
        }
    }
}
extension TracksListVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        let data = self.tracks[indexPath.row]
        
        
        cell.textLabel?.text = data.track.name
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.tracks[indexPath.row]
        
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: TrackVC.storyboardName, bundle: nil)
            let trackVC = storyBoard.instantiateViewController(withIdentifier: TrackVC.storyboardIdentifier) as? TrackVC
            trackVC?.trackID = data.track.id
            self.navigationController?.pushViewController(trackVC!, animated: true)
        }
        
        
        
        
        
        
    }
    
    
    
    
}

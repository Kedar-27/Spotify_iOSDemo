//
//  TrackVC.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 13/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit

class TrackVC: UIViewController {

    // MARK: - Constants
    static let storyboardIdentifier = "TrackVC"
    static let storyboardName       = "Main"
    
    // MARK: - Outlets
    
    @IBOutlet weak var tracksTextView: UITextView!
    
    
    // MARK: - Properties
    
    
    
    // MARK: - Data Injections
    var trackID = ""
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupVC()
        self.getTrackData()
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
        
        
        
        
    }
    
    func setupUI(){
        
        
        
        
        
        
        
        
    }
    
    // MARK: - Network Calls

    func getTrackData(){
        
        SpotifyHelper.shared.getTrack(accessToken: SpotifyHelper.shared.sessionManager.session?.accessToken ?? "", trackId: self.trackID) { (data, error, code) in
            guard error == nil ,let data = data else {
                if (error?.localizedDescription) != nil{
                    // Alert.showAlert(on: self ?? UIViewController(), with: Constants.current.appName, message: message)
                }
                
                return
            }
            
            if code == 200{
                
                do{
                    let jsonData = try JSONSerialization.data(withJSONObject: data as! NSDictionary, options: .prettyPrinted)
                    let downloadedJson = try JSONDecoder().decode(TrackResponseModel.self, from: jsonData)
                    
                    
                    self.tracksTextView.text = String(data: jsonData, encoding: .utf8)
                    
                    
                    
                }catch let jsonErr {
                    print("Error serializing json:", jsonErr)
                    
                }
            }else{
                
                
            }
            
        
        }

    }
 
}

//
//  ViewController.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 12/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    
   
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SpotifyHelper.shared.delegate = self
    }
    
    
    
    
    // MARK: - IBActions
    @IBAction func connectButtonClicked(_ sender: Any) {
        SpotifyHelper.shared.performAuthentication()
        
        
    }
    
    func showPlaylistsVC(){
        DispatchQueue.main.async {
            let storyBoard = UIStoryboard(name: PlaylistVC.storyboardName, bundle: nil)
            let playlistVC = storyBoard.instantiateViewController(withIdentifier: PlaylistVC.storyboardIdentifier) as? PlaylistVC
            
            self.navigationController?.pushViewController(playlistVC!, animated: true)
        }
        
        

    }

}

extension LoginVC: SPAuthenticationHelperDelegate{
    func didFailAuthentication(with error: Error) {
        
        
        presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "OK")
        
        
    }
    
    func didInitiatedSession(with accessToken: String) {
        
        
        self.showPlaylistsVC()
        
        
        
    }
    
    func didRenewSession(with accessToken: String) {
        
        
        
        
        
    }
    
    
    fileprivate func presentAlertController(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async{
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true)
        }
        
    }
    
    
    
    
    
    
    
}

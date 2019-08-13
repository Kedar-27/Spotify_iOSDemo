//
//  SpotifyHelper.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 12/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation



class SpotifyHelper: NSObject{
    
    // MARK: - Properties
    private let SpotifyClientID = "4f02aa623a054b1a9d10bfa249f5bd00"
    private let SpotifyRedirectURI = URL(string: "spotify-ios-demo://spotify-login-callback")!
    
    
    lazy var configuration: SPTConfiguration = {
        let configuration = SPTConfiguration(clientID: SpotifyClientID, redirectURL: SpotifyRedirectURI)
        // Set the playURI to a non-nil value so that Spotify plays music after authenticating and App Remote can connect
        // otherwise another app switch will be required
        configuration.playURI = ""
        
        // Set these url's to your backend which contains the secret to exchange for an access token
        // You can use the provided ruby script spotify_token_swap.rb for testing purposes
        configuration.tokenSwapURL = URL(string: "https://spotify-ios-demo.herokuapp.com/api/token")
        configuration.tokenRefreshURL = URL(string: "https://spotify-ios-demo.herokuapp.com/api/refresh_token")
        return configuration
    }()
    
    lazy var sessionManager: SPTSessionManager = {
        let manager = SPTSessionManager(configuration: configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
      //  appRemote.delegate = self
        return appRemote
    }()
    
    // MARK: - Helper Functions
    public func performAuthentication(){
        /*
         Scopes let you specify exactly what types of data your application wants to
         access, and the set of scopes you pass in your call determines what access
         permissions the user is asked to grant.
         For more information, see https://developer.spotify.com/web-api/using-scopes/.
         */
        let scope: SPTScope = [.appRemoteControl, .playlistReadPrivate]
        
        if #available(iOS 11, *) {
            // Use this on iOS 11 and above to take advantage of SFAuthenticationSession
            self.sessionManager.initiateSession(with: scope, options: .clientOnly)
        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
           // self.sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
    }
}
extension SpotifyHelper: SPTSessionManagerDelegate{
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        
        
        
        
      //  presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        
        
        
       // presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        appRemote.connectionParameters.accessToken = session.accessToken
        appRemote.connect()
    }
    
}

//extension SpotifyHelper: SPTAppRemoteDelegate{
//
//    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
//        updateViewBasedOnConnected()
//        appRemote.playerAPI?.delegate = self
//        appRemote.playerAPI?.subscribe(toPlayerState: { (success, error) in
//            if let error = error {
//                print("Error subscribing to player state:" + error.localizedDescription)
//            }
//        })
//        fetchPlayerState()
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
//        updateViewBasedOnConnected()
//        lastPlayerState = nil
//    }
//
//    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
//        updateViewBasedOnConnected()
//        lastPlayerState = nil
//    }
//
//}




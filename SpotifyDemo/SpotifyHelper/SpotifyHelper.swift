//
//  SpotifyHelper.swift
//  SpotifyDemo
//
//  Created by Kedar Sukerkar on 12/08/19.
//  Copyright © 2019 Kedar Sukerkar. All rights reserved.
//

import Foundation


fileprivate struct SpotifyAPI{
    static let baseURL = "https://api.spotify.com"
    static let getCurrentUserProfile = "/v1/me"
    static let getListOfCurrentUserPlaylists = "/v1/me/playlists"
    static let getPlaylistTracks = "/v1/playlists/"
    static let getTrack = "/v1/tracks/"
}

protocol SPAuthenticationHelperDelegate: class{
    func didFailAuthentication(with error: Error)
    func didInitiatedSession(with accessToken: String)
    func didRenewSession(with accessToken: String)
}


class SpotifyHelper: NSObject{
    
    // MARK: - Properties
    public static let shared = SpotifyHelper()
    
    private override init() {
//        auth.redirectURL     = SpotifyRedirectURI
//        auth.clientID        = SpotifyClientID
//        auth.requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
//        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    
    
    private let SpotifyClientID = "4f02aa623a054b1a9d10bfa249f5bd00"
    private let SpotifyRedirectURI = URL(string: "spotify-ios-demo://spotify-login-callback")!
    //private var auth = SPTAuth.defaultInstance()
   // private var session:SPTSession!
   // private var loginUrl: URL?
    
    public typealias networkResponse = (_ response: Any? , _ error: Error? , _ statusCode: Int) -> Void
    
    
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
//
//    lazy var appRemote: SPTAppRemote = {
//        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
//      //  appRemote.delegate = self
//        return appRemote
//    }()
    
    
    
    
    // MARK: - Delegates
    public weak var delegate: SPAuthenticationHelperDelegate?
    
    
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
            if self.sessionManager.isSpotifyAppInstalled == true {
                self.sessionManager.initiateSession(with: scope, options: .clientOnly)
            }else{
                if let link = URL(string: "https://accounts.spotify.com/authorize?client_id=\(SpotifyClientID)&response_type=code&redirect_uri=\(SpotifyRedirectURI)&scope=user-read-private%20user-read-email"){
                           UIApplication.shared.open(link)
                       }
            }

        } else {
            // Use this on iOS versions < 11 to use SFSafariViewController
           //self.sessionManager.initiateSession(with: scope, options: .clientOnly, presenting: self)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    public func getCurrentUserProfile(accessToken: String ,completionHandler: @escaping networkResponse){
        
        let api = SpotifyAPI.getCurrentUserProfile

        SpotifyNetworkManager.shared.sendRequest(methodType: .get, apiName: api, parameters: nil, headers: ["Authorization": "Bearer " + accessToken,"Content-Type": "application/json"], baseURL: SpotifyAPI.baseURL) { (data, error, code) in
            completionHandler(data,error,code ?? 404)
        }
        
        
        
    }
    
    public func getListOfCurrentUserPlaylist(accessToken: String , limit: Int , offset: Int ,completionHandler: @escaping networkResponse){
        let api = SpotifyAPI.getListOfCurrentUserPlaylists + "?limit=\(limit)&offset=\(offset)"
        
        SpotifyNetworkManager.shared.sendRequest(methodType: .get, apiName: api, parameters: nil, headers: ["Authorization": "Bearer " + accessToken,"Content-Type": "application/json"], baseURL: SpotifyAPI.baseURL) { (data, error, code) in
            completionHandler(data,error,code ?? 404)
        }
    }
    
    
    public func getPlaylistTrack(accessToken: String, playlistId: String, limit: Int, offset: Int, completionHandler: @escaping networkResponse){
        
        let api = SpotifyAPI.getPlaylistTracks + playlistId + "/tracks?limit=\(limit)&offset=\(offset)"
        
        SpotifyNetworkManager.shared.sendRequest(methodType: .get, apiName: api, parameters: nil, headers: ["Authorization": "Bearer " + accessToken,"Content-Type": "application/json"], baseURL: SpotifyAPI.baseURL) { (data, error, code) in
            completionHandler(data,error,code ?? 404)
        }
    }
    
    
    public func getTrack(accessToken: String, trackId: String, completionHandler: @escaping networkResponse){
        
        let api = SpotifyAPI.getTrack + trackId
        
        SpotifyNetworkManager.shared.sendRequest(methodType: .get, apiName: api, parameters: nil, headers: ["Authorization": "Bearer " + accessToken,"Content-Type": "application/json"], baseURL: SpotifyAPI.baseURL) { (data, error, code) in
            completionHandler(data,error,code ?? 404)
        }
    }
}


extension SpotifyHelper: SPTSessionManagerDelegate{
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {


        self.delegate?.didFailAuthentication(with: error)
//        if let link = URL(string: "https://accounts.spotify.com/authorize?client_id=\(SpotifyClientID)&response_type=code&redirect_uri=\(SpotifyRedirectURI)&scope=user-read-private%20user-read-email"){
//                   UIApplication.shared.openURL(link)
//               }

      //  presentAlertController(title: "Authorization Failed", message: error.localizedDescription, buttonTitle: "Bummer")
    }

    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {

        self.delegate?.didRenewSession(with: session.accessToken)

       // presentAlertController(title: "Session Renewed", message: session.description, buttonTitle: "Sweet")
    }

    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {

        self.delegate?.didInitiatedSession(with: session.accessToken)

        // appRemote.connectionParameters.accessToken = session.accessToken
      //  appRemote.connect()
    }

    func sessionManager(manager: SPTSessionManager, shouldRequestAccessTokenWith code: String) -> Bool {
        return true
    }

    // MARK: - Spotify web helpers
    
//    func getAccessToken
    
    


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






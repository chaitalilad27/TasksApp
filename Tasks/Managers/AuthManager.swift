//
//  AuthManager.swift
//  Tasks
//
//  Created by Chaitali Lad on 16/01/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn
import FacebookLogin

class AuthManager: NSObject, ObservableObject {

    // MARK: - Properties

    @Published var isUserLoggedIn = false
    let loginManager = LoginManager()

    // MARK: - Initialization

    override init() {
        super.init()
        setupAuthStateChangeListener()
    }

    // MARK: - Methods

    // MARK: Auth State Change Listener

    /// Sets up the authentication state change listener to track user login status.
    private func setupAuthStateChangeListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isUserLoggedIn = user != nil
            }
        }
    }

    // MARK: Sign Out

    /// Signs out the current user.
    /// - Parameter completion: Closure called upon completion with an optional error.
    func signOut(completion: @escaping (Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let signOutError as NSError {
            completion(signOutError)
        }
    }
}

// MARK: - Account Creation and Sign In

extension AuthManager {

    // MARK: Create Account

    /// Creates a new user account with the provided email and password.
    /// - Parameters:
    ///   - email: User's email address.
    ///   - password: User's desired password.
    ///   - completion: Closure called upon completion with an optional error.
    func createAccount(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: Sign In with Email and Password

    /// Signs in the user with the provided email and password.
    /// - Parameters:
    ///   - email: User's email address.
    ///   - password: User's password.
    ///   - completion: Closure called upon completion with an optional error.
    func signInWithEmail(withEmail email: String, password: String, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(error)
            } else {
                completion(nil)
            }
        }
    }

    // MARK: Sign In with Firebase Credential

    /// Signs in the user with the provided Firebase credential.
    /// - Parameters:
    ///   - credential: Firebase credential obtained from external authentication.
    ///   - completion: Closure called upon completion with an optional error.
    private func signInWithFirebase(withCredential credential: AuthCredential, completion: @escaping (Error?) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error = error {
                completion(error)
                return
            }
            completion(nil)
        }
    }
}

// MARK: - Google Sign In

extension AuthManager {

    // MARK: Sign In with Google

    /// Initiates the Google Sign In process.
    /// - Parameters:
    ///   - presenting: The view controller to present the Google Sign In interface.
    ///   - completion: Closure called upon completion with an optional error.
    func signInWithGoogle(presenting: UIViewController, completion: @escaping (Error?) -> Void) {
        guard let googleClientID = FirebaseApp.app()?.options.clientID else { return }

        let googleSignInConfig = GIDConfiguration(clientID: googleClientID)
        GIDSignIn.sharedInstance.configuration = googleSignInConfig

        GIDSignIn.sharedInstance.signIn(withPresenting: presenting) { signInResult, error in
            if let error = error {
                completion(error)
                return
            }

            guard let user = signInResult?.user, let idToken = user.idToken else {
                completion(error)
                return
            }

            let accessToken = user.accessToken
            let googleAuthCredential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            self.signInWithFirebase(withCredential: googleAuthCredential, completion: completion)
        }
    }
}

// MARK: - Facebook Sign In

extension AuthManager {

    // MARK: Sign In with Facebook

    /// Initiates the Facebook Sign In process.
    /// - Parameters:
    ///   - completion: Closure called upon completion with an optional error.
    func signWithWithFacebook(completion: @escaping (Error?) -> Void) {
        loginManager.logIn(permissions: ["public_profile", "email"], from: nil) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let result = result, !result.isCancelled {
                guard let accessToken = result.token else {
                    completion(error)
                    return
                }

                let facebookAuthCredential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
                self.signInWithFirebase(withCredential: facebookAuthCredential, completion: completion)
            }
        }
    }
}

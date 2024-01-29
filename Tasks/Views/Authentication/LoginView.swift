//
//  LoginView.swift
//  Tasks
//
//  Created by Chaitali Lad on 16/01/24.
//

import SwiftUI
import GoogleSignInSwift
import FacebookLogin

// MARK: - LoginView

struct LoginView: View {

    // MARK: - Properties

    @EnvironmentObject var authManager: AuthManager
    @StateObject var keyboardManager = KeyboardManager()

    @State private var emailText: String = ""
    @State private var passwordText: String = ""

    @State private var emailTextFieldState: TextFieldState = .none
    @State private var passwordTextFieldState: TextFieldState = .none

    @State private var emailTextFieldErrorMessage = "emailErrorMessage".localized
    @State private var passwordTextFieldErrorMessage = "passwordErrorMessage".localized

    @State private var showErrors: Bool = false
    @State private var showToast: Bool = false
    @State private var toastMessage: String = ""

    @State private var isLoading: Bool = false

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {


                VStack(alignment: .leading, spacing: 50) {
                    //   Spacer()
                    
                    // Title
                    Text("login".localized)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.appThemeColor)
                    
                    // Text Fields
                    VStack(alignment: .leading, spacing: 20) {
                        createTextField($emailText, $emailTextFieldState, $showErrors, $emailTextFieldErrorMessage, "email".localized, .emailAddress) { isEmailValid() }
                        createTextField($passwordText, $passwordTextFieldState, $showErrors, $passwordTextFieldErrorMessage, "password".localized) { isPasswordValid() }
                    }
                    
                    // Action Buttons
                    VStack(alignment: .center, spacing: 10) {
                        createActionButton("login".localized.uppercased()) { login() }
                        
                        NavigationLink {
                            SignupView()
                        } label: {
                            createLink("dontHaveAnAccount".localized + " " + "signup".localized.uppercased())
                        }
                        
                        Text("or".localized)
                            .font(.title3)
                            .foregroundColor(.appThemeColor)
                            .padding(.bottom, 15)

                        HStack(spacing: 30) {
                            // Google Sign-In Button
                            GoogleSignInButton(style: .icon, action: { signInWithGoogle() })
                                .scaleEffect(1.6)

                            Button(action: {
                                signInWithFacebook()
                            }) {
                                Image("facebook")
                                    .resizable()
                                    .frame(width: 40, height: 35)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 12)
                                    .background(Color.white)
                                    .cornerRadius(3)
                                    .shadow(color: Color.gray, radius: 3, x: 0, y: 2)
                            }
                        }
                    }
                    
                    //    Spacer()
                }
                .padding(20)
                .disabled(isLoading)
                .toast(isPresented: $showToast, message: toastMessage)
                .onTapGesture {
                    keyboardManager.hideKeyboard()
                }

                if isLoading {
                    Color.black.opacity(0.06).ignoresSafeArea(.all)
                    ActivityIndicatorView(color: .appThemeColor, scaleSize: 3.0)
                        .padding(.bottom,50)
                }
            }
            .frame(maxHeight: .infinity)
        }
    }

    // MARK: - Helper Methods

    private func createTextField(
        _ text: Binding<String>,
        _ state: Binding<TextFieldState>,
        _ showError: Binding<Bool>,
        _ errorMessage: Binding<String>,
        _ placeholder: String,
        _ keyboardType: UIKeyboardType = .default,
        onChange: @escaping () -> Void
    ) -> some View {
        CLTextField(text: text, state: state, showError: showError, errorMessage: errorMessage, placeholder: placeholder, keyboardType: keyboardType)
            .onChange(of: text.wrappedValue) { _ in onChange() }
    }

    private func createActionButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(15)
        }
        .frame(maxWidth: .infinity)
        .background(Color.appThemeColor)
        .cornerRadius(.infinity)
    }

    private func createLink(_ label: String) -> some View {
        Text(label)
            .font(.body)
            .fontWeight(.regular)
            .foregroundColor(.gray)
            .padding(10)
            .frame(maxWidth: .infinity)
    }

    // MARK: - Validation Methods

    private func isEmailValid() {
        emailTextFieldState = emailText.isValid(type: .email, isRequired: true) ? .valid : .error
    }

    private func isPasswordValid() {
        passwordTextFieldState = passwordText.isValid(type: .password, isRequired: true) ? .valid : .error
    }

    // MARK: - Authentication Methods

    private func login() {
        keyboardManager.hideKeyboard()
        guard emailTextFieldState == .valid, passwordTextFieldState == .valid else {
            showErrors = true
            return
        }
        isLoading = true
        showErrors = false
        authManager.signInWithEmail(withEmail: emailText, password: passwordText) { error in
            handleSignInResponse(error: error)
        }
    }

    private func signInWithGoogle() {
        keyboardManager.hideKeyboard()
        authManager.signInWithGoogle(presenting: getRootViewController()) { error in
            isLoading = true
            handleSignInResponse(error: error)
        }
    }

    private func signInWithFacebook() {
        keyboardManager.hideKeyboard()
        authManager.signWithWithFacebook() { error in
            isLoading = true
            handleSignInResponse(error: error)
        }
    }

    private func handleSignInResponse(error: Error?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            if error != nil {
                toastMessage = "somethingWentWrong".localized
            } else {
                toastMessage = "loggedInSuccessfully".localized
            }
            showToast = true
        }
    }
}

// MARK: - LoginView_Previews

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

//
//  SignupView.swift
//  Tasks
//
//  Created by Chaitali Lad on 16/01/24.
//

import SwiftUI
import GoogleSignInSwift

// MARK: - SignupView

struct SignupView: View {

    // MARK: - Properties

    @EnvironmentObject var authManager: AuthManager
    @Environment(\.presentationMode) var presentationMode
    @StateObject var keyboardManager = KeyboardManager()

    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var confirmPasswordText: String = ""

    @State private var emailTextFieldState: TextFieldState = .none
    @State private var passwordTextFieldState: TextFieldState = .none
    @State private var confirmPasswordTextFieldState: TextFieldState = .none

    @State private var emailTextFieldErrorMessage = "emailErrorMessage".localized
    @State private var passwordTextFieldErrorMessage = "passwordErrorMessage".localized
    @State private var confirmPasswordTextFieldErrorMessage = "confirmPasswordErrorMessage".localized

    @State private var showErrors: Bool = false
    @State private var showToast = false
    @State private var toastMessage = ""

    @State private var isLoading: Bool = false

    // MARK: - Body

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 50) {
                Spacer()
                
                // Title
                Text("createAccount".localized)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.appThemeColor)
                
                // Text Fields
                VStack(alignment: .leading, spacing: 20) {
                    createTextField($emailText, $emailTextFieldState, $showErrors, $emailTextFieldErrorMessage, "email".localized, .emailAddress) { isEmailValid() }
                    createTextField($passwordText, $passwordTextFieldState, $showErrors, $passwordTextFieldErrorMessage, "password".localized) { isPasswordValid() }
                    createTextField($confirmPasswordText, $confirmPasswordTextFieldState, $showErrors, $confirmPasswordTextFieldErrorMessage, "confirmPassword".localized) { isConfirmPasswordValid() }
                }
                
                // Action Buttons
                VStack(alignment: .center, spacing: 10) {
                    createActionButton("signup".localized.uppercased()) { signUp() }
                    alreadyHaveAccountView
                    
                    Text("or".localized)
                        .font(.title3)
                        .foregroundColor(.appThemeColor)
                        .padding(.bottom, 15)
                    
                    // Google Sign-In Button
                    GoogleSignInButton(style: .icon, action: { signUpWithGoogle() })
                        .scaleEffect(1.6)
                }
                
                Spacer()
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

    private var alreadyHaveAccountView: some View {
        Text("alreadyHaveAnAccount".localized + " " + "login".localized.uppercased())
            .font(.body)
            .fontWeight(.regular)
            .foregroundColor(.gray)
            .padding(10)
            .frame(maxWidth: .infinity)
            .onTapGesture {
                presentationMode.wrappedValue.dismiss()
            }
    }

    // MARK: - Validation Methods

    private func isEmailValid() {
        emailTextFieldState = emailText.isValid(type: .email, isRequired: true) ? .valid : .error
    }

    private func isPasswordValid() {
        passwordTextFieldState = passwordText.isValid(type: .password, isRequired: true) ? .valid : .error
    }

    private func isConfirmPasswordValid() {
        confirmPasswordTextFieldState = (confirmPasswordText == passwordText) ? .valid : .error
    }

    // MARK: - Authentication Methods

    private func signUp() {
        keyboardManager.hideKeyboard()
        guard emailTextFieldState == .valid, passwordTextFieldState == .valid, confirmPasswordTextFieldState == .valid else {
            showErrors = true
            return
        }
        showErrors = false
        isLoading = true
        authManager.createAccount(withEmail: emailText, password: passwordText) { error in
            handleSignUpResponse(error: error)
        }
    }

    private func signUpWithGoogle() {
        keyboardManager.hideKeyboard()
        authManager.signInWithGoogle(presenting: getRootViewController()) { error in
            handleSignUpResponse(error: error)
        }
    }

    private func handleSignUpResponse(error: Error?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            if error != nil {
                toastMessage = "somethingWentWrong".localized
            } else {
                toastMessage = "accountCreatedSuccessfully".localized
            }
            showToast = true
        }
    }
}

// MARK: - SignupView_Previews

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}

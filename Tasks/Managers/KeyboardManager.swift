//
//  KeyboardManager.swift
//  Tasks
//
//  Created by Chaitali Lad on 17/01/24.
//

import UIKit

// MARK: - KeyboardManager

class KeyboardManager: ObservableObject {

    // MARK: - Published Properties

    @Published var isKeyboardVisible = false

    // MARK: - Initialization

    init() {
        startObserving()
    }

    deinit {
        stopObserving()
    }

    // MARK: - Notification Observers

    private func startObserving() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func stopObserving() {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Notification Handling

    @objc private func keyboardWillChange(_ notification: Notification) {
        isKeyboardVisible = (notification.name == UIResponder.keyboardWillShowNotification)
    }

    // MARK: - Public Method

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

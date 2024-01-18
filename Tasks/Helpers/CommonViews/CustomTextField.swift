//
//  CustomTextField.swift
//  Tasks
//
//  Created by Chaitali Lad on 04/01/24.
//

import SwiftUI

// MARK: - TextFieldState

enum TextFieldState {
    case valid
    case error
    case none
}

struct CustomTextField: View {

    // MARK: - Properties

    var placeholder: String
    @Binding var text: String
    var font: Font = .body
    var cornerRadius: CGFloat = 10
    var borderColor: Color = .gray
    var borderWidth: CGFloat = 1

    // MARK: - Body

    var body: some View {
        TextField(NSLocalizedString(placeholder, comment: ""), text: $text)
            .font(font)
            .padding(15)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(placeholder: "Name", text: .constant(""))
    }
}

//struct CLTextField: View {
//
//    // MARK: - Properties
//    @State private var isEditing = false
//    @Binding var text: String
//    @Binding var textFieldState: TextFieldState
//    @Binding var showError: Bool
//    @Binding var errorMessage: String
//
//    var placeholder: String
//    var font: Font = .title2
//    var isRequired: Bool = true
//    var keyboardType: UIKeyboardType = .asciiCapable
//
//    // MARK: - Body
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 5) {
//            TextField(NSLocalizedString(placeholder, comment: ""), text: $text, onEditingChanged: { editing in
//                isEditing = editing
//            })
//            .font(font)
//            .foregroundColor((showError && textFieldState == .error) ? .red : .primary)
//            .keyboardType(keyboardType)
//            .textInputAutocapitalization(.never)
//            .disableAutocorrection(true)
//
//            Divider()
//                .frame(height: 2)
//                .background((showError && textFieldState == .error) ? Color.red : (isEditing ? Color.appThemeColor : Color.gray.opacity(0.2)))
//
//            Text(showError && textFieldState == .error ? errorMessage : "")
//                .font(.body)
//                .foregroundColor(.red)
//        }
//    }
//}
//
//
//struct CLTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CLTextField(placeholder: "Name", text: .constant(""),
//                        textFieldState: .constant(.error),
//                        showError: .constant(true),
//                        errorMessage: .constant("Invalid value"))
//    }
//}


// MARK: - CLTextField

struct CLTextField: View {

    // MARK: - Properties

    @State private var isEditing = false
    @Binding var text: String
    @Binding var state: TextFieldState
    @Binding var showError: Bool
    @Binding var errorMessage: String

    var placeholder: String
    var font: Font = .title2
    var isRequired: Bool = true
    var keyboardType: UIKeyboardType = .asciiCapable

    // MARK: - Body

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Text Field
            TextField(
                placeholder,
                text: $text,
                onEditingChanged: { editing in
                    isEditing = editing
                }
            )
            .font(font)
            .foregroundColor((showError && state == .error) ? .red : .primary)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(.none)
            .disableAutocorrection(true)

            // Divider
            Divider()
                .frame(height: 2)
                .background((showError && state == .error) ? Color.red : (isEditing ? Color.appThemeColor : Color.gray.opacity(0.2)))

            // Error Message
            Text(showError && state == .error ? errorMessage : "")
                .font(.body)
                .foregroundColor(.red)
        }
    }
}

// MARK: - CLTextField_Previews

struct CLTextField_Previews: PreviewProvider {
    static var previews: some View {
        CLTextField(text: .constant(""), state: .constant(.error),
                    showError: .constant(true),
                    errorMessage: .constant("Invalid value"),
                    placeholder: "Name")
    }
}

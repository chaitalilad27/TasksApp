//
//  CustomTextField.swift
//  Tasks
//
//  Created by Chaitali Lad on 04/01/24.
//

import SwiftUI

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

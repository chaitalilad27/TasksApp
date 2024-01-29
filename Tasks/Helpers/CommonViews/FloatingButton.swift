//
//  FloatingButton.swift
//  Tasks
//
//  Created by Chaitali Lad on 04/01/24.
//

import SwiftUI

struct FloatingButton: View {

    // MARK: - Properties

    var systemImageName: String
    var imageSize: CGSize = CGSize(width: 25, height: 25)
    var backgroundColor: Color = .appThemeColor
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 25
    var action: () -> Void

    // MARK: - Body

    var body: some View {
        Button(action: action) {
            buttonImageView
        }
        .padding(10)
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
        .cornerRadius(cornerRadius)
        .shadow(color: Color.black.opacity(0.4), radius: 5, x: 2, y: 2)
        .padding([.bottom, .trailing], 10)
    }

    // MARK: - Private Views

    private var buttonImageView: some View {
        Image(systemName: systemImageName)
            .resizable()
            .frame(width: imageSize.width, height: imageSize.height)
    }
}

struct FloatingButton_Previews: PreviewProvider {
    static var previews: some View {
        FloatingButton(systemImageName: "plus") { }
    }
}

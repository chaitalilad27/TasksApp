//
//  ToggleImageView.swift
//  Tasks
//
//  Created by Chaitali Lad on 04/01/24.
//

import SwiftUI

struct ToggleImageView: View {

    // MARK: - Properties

    var selectedImageName: String
    var unSelectedImageName: String
    var size: CGSize = CGSize(width: 25, height: 25)
    @Binding var isSelected: Bool
    var onTapAction: () -> Void

    // MARK: - Body

    var body: some View {
        Image(systemName: isSelected ? selectedImageName : unSelectedImageName)
            .resizable()
            .frame(width: size.width, height: size.height)
            .foregroundColor(isSelected ? .appYellow : .black)
            .onTapGesture {
                isSelected.toggle()
                onTapAction()
            }
    }
}

struct ToggleImageView_Previews: PreviewProvider {
    static var previews: some View {
        ToggleImageView(selectedImageName: "star.fill", unSelectedImageName: "star", isSelected: .constant(true)) { }
    }
}

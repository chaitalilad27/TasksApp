//
//  ToastMessage.swift
//  Tasks
//
//  Created by Chaitali Lad on 17/01/24.
//

import SwiftUI

struct ToastMessageView: View {
    let message: String
    let backgroundColor: Color
    let textColor: Color
    let cornerRadius: CGFloat

    var body: some View {
        VStack {
            Text(message)
                .foregroundColor(textColor)
                .padding()
                .background(backgroundColor)
                .cornerRadius(cornerRadius)
                .padding()
            Spacer()
        }
    }
}

struct ToastMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ToastMessageView(message: "No internet connection. Please try again", backgroundColor: Color.orange.opacity(0.7), textColor: Color.black, cornerRadius: 10)
    }
}

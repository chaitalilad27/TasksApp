//
//  ActivityIndicatorView.swift
//  Tasks
//
//  Created by Chaitali Lad on 12/07/23.
//

import SwiftUI

struct ActivityIndicatorView: View {
    var color: Color = .green
    var scaleSize: CGFloat = 1.0

    var body: some View {
        ProgressView()
            .scaleEffect(scaleSize, anchor: .center)
            .progressViewStyle(CircularProgressViewStyle(tint: color))
    }
}

//
//  TagView.swift
//  Tasks
//
//  Created by Chaitali Lad on 29/01/24.
//

import SwiftUI

struct TagView: View {

    // Fetches task categories from Core Data
    @FetchRequest(sortDescriptors: []) var taskCategories: FetchedResults<TaskCategory>

    // Binding to the selected task category
    @Binding var selectedCategory: TaskCategory?

    // State variable to track the total height of the TagView
    @State private var totalHeight = CGFloat.zero

    var body: some View {
        VStack {
            // GeometryReader to get the size of the parent view
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }

    // Generates the content of the TagView
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            // Iterating over task categories to create tags
            ForEach(taskCategories, id: \.self) { taskCategory in
                // Creating a tag for each task category
                item(for: taskCategory.categoryName, isSelected: selectedCategory == taskCategory)
                    .padding([.horizontal, .vertical], 6)
                    .alignmentGuide(.leading, computeValue: { d in
                        // Handling alignment based on width and height
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if taskCategory == taskCategories.last! {
                            width = 0
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: {d in
                        // Handling alignment based on height
                        let result = height
                        if taskCategory == taskCategories.last! {
                            height = 0
                        }
                        return result
                    }).onTapGesture {
                        // Setting the selected category when tapped
                        selectedCategory = taskCategory
                    }
            }
        }.background(viewHeightReader($totalHeight))
    }

    // Creates a tag item
    private func item(for text: String, isSelected: Bool) -> some View {
        Text(text)
            .font(.title3)
            .fontWeight(.regular)
            .foregroundColor(isSelected ? Color.white : Color.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .lineLimit(1)
            .background(isSelected ? Color.appThemeColor : Color.gray.opacity(0.5))
            .cornerRadius(.infinity)
    }

    // Updates the total height of the TagView using a GeometryReader
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            // Asynchronously updates the total height
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        TagView(selectedCategory: .constant(nil))
    }
}

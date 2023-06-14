//
//  ReadableContentWidthView.swift
//  SwiftUILibrary
//
//  Created by Mathijs Bernson on 07/05/2023.
//

import SwiftUI

struct ReadableContentWidthView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("On larger screens such as iPad or on iPhone in landscape mode, this view's width is restricted to the readable content guides.")
                    .font(.headline)
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec urna magna, mollis eget tincidunt sed, sollicitudin nec quam. Quisque sed massa eu augue volutpat porta ut eget tortor. Quisque dolor urna, varius in turpis sed, dignissim fermentum dolor. Vivamus sollicitudin massa non est malesuada, ac auctor purus tincidunt. Cras id sodales augue, a vestibulum lectus. Duis ornare mauris nec eleifend sodales. Nunc pharetra augue eu felis ullamcorper, a efficitur lacus euismod.")

                Text("Aliquam facilisis nisl convallis arcu euismod pulvinar. Suspendisse dignissim ullamcorper ex bibendum sollicitudin. In in lectus non eros elementum convallis eu eu augue. Nulla feugiat dignissim eleifend. Nulla vestibulum ligula eleifend massa consectetur, quis lacinia enim mollis. Aliquam leo erat, lacinia sed varius non, accumsan ut dui. In rutrum, leo eu porta faucibus, libero velit porta libero, ut dignissim dui nisl eget enim. Pellentesque laoreet congue ante, a fermentum nisi imperdiet non. Fusce vel iaculis nunc.")
            }
            .readableContentWidth()
            .padding()
        }
    }
}

struct ReadableContentWidthView_Previews: PreviewProvider {
    static var previews: some View {
        ReadableContentWidthView()
    }
}

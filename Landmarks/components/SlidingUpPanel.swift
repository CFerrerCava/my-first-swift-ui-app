//
//  SlidingUpPanel.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 18/02/24.
//

import SwiftUI

struct SlidingUpPanel<Content: View>: View {
    @ViewBuilder let content: Content
    
    @State private var offset = CGSize()
    @State private var childSize: CGSize = CGSize()
    
    var body: some View{
        GeometryReader(content: { geometry in
            content
            .offset(x:0, y: offset.height + (geometry.size.height - childSize.height))
            .gesture(DragGesture()
                .onChanged{ gesture in
                    if  gesture.translation.height > 0{
                        self.offset = gesture.translation
                    }
                }
                .onEnded{ gesture in
                    withAnimation{
                        if  gesture.translation.height >= childSize.height * 0.5{
                            self.offset = CGSize(width: 0, height: childSize.height * 0.7)
                        }else{
                            self.offset = .zero
                        }
                       
                   }
                }
            )
            .transition(.move(edge: .bottom))
            .background(){
                GeometryReader{ geo in
                    Path { path in
                        let size = geo.size
                        DispatchQueue.main.async {
                            if self.childSize != size {
                                self.childSize = size
                            }
                        }
                    }
                }
            }
        })
    }
}



//#Preview {
//    @StateObject var slidingUpController = SharedslidingUpController()
 //   SlidingUpPanel(slidingUpController:slidingUpController)
//}

//
//  WheaterTimeWidget.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 19/02/24.
//

import SwiftUI
import MapKit

struct WheaterTimeWidget: View {
    @ObservedObject var viewModel: LandMarkViewModel
    
    @State private var selectedItem: WheaterTime = times.first!
    
    var body: some View {
        ZStack(alignment: .trailing,  content: {
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Container@*/VStack/*@END_MENU_TOKEN@*/( content: {
                ZStack(content: {
                    VStack(alignment: .center) {
                        HStack(content: {
                            VStack(content: {
                                Text("\(selectedItem.tempeture)°").font(.custom("Futura",size: 50)).foregroundColor(.white)
                                Text("Thunderstorms").font(.custom("Futura",size: 20)).foregroundColor(.white)
                            })
                            Spacer()
                        }).padding(.bottom,25)
                        ScrollView(.horizontal) {
                            LazyHStack {
                                 ForEach(times, id: \.time) { item in
                                     TempetureRow(wheater: item).gesture(TapGesture().onEnded({ Void in
                                         withAnimation{
                                             self.selectedItem = item
                                             viewModel.position = MapCameraPosition.region(self.selectedItem.coordinates)
                                         }
                                     }))
                                 }
                                 .listStyle(.plain)
                            }
                        }.frame(height: 175).padding(.bottom,25)

                        HStack(content: {
                            Text("Next 7 days").font(.custom("Futura",size: 20)).foregroundColor(.white)
                            Spacer()
                            
                        })

                    }
                    .padding(25.0)
                })
            })  .background(Color(hex: 0xFF303A7D))
                .frame(maxWidth: .infinity)
                .cornerRadius(35)
           
            Image(selectedItem.icon).resizable().scaledToFit().frame(width: 175, alignment: .center).offset(y:-160).padding(.trailing,17.5)
        })
    }
}

/*#Preview {
   WheaterTimeWidget()
}*/

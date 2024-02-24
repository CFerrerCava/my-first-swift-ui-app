//
//  ContentView.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 16/02/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = LandMarkViewModel()
    @State private var showChatBot = false
    
    var body: some View {         
        NavigationStack{
            ZStack(alignment: .bottom,content: {
                MapView(viewModel: viewModel)
                VStack(alignment:.center, content:{
                    Spacer()
                    SlidingUpPanel(content: {
                        WheaterTimeWidget(viewModel: viewModel)
                    })
                })
               
              
            }).edgesIgnoringSafeArea(.all) .toolbar{
                Button{
                    showChatBot.toggle()
                } label: {
                    Label(
                        title: { Text("Label") },
                        icon: { Image(systemName: "person.crop.circle")
                        }
)
                }
               .tint(.white)
                
            }
            .toolbarBackground(.hidden,for: .navigationBar)
            .sheet(isPresented: $showChatBot, content: {
                  ChatBot(viewModel: viewModel)
            })
           
        }
    }
}

#Preview {
    ContentView()
}

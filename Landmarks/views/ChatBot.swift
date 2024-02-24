//
//  ChatBot.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 21/02/24.
//

import SwiftUI

struct ChatBot: View {
    @State private var text = ""
     @ObservedObject var viewModel: LandMarkViewModel
    var body: some View {
        ScrollViewReader(content: { proxy in
            VStack{
                ScrollView(content: {
                    VStack(content: {
                        ForEach(viewModel.conversation, id: \.date) { message in
                            RolRow(rowText: message.message, isChatBot: (message.isChatBot ?? false) ).id(message.date)
                        }
                    })
                    .padding(.horizontal)
                })
                HStack(content: {
                    TextField("Enter text here", text:$text)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 25))
                        .padding()
                        .foregroundStyle(.blue)
                        .gesture(TapGesture().onEnded{
                            if !viewModel.blockControls && !self.text.isEmpty { 
                                withAnimation{
                                    viewModel.sendQuestion(question: self.text, proxy: proxy)
                                    self.text = ""
                                }
                            }
                        })
                })
            }
        })
    }
}

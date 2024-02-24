//
//  RolRow.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 22/02/24.
//

import SwiftUI

struct RolRow: View {
    var rowText : String
    var isChatBot =  true
    var body: some View {
        HStack{
            if !isChatBot {
                Spacer()
                Text(rowText)
            }
            Image(isChatBot ?"chatbot": "receipt")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 50, alignment: .center)
                   .cornerRadius(20)
            if isChatBot {
                Text(rowText)
                Spacer()
            }
         
        }.padding(EdgeInsets(top: 0, leading: 15, bottom: 15, trailing: 15))
    }
}

 

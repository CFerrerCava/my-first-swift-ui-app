//
//  tempeture_row.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 17/02/24.
//

import SwiftUI

struct TempetureRow: View {
    let wheater: WheaterTime
    
    var body: some View {
        VStack(content: {
            Spacer()
            /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Container@*/VStack/*@END_MENU_TOKEN@*/(alignment: .center, content: {
                VStack(content: {
                    Spacer()
                    Image(wheater.icon).resizable().scaledToFit().frame(width: 25, alignment: .center)
                    Text("\(wheater.tempeture)°").fontWeight(.semibold).font(.custom("Futura",size: 17.5)).foregroundColor(.white)
                }).frame(alignment: .center)
            })
            .padding(15)
            .frame(height:maxTempetureHeight+(CGFloat(wheater.tempeture) ))
            .background(Color(hex:0xBF282E6C))
            .cornerRadius(15)
            Text("\(wheater.time)").font(.custom("Futura",size: 15.5)).foregroundColor(Color(hex: 0xFF666F9F))
        }).padding(.trailing,5)
      
    }
}

#Preview {
    TempetureRow(wheater: times.first!);
}

//
//  MapView.swift
//  Landmarks
//
//  Created by Christian Alexis Ferrer Cava on 16/02/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var viewModel: LandMarkViewModel
    
    var body: some View {
        Map(position: $viewModel.position )
            .environment(\.colorScheme, .dark)
    }
}

/*#Preview {
    MapView()
}*/

//
//  ContentView.swift
//  BucketList_Ios17
//
//  Created by Boubacar sidiki barry on 25.12.23.
//

import SwiftUI
import MapKit
import LocalAuthentication

struct ContentView: View {
    @State private var startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 56, longitude: -3), span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)))
    
    @State private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            
            if (viewModel.isUnlocked) {
                MapReader { proxy in
                    Map(initialPosition: startPosition){
                        ForEach(viewModel.locations){location  in
                            Annotation(location.name, coordinate: location.coordinate){
                                Image(systemName: "star.circle")
                                    .resizable()
                                    .foregroundStyle(.red)
                                    .frame(width: 44, height: 44)
                                    .background(.white)
                                    .clipShape(.circle)
                                    .onLongPressGesture {
                                        viewModel.selectedPlace = location
                                    }
                            }
                        }
                    }
                    .onTapGesture {position in
                        if let coordinate = proxy.convert(position, from: .local){
                            viewModel.addLocation(at: coordinate)
                        }
                        
                    }
                    .sheet(item: $viewModel.selectedPlace) { place in
                        EditView(location: place) {
                            viewModel.update(location: $0)
                        }
                    }
                }
            }else{
                Button("Unlock Places", action: viewModel.authenticate)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.capsule)
            }
        }
    }
    
}

#Preview {
    ContentView()
}

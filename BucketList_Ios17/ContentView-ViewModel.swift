//
//  ContentView-ViewModel.swift
//  BucketList_Ios17
//
//  Created by Boubacar sidiki barry on 29.01.24.
//

import Foundation
import  MapKit
import CoreLocation
import LocalAuthentication


extension ContentView {
    @Observable
    class ViewModel{
        private (set) var locations = [Location]()
        var selectedPlace : Location?
        
        var isUnlocked = false
        
        let savePath = URL.documentsDirectory.appending(path: "savedPlaces")
        
        init(){
            do{
                let data = try Data(contentsOf: savePath )
                locations = try JSONDecoder().decode([Location].self, from: data)
                
            }catch{
                locations = []
            }
        }
        
        func save(){
            do{
                let data = try JSONEncoder().encode(locations)
                try data.write(to: savePath, options: [.atomic , .completeFileProtection])
            }catch{
                print("Unable to save Data")
            }
        }
        
        func addLocation(at point : CLLocationCoordinate2D){
            let newLocation = Location(id: UUID(), name: "LocationName", description: "test", latitude: point.latitude, longitude: point.longitude)
            
            locations.append(newLocation)
            save()
        }
        
        func update(location :Location){
            guard let selectedPlace else{ return }
            
            if let index = locations.firstIndex(of: selectedPlace){
                locations[index] = location
                
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Please authenticate yourself to unlock your places."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in

                    if success {
                        self.isUnlocked = true
                    } else {
                        // error
                    }
                }
            } else {
                // no biometrics
            }
        }
        
    }

}
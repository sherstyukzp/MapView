//
//  MapView.swift
//  MapKav
//
//  Created by Ярослав Шерстюк on 17.03.2021.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    @EnvironmentObject var mapData: MapViewModel
    
    
    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator(center: $mapData.center)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let view = mapData.mapView
        view.showsCompass = false
        view.showsUserLocation = true
        view.delegate = context.coordinator
        
        let compassBtn = MKCompassButton(mapView: view)
                compassBtn.frame.origin = CGPoint(x: 20, y: 100) // you may use GeometryReader to replace it's position
        compassBtn.compassVisibility = .adaptive // compass will always be on map
        view.addSubview(compassBtn)

        return view
        
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        //
        print("Updating")
    
    }
    
    class Coordinator: NSObject,MKMapViewDelegate {
        @Binding var center: CLLocationCoordinate2D?
        
        init(center: Binding<CLLocationCoordinate2D?>) {
            self._center = center
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Custom Pins....
            // Excluding User Blue Circle...
            if annotation.isKind(of: MKUserLocation.self){return nil}
            else{
                let pinAnnotation = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "PIN_VIEW")
                pinAnnotation.tintColor = .red
                pinAnnotation.animatesDrop = true
                pinAnnotation.canShowCallout = true
                return pinAnnotation
            }
            
        }
        
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            
            let currentLocation = mapView.centerCoordinate
                    print("👉 Координаты \(currentLocation)")
            center = currentLocation
            //
            
            
            //

            
            }
    
    }
}

//
//  Home.swift
//  MapKav
//
//  Created by Ярослав Шерстюк on 17.03.2021.
//

import SwiftUI
import CoreLocation
import MapKit

struct Home: View {
    
    @StateObject var mapData = MapViewModel()
    // Location Manager....
    @State var locationManager = CLLocationManager()

    
    // Целик
    struct Cross: Shape {
        func path(in rect: CGRect) -> Path {
            return Path { path in
                path.move(to: CGPoint(x: rect.midX, y: 0))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                path.move(to: CGPoint(x: 0, y: rect.midY))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                path.move(to: CGPoint(x: rect.midX, y: rect.midY))
                path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: 10, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 360), clockwise: false)
            }
        }
    }
    
    var body: some View {
        
        ZStack {
            // Карта
            MapView()
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            // Целик
            Cross().stroke(Color.red)
                           .frame(width: 90, height: 90)
            
            // Всё что по верх карты
            VStack {
                VStack(spacing: 0) {
                    // Панель поиска
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search", text: $mapData.searchTxt)
                            .colorScheme(.light)
                    }
                    .padding(.vertical,10)
                    .padding(.horizontal)
                    .background(Color.white)
                    // Displaying Results...
                    if !mapData.places.isEmpty && mapData.searchTxt != "" {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(mapData.places) {place in
                                    Text(place.placemark.name ?? "")
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity,alignment: .leading)
                                        .padding(.leading)
                                        .onTapGesture{
                                            mapData.selectPlace(place: place)
                                        }
                                    Divider()
                                }
                            }
                            .padding(.top)
                        }
                        .background(Color.white)
                    }
                    
                } .padding()
                Spacer()
                // Панель кнопок
                VStack {
                    Button(action: mapData.focusLocation, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    Button(action: mapData.updateMapType, label: {
                        Image(systemName: mapData.mapType == .standard ? "network" : "map")
                            .font(.title2)
                            .padding(10)
                            .background(Color.primary)
                            .clipShape(Circle())
                    })
                    if let center = mapData.center {
                        Text ("Мои координаты: В: \(center.latitude) L: \(center.longitude)")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
            }
            
        }
        .onAppear(perform: {
            // Setting Delegate...
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        // Permission Denied Alert...
        .alert(isPresented: $mapData.permissionDenied, content: {
            Alert(title: Text("Permission Denied"), message: Text("Please Enable Permission In App Settings"), dismissButton: .default(Text("Go Setting"), action: {
                // Redireting User To Settings...
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }))
        })
        .onChange(of: mapData.searchTxt, perform: { value in
            // Searching Places...
            // You can use your own delay time to avoid Continous Search Request...
            let delay = 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchTxt {
                    // Search...
                    self.mapData.searchQuery()
                }
                
            }
            
        })
    }
    
    func regionToString(_ region: MKCoordinateRegion) -> String {
        "\(region.center.latitude), \(region.center.longitude)"
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
        
    }
}

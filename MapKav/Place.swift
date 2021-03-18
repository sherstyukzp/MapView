//
//  Place.swift
//  MapKav
//
//  Created by Ярослав Шерстюк on 17.03.2021.
//

import SwiftUI
import MapKit

struct Place: Identifiable {
    
    var id = UUID().uuidString
    var placemark: CLPlacemark
    
}

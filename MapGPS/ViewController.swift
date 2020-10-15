//
//  ViewController.swift
//  MapGPS
//
//  Created by Bill Martensson on 2020-10-15.
//

import UIKit
import MapKit
import CoreLocation

class ownPin: NSObject, MKAnnotation
{
    var title: String?
    var subtitle: String?

    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 55.611461, longitude: 12.9941182)
    
    var storeId = 0
    
}

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var theMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        theMap.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let initialLocation = CLLocation(latitude: 55.611461, longitude: 12.9941182)
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        theMap.setRegion(coordinateRegion, animated: true)
        
        
        let myPin = ownPin()
        myPin.title = "Hej"
        myPin.subtitle = "Tjena"
        myPin.storeId = 123
        theMap.addAnnotation(myPin)

        let myPin2 = ownPin()
        myPin2.title = "Andra"
        myPin2.subtitle = "Butiken"
        myPin2.storeId = 999
        myPin2.coordinate = CLLocationCoordinate2D(latitude: 55.612598, longitude: 12.9914993)
        theMap.addAnnotation(myPin2)

        
        
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        points.append(CLLocationCoordinate2D(latitude: 55.6123232, longitude: 12.9938888))
        points.append(CLLocationCoordinate2D(latitude: 55.6111715, longitude: 12.993465))
        points.append(CLLocationCoordinate2D(latitude: 55.6110505, longitude: 12.992199))
        points.append(CLLocationCoordinate2D(latitude: 55.6093415, longitude: 12.992623))
        let polyline = MKPolyline(coordinates: points, count: points.count)
        theMap.addOverlay(polyline)
        
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization")
        if CLLocationManager.locationServicesEnabled() {
            print("LOCATION ENABLED")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        let lng = userLocation.coordinate.longitude
        let lat = userLocation.coordinate.latitude

        print("\(lat) \(lng)")
        
        /*
        let regionRadius: CLLocationDistance = 50
        let coordinateRegion = MKCoordinateRegion(center: userLocation.coordinate,latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        theMap.setRegion(coordinateRegion, animated: true)
        */
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ownPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
            }

            view.pinTintColor = MKPinAnnotationView.greenPinColor()
            return view
        }
        return nil
    }
    
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print("calloutAccessoryControlTapped")
        
        if let pinnen = view.annotation as? ownPin
        {
            print("KLICK PÅ BUTIK MED ID \(pinnen.storeId)")
        }
    }
    
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }

        return MKOverlayRenderer()
    }
    
    
}


//
//  MapView.swift
//  BiWF
//
//  Created by pooja.q.gupta on 22/05/20.
//  Copyright © 2020 Digital Products. All rights reserved.
//

import UIKit
import MapKit
import RxCocoa
import RxSwift
import DPProtocols
/*
MapView to show google map information
*/
class MapView: MKMapView {
    
    var viewModel: MapViewModel!
    private let disposeBag = DisposeBag()
    
    //MARK:- init methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        delegate = self
    }
    
    func update(location: CLLocationCoordinate2D) {
        addAnnotation(for: location)
        centerToLocation(CLLocation.init(latitude: location.latitude, longitude: location.longitude))
    }
    
    private func addAnnotation(for location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        DispatchQueue.main.async {
            self.addAnnotation(annotation)
        }
    }
    
    private  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = Constants.MapView.regionRadius) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

/// MapView confirming to MKMapViewDelegate  protocol
extension MapView: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let annotationView = MKAnnotationView()
        annotationView.frame = CGRect.init(x: 0, y: 0, width: Constants.MapView.annotationViewWidthHeight, height: Constants.MapView.annotationViewWidthHeight)
        annotationView.cornerRadius = Constants.MapView.annotationViewWidthHeight/2
        annotationView.backgroundColor = UIColor.BiWFColors.blue
        
        //border
        annotationView.borderColor = UIColor.BiWFColors.white
        annotationView.borderWidth = Constants.MapView.annotationViewBorderWidth
        
        //Add shadow
        annotationView.shadowColor = UIColor.BiWFColors.dark_grey.withAlphaComponent(0.3)
        annotationView.shadowBlur = 4
        annotationView.shadowAplha = 0.15
        annotationView.shadowOffset = CGSize.init(width: 0, height: 2)
        return annotationView
    }
}

/// LoaderAndErrorView extension confirming to Bindable
/// A standard interface to all it's internal elelments to be bound to a view model
extension MapView: Bindable {
    
    /// Binding all the observers from viewmodel to get the values and events
    func bindViewModel() {
        viewModel.location.drive(onNext: { [weak self] location in
            self?.update(location: location)
        })
            .disposed(by: disposeBag)
    }
}

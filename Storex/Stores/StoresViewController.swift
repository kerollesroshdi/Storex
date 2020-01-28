//
//  StoresViewController.swift
//  Storex
//
//  Created by Kerolles Roshdi on 5/19/19.
//  Copyright © 2019 KerollesRoshdi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu
import MapKit

class StoresViewController: UIViewController {
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK:- store details view :
    @IBOutlet weak var storeDetailsView: UIView!
    @IBOutlet weak var closeStoreDetailsButton: UIButton!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeAddressLabel: UILabel!
    @IBOutlet weak var storeNumberLabel: UILabel!
    @IBOutlet weak var getDirectionButton: UIButton!
    
    
    lazy var viewModel: StoresViewModel = {
       return StoresViewModel()
    }()
    let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    var isFirstRender = true
    
    var storesDetails = [StoreDetailsViewModel]()
    var selectedStoreLocation: CLLocation?
    var selectedStore: Int? {
        didSet {
            let details = storesDetails[selectedStore!]
            storeNameLabel.text = details.name
            storeAddressLabel.text = details.address
            storeNumberLabel.text = details.number
            selectedStoreLocation = details.location
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // register nibs:
        tableView.registerCellNib(cellClass: StoreLocationCell.self)
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "StoreAnnotation")
        
        setNavigationItemTitleImage()
        initView()
        initVM()
        
        mapView.delegate = self
        setLocationManager()
    }
    
    func setNavigationItemTitleImage() {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "nav-logo")!
        self.navItem.titleView = imageView
    }
    
    func setLocationManager() {
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.startUpdatingLocation()
        }
    }
    
    private func initView() {
        
        menuButton.rx.tap
        .subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let menu = self.storyboard?.instantiateViewController(withIdentifier: "LeftSideMenu") as! UISideMenuNavigationController
            menu.setNavigationBarHidden(true, animated: false)
            SideMenuManager.default.menuPresentMode = .viewSlideInOut
            SideMenuManager.default.menuAnimationBackgroundColor = UIColor.clear
            self.present(menu, animated: true)
        })
        .disposed(by: disposeBag)
        
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexpath in
                guard let self = self else { return }
                self.selectedStore = indexpath.row
                self.storeDetailsView.isHidden = false
                UIView.animate(withDuration: 0.3) {
                    self.storeDetailsView.alpha = 1
                }
            }).disposed(by: disposeBag)
        
        closeStoreDetailsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.3, animations: {
                    self.storeDetailsView.alpha = 0
                }) { (_) in
                    self.storeDetailsView.isHidden = true
                }
                self.tableView.deselectRow(at: IndexPath(row: self.selectedStore!, section: 0), animated: true)
            }).disposed(by: disposeBag)
        
        getDirectionButton.rx.tap
            .throttle(.seconds(10), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                guard let location = self.selectedStoreLocation else { return }
                
                let regionDistance: CLLocationDistance = 1000
                let regionSpan = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
                let options = [ MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
                
                let placeMark = MKPlacemark(coordinate: location.coordinate)
                let mapItem = MKMapItem(placemark: placeMark)
                mapItem.name = self.storesDetails[self.selectedStore!].name
                mapItem.openInMaps(launchOptions: options)
                
            }).disposed(by: disposeBag)
        
    }

    private func initVM() {
        viewModel.storeLocationCellViewModels
            .throttle(.seconds(30), scheduler: MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: "StoreLocationCell")) {
                (row, cellViewModel, cell: StoreLocationCell) in
                cell.storeLocationCellViewModel = cellViewModel
        }.disposed(by: disposeBag)
        
        
        viewModel.storesLocation
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] locations in
                guard let self = self else { return }
                locations.forEach { (store) in
                    let annotation = MKPointAnnotation()
                    annotation.title = store.name
                    annotation.coordinate = store.location.coordinate
                    self.mapView.addAnnotation(annotation)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.storesDetailsViewModels
            .subscribe(onNext: { [weak self] storesDetails in
                guard let self = self else { return }
                self.storesDetails = storesDetails
            }).disposed(by: disposeBag)
        
        
        viewModel.getStoreInfo()
    }
}

extension StoresViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "StoreAnnotation"
        
        var annotationView = MKMarkerAnnotationView()
        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        annotationView.markerTintColor = #colorLiteral(red: 0.9768038392, green: 0.7147801518, blue: 0.3058317304, alpha: 1)
        annotationView.glyphImage = #imageLiteral(resourceName: "icon-shoppingcart")
        
        return annotationView
        
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        if fullyRendered && isFirstRender {
//            mapView.showAnnotations(mapView.annotations, animated: true)
            mapView.fitAll()
            isFirstRender = false
        }
    }
}

extension StoresViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = manager.location else { return }
        viewModel.getStoresLocation(fromLocation: userLocation)
    }
}

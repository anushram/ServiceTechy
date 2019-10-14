//
//  JobMapViewVC.swift
//  Technician
//
//  Created by K Saravana Kumar on 05/09/19.
//  Copyright © 2019 K Saravana Kumar. All rights reserved.
//

import UIKit
import GoogleMaps
import AlamofireObjectMapper
import Alamofire

class JobMapViewVC: BaseVC,GMSMapViewDelegate,CLLocationManagerDelegate {
    
    var mapView:GMSMapView!
    
    var mapArray: [OpenTicketsList]!
    
    
    @IBOutlet weak var baseMapView: UIView!
    var locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        //setNavigationBarItem()
        self.addNavigationBarTitleView(title: "Job Map View", image: UIImage())
        let camera = GMSCameraPosition.camera(withLatitude: 19.0759837, longitude: 72.8776559, zoom: 0.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 0, y: 0, width: self.baseMapView.frame.size.width, height: self.baseMapView.frame.size.height), camera: camera)
        mapView.settings.indoorPicker = true
        mapView.mapType = .normal
        mapView.isMyLocationEnabled = true
        mapView.animate(toZoom: 15)
//        let path = GMSMutablePath()
//        path.add(CLLocationCoordinate2D(latitude: Double(mapArray[0].latitude)!, longitude: Double(mapArray[0].longitude)!))
//        path.add(mapView.myLocation?.coordinate ?? CLLocationCoordinate2D(latitude: Double(mapArray[0].latitude)!, longitude: Double(mapArray[0].longitude)!))
//
//        let rectangle = GMSPolyline(path: path)
//        rectangle.strokeWidth = 2.0
//        rectangle.map = mapView
        self.mapView.delegate = self
        if mapArray.count != 0 {
        for (index,data) in mapArray.enumerated() {
            let position = CLLocationCoordinate2D(latitude: Double(data.latitude)!, longitude: Double(data.longitude)!)
            let mapIcon = MapIconView.instanceFromNib()
            mapIcon.frame = CGRect(x: 0, y: 0, width:
                109, height: 75)
            mapIcon.jobName.text = data.jobid
            let london = GMSMarker(position: position)
            //mapIcon.title = data.jobid
            london.iconView = mapIcon
            london.iconView?.tag = index
            london.map = self.mapView
        }
        }
        self.locationManager.delegate = self
        self.locationManager.startUpdatingLocation()
        self.baseMapView .addSubview(mapView)
        //self.addDirections()
        // Do any additional setup after loading the view.
    }
    
    
    // MARK: MAPVIEW Delegates
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
   
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        let zoom = mapView.camera.zoom
        print("map zoom is ",String(zoom))
        
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location = locations.last
        
        let camera = GMSCameraPosition.camera(withLatitude: (location?.coordinate.latitude)!, longitude: (location?.coordinate.longitude)!, zoom: 17.0)
        
        let path = GMSMutablePath()
        path.add(CLLocationCoordinate2D(latitude: Double(mapArray[0].latitude)!, longitude: Double(mapArray[0].longitude)!))
        path.add(location!.coordinate)
        
        let rectangle = GMSPolyline(path: path)
        rectangle.strokeWidth = 2.0
        rectangle.map = mapView
        
        self.mapView?.animate(to: camera)
        
        //Finally stop updating location otherwise it will come again and again in this delegate
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func addDirections() {
        let origin = "\(28.524555),\(77.275111)"
        let destination = "\(28.643091),\(77.218280)"
        
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBL-ANZwdOKOmoUq6notEI-_WLL1D7QU9g"
        
        //Rrequesting Alamofire and SwiftyJSON
        Alamofire.request(url).responseJSON { response in
            print(response.request as Any)  // original URL request
            print(response.response as Any) // HTTP URL response
            print(response.data as Any)     // server data
            print(response.result)   // result of response serialization
            
            do {
                let json = try JSONSerialization.jsonObject(with: response.data!, options: [])
                
                let dataString = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)
                
                print("dataString=",dataString)
                
//                let routes = json["routes"].arrayValue
//
//                for route in routes
//                {
//                    let routeOverviewPolyline = route["overview_polyline"].dictionary
//                    let points = routeOverviewPolyline?["points"]?.stringValue
//                    let path = GMSPath.init(fromEncodedPath: points!)
//                    let polyline = GMSPolyline.init(path: path)
//                    polyline.strokeColor = UIColor.blue
//                    polyline.strokeWidth = 2
//                    polyline.map = self.mapView
//                }
            }catch {
                
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

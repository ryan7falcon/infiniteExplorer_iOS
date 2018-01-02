//
//  MapViewController.swift
//  InfiniteExplorer
//
//  Created by Ryan Galimova on 2017-12-27.
//  Copyright © 2017 Ryan Galimova. All rights reserved.
//

import UIKit
import MapKit
import WatchConnectivity

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, WCSessionDelegate  {
    // Send the watch data when session is activated
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        let worldData = NSKeyedArchiver.archivedData(withRootObject: game.world)
        sendWatchMessage(msgData: worldData)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    // reply with data when request is received
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        var replyValues = Dictionary<String, AnyObject>()
        if(message["getProgData"] != nil) {
            NSKeyedArchiver.setClassName("World", for: World.self)
            let worldData = NSKeyedArchiver.archivedData(withRootObject: game.world)
            replyValues["progData"] = worldData as AnyObject?
            replyHandler(replyValues)
        }
    }

    // map view
    @IBOutlet var myMapView : MKMapView!
    // world name label
    @IBOutlet var lblName : UILabel!
    // cat image - in or out of the box
    @IBOutlet var img : UIImageView!
    // world description
    @IBOutlet var lblDesc: UILabel!
    // the game object
    var game: Game!
    
    // set everything up when the view is loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        enableLocationServices()
        if (WCSession.isSupported()){
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        game = appDelegate.game
    
        // Do any additional setup after loading the view.
    }
    
    var lastMessage : CFAbsoluteTime = 0
    
    // send watch data
    func sendWatchMessage(msgData : Data){
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        if currentTime - lastMessage < 0.5 {
            return
        }
        
        if (WCSession.default.isReachable){
            let message = ["progData" : msgData]
            WCSession.default.sendMessage(message, replyHandler: nil, errorHandler: nil)
        }
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    
    let locationManager = CLLocationManager()
    
    let initialLocation = CLLocation(latitude: 43.655787, longitude: -79.739534)
    
    // world radius
    let boxRadius = 10.0
    var boxPoints = [] as Array<CLLocationCoordinate2D>

    let regionRadius : CLLocationDistance = 20000
    func centerMapOnLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0, regionRadius * 2.0)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    // enable location services, request authorization to use them from the user
    func enableLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                locationManager.requestAlwaysAuthorization()
                break
            
            case .restricted, .denied:
                // Disable location features
                locationManager.requestAlwaysAuthorization()
                break
            
            case .authorizedWhenInUse:
                // Enable basic location features
                locationManager.requestAlwaysAuthorization()
                break
            
            case .authorizedAlways:
                // Enable any of your app's location features
                setup()
                break
            }
    }
    
    // request authorization to use them from the user
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted, .denied:
                // Disable your app's location features
                locationManager.requestAlwaysAuthorization()
                break
            
            case .authorizedWhenInUse:
                // Enable only your app's when-in-use features.
                 locationManager.requestAlwaysAuthorization()
                break
            
            case .authorizedAlways:
                // Enable any of your app's location services.
                setup()
                break
            
            case .notDetermined:
                break
        }
    }
    
    // set up location services parameters
    func startReceivingLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedWhenInUse && authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        // Do not start services that aren't available.
        if !CLLocationManager.locationServicesEnabled() {
            // Location services is not available.
            return
        }
        // Configure and start the service.
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100.0  // In meters.
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    // draw the world box, center map and start tracking location
    func setup() {
        self.drawBox()
        self.centerMapOnLocation(location: initialLocation)
        self.startReceivingLocationChanges()
    }
    
    // draw the world box. Meow.
    func drawBox(){
        let startLat = 43.600787
        let startLon = -79.735534
        let dLat = getDLatFromMeters(meters: self.boxRadius)
        let dLon = getDLongFromMeters(meters: self.boxRadius, latitude: startLat)
        
        // show the 20km box
        let point1 = CLLocationCoordinate2DMake(startLat - dLat, startLon - dLon)
        let point2 = CLLocationCoordinate2DMake(startLat - dLat, startLon + dLon)
        let point3 = CLLocationCoordinate2DMake(startLat + dLat, startLon + dLon)
        let point4 = CLLocationCoordinate2DMake(startLat + dLat, startLon - dLon)
        let point5 = point1
        
        self.boxPoints = [point1, point2, point3, point4, point5] as Array<CLLocationCoordinate2D>
        
        let box = MKGeodesicPolyline(coordinates: boxPoints, count: 5
        )
        self.myMapView.add(box)
    }
    
    // converting latitude to meters
    func getDLatFromMeters (meters: Double) -> Double {
        return meters / 111.32
    }
    
    // converting longitude to meters
    func getDLongFromMeters (meters: Double, latitude: Double)  -> Double {
        return meters / 111.32 / cos(latitude * Double.pi/180)
    }
    
    // When new location is received, show it
    func locationManager(_ manager: CLLocationManager,  didUpdateLocations locations: [CLLocation]) {
        let lastLocation = locations.last!
//        print(lastLocation.coordinate.longitude, lastLocation.coordinate.latitude)
        print(locations.count)
        self.dropAPin(location: lastLocation)
        self.showResult(location: lastLocation)
    }
    
    // In case there was an error in location services
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopUpdatingLocation()
            return
        }
        print("error in location service")
        // Notify the user of any errors.
    }
    
    // assigns the right world to the game and shows in in labels and images
    func showResult(location: CLLocation) {
       
        // display if in the box
        if (isInBox(location: location, box: boxPoints)) {
            game.world = World(id: 1)
        } else {
            game.world = World(id: 2)
        }
        self.lblName.text = "You are in " + game.world.name
        self.lblDesc.text = game.world.desc
        self.img.image = UIImage(named: game.world.picUrl)
    }
    
    // Checks if you are in the box
    func isInBox(location: CLLocation, box: Array<CLLocationCoordinate2D>) -> Bool {
        // location of the point of interest
        let coordinate = MKMapPointForCoordinate(location.coordinate)
        let x = coordinate.x
        let y = coordinate.y
        
        // oppposite points of the box
        let p1 = MKMapPointForCoordinate(box[0])
        let p2 = MKMapPointForCoordinate(box[2])
        
        let minX = fmin(p2.x, p1.x)
        let maxX = fmax(p2.x, p1.x)
        let minY = fmin(p2.y, p1.y)
        let maxY = fmax(p2.y, p1.y)
        
        // if in bounds
        if (x < maxX && x > minX && y < maxY && y > minY) {
            return true
        }
        return false
    }
    
    // Drops a pin on the map
    func dropAPin(location: CLLocation) {
        // clear last pin
        self.myMapView.removeAnnotations(self.myMapView.annotations)
        
        // put a new pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location.coordinate
        dropPin.title = "You are here"
        self.centerMapOnLocation(location: location)
        self.myMapView.addAnnotation(dropPin)
        self.myMapView.selectAnnotation(dropPin, animated: true)
        
    }
    
    // render the map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        render.strokeColor = UIColor.blue
        render.lineWidth = 3.0
        return render
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

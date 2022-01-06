import Foundation
import FirebaseStorage

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class AddHouseLocationViewModel: NSObject, ObservableObject {

    @Published var isLoadingDisabledLocations = true
    @Published var permissionStatus: CLAuthorizationStatus? = CLLocationManager.authorizationStatus()
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var disabledLocationHashes: [String]? = []

    private let locationManager = CLLocationManager()
    
    override init() {
      super.init()
      self.locationManager.delegate = self
        loadUser()
    }

    func loadUser() {

        let document = Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid)
        
        document.addSnapshotListener { documentSnapshot, error in
            if(documentSnapshot!.exists) {
            if let user = try? documentSnapshot!.data(as: SPUser.self) {
                self.disabledLocationHashes = user.disabledLocationHashes

                }else {
                    //todo handle error
                }
                
            }else {
                //todo show error
            }
            }
        
    }
    
    func requestLocationPermission() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestLocation() {
        self.locationManager.requestLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
                if #available(iOS 14.0, *) {
            permissionStatus = manager.authorizationStatus
        } else {
            permissionStatus = CLLocationManager.authorizationStatus()
        }
    }
    
    func saveLocationToUser(location: CLLocation) {
        
    }

    
    func saveHomeLocation(location: CLLocationCoordinate2D, completionHandler: @escaping (Result<String, Error>) -> Void) {
        let geoHash = location.geohash(length: 7)
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).updateData([
    "disabledLocationHashes": FieldValue.arrayUnion([geoHash])]) { err in
                if let err = err {
                    print("Error updating house: \(err)") //todo
                } else {

                    //todo finish
                }
            }
    }
}

extension AddHouseLocationViewModel: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    userLatitude = location.coordinate.latitude
    userLongitude = location.coordinate.longitude
    saveLocationToUser(location: location)
    userLocation = CLLocationCoordinate2D(
        latitude: userLatitude,
        longitude: userLongitude)
  }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

}

import Foundation
import FirebaseStorage

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class AddHouseLocationViewModel: NSObject, ObservableObject {

    @Published var isLoadingLocation = false
    @Published var permissionStatus: CLAuthorizationStatus? = CLLocationManager.authorizationStatus()
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var userLocation: CLLocationCoordinate2D?

    private let locationManager = CLLocationManager()
    
    override init() {
      super.init()
      self.locationManager.delegate = self
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
        print(geoHash)
        
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "homeGeoHash": geoHash
        ], merge: true) { err in
                if let err = err {
                    print("Error updating house: \(err)") //todo
                } else {
                    completionHandler(.success("Updated House"))
                    //todo finish
                }
            }
        
        //todo save to firebase
        
//        NewFirestoreUtil().getUserReference().set(getData(), SetOptions.merge()).addOnSuccessListener {
//            findNavController().popBackStack()
//        }.addOnFailureListener {
//            hideLoading()
//            Toast.makeText(requireContext(), "There was an issue saving your home location.", Toast.LENGTH_SHORT).show()
//        }

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

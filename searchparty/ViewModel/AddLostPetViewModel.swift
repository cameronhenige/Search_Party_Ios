//
//  AddLostPetViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 5/6/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseStorage

import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class AddLostPetViewModel: NSObject, ObservableObject {


    @Published var isLoadingLocation = false
    @Published var errorAddingLostPet = false
    @Published var addNameError = false
    @Published var errorAddingImage = false
    @Published var permissionStatus: CLAuthorizationStatus? = CLLocationManager.authorizationStatus()
    @Published var userLatitude: Double = 0
    @Published var userLongitude: Double = 0
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var isAddingLostPet = false

    private var completionHandler: ((Result<String, Error>) -> Void)?
    private var db = Firestore.firestore()
    private let locationManager = CLLocationManager()
    static let LOST_PET_IMAGE_COMPRESSION : Float = 0.4
    var imagesAdded = [] as [String]
    
    override init() {
      super.init()
      self.locationManager.delegate = self
    }
    
    func addLostPet(name: String, sex: String, age: Int?, breed: String, type: String, description: String, lostDateTime: Date, lostLocation: String, lostLocationDescription: String, ownerName: String, ownerEmail: String, ownerPhoneNumber: String, ownerPreferredContactMethod: String, ownerOtherContactMethod: String, owners: [String], petImages: [SelectedImage], isEditing: Bool, lostPetId: String?, completionHandler: @escaping (Result<String, Error>) -> Void) {
        self.completionHandler = completionHandler
        if(!name.isEmpty){

    
        isAddingLostPet = true
            let itemData : [String: Any] = [
                LostPet.NAME : name,
                LostPet.SEX: sex,
                LostPet.AGE: age,
                LostPet.BREED: breed,
                LostPet.TYPE: type,
                LostPet.DESCRIPTION: description,
                LostPet.LOST_DATE_TIME: lostDateTime,
                LostPet.LOST_LOCATION: lostLocation,
                LostPet.LOST_LOCATION_DESCRIPTION: lostLocationDescription,
                LostPet.OWNER_NAME: ownerName,
                LostPet.OWNER_EMAIL: ownerEmail,
                LostPet.OWNER_PHONE_NUMBER: ownerPhoneNumber,
                LostPet.OWNER_PREFERRED_CONTACT_METHOD: ownerPreferredContactMethod,
                LostPet.OWNER_OTHER_CONTACT_METHOD: ownerOtherContactMethod,
                LostPet.OWNERS: owners

            ]
        
            if(isEditing){
                
                Firestore.firestore().collection("Lost").document(lostPetId!).updateData(itemData) { err in
                    if  err != nil {
                        self.errorAddingLostPet = true
                    } else {
                        
                        //todo remvoe duplicatsion
//                        if(petImages.isEmpty) {
//                            self.completionHandler!(.success("Edited Lost Pet"))
//                        }else {
                            self.addImages(lostPetDocumentId: lostPetId!, petImages: petImages)
                        //}
                    }
                }
            }else {
                
            
            var ref: DocumentReference? = nil
            ref = Firestore.firestore().collection("Lost").addDocument(data: itemData){ err in
                if  err != nil {
                    self.errorAddingLostPet = true
                } else {
//                    if(petImages.isEmpty) {
//                        self.completionHandler!(.success("Added Lost Pet"))
//                    }else {
                        self.addImages(lostPetDocumentId: ref!.documentID, petImages: petImages)
                    //}
                }
            

            }
            }
        }else {
            self.addNameError = true
        }
    }
    
    func addImages(lostPetDocumentId: String, petImages: [SelectedImage]) {
        
        let group = DispatchGroup()
        
        for image in petImages {
            
            if(!image.isExisting){
            group.enter()
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
    
            let imageName = "\(FirebaseUtil().getCurrentTimeInMillis()).jpg"
    
    let addItemImageRef = FirebaseUtil().getAddPetImageReference(imageName: imageName, lostPetId: lostPetDocumentId)
    
            addItemImageRef.putData(image.image!.jpegData(compressionQuality: CGFloat(AddLostPetViewModel.LOST_PET_IMAGE_COMPRESSION))!, metadata: metaData) { (metadata, error) in
                if error == nil{
                    self.imagesAdded.append(imageName)
                }else{
                    self.errorAddingImage = true
                }
        group.leave()

            }
            }else {
                self.imagesAdded.append(image.name!)

            }
        }
        
        group.notify(queue: .main) {
            self.updateLostPetImages(lostPetDocumentId: lostPetDocumentId)
        }
    }
    
    func updateLostPetImages(lostPetDocumentId: String){
        
        Firestore.firestore().collection("Lost").document(lostPetDocumentId).updateData([LostPet.GENERAL_IMAGES: imagesAdded]) { err in
            if  err != nil {
                self.errorAddingLostPet = true
            }
            self.isAddingLostPet = false

            self.completionHandler!(.success("Added Lost Pet"))


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
}

extension AddLostPetViewModel: CLLocationManagerDelegate {
  
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

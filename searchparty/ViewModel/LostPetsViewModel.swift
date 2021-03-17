//
//  LostPetsViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 3/13/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import GeoFire
import FlexibleGeohash

class LostPetsViewModel: ObservableObject {

@Published var lostPets = [LostPet]()
@Published var isLoadingLostPets = false

    private var db = Firestore.firestore()
    
    func fetchLostPets() {
        
        let userDocument = db.collection("Users").document(Auth.auth().currentUser!.uid)
        isLoadingLostPets = true
        userDocument.getDocument { (DocumentSnapshot, Error) in

            if(Error == nil){
                let user = try? DocumentSnapshot!.data(as: SPUser.self)
                if(user!.filterLocation != nil) {
                    self.queryLostPets(filterLocation: user!.filterLocation!, radiusInM: user!.getRadiusFromUser())
                }else{
                    //todo get location
                }
            }else{
                self.isLoadingLostPets = false

                //todo
            }
        }
        

    }
    
    func queryLostPets(filterLocation: GeoPoint, radiusInM: Double) {
  

        let center = CLLocationCoordinate2D(latitude: filterLocation.latitude, longitude: filterLocation.longitude)
        print(center)
        
        let queryBounds = GFUtils.queryBounds(forLocation: center,
                                              withRadius: radiusInM)
        print(queryBounds)
        let queries = queryBounds.compactMap { (any) -> Query? in
            guard let bound = any as? GFGeoQueryBounds else { return nil }
            
            return db.collection("Lost")
                .order(by: "lostLocation")
                .start(at: [bound.startValue])
                .end(at: [bound.endValue])
        }
        
        let dispatchGroup = DispatchGroup()

        var tempLostPets = [LostPet]()
        
        var matchingDocs = [QueryDocumentSnapshot]()
        // Collect all the query results together into a single list
        func getDocumentsCompletion(snapshot: QuerySnapshot?, error: Error?) -> () {


            guard let documents = snapshot?.documents else {
                print("Unable to fetch snapshot data. \(String(describing: error))")
                return
            }
            print(documents)
            for document in documents {
                
                let lostPet = try? document.data(as: LostPet.self)
                let lostPetHash = lostPet?.lostLocation
                
                let lostPetCoord = Geohash(hash: lostPetHash!)
                let lostPetLocation = lostPetCoord.region().center
                let userLocation = CLLocation(latitude: filterLocation.latitude, longitude: filterLocation.longitude)
            
                let centerPoint = CLLocation(latitude: lostPetLocation.latitude, longitude: lostPetLocation.longitude)
                // We have to filter out a few false positives due to GeoHash accuracy, but
                // most will match
                let distance = GFUtils.distance(from: centerPoint, to: userLocation)
                if distance <= radiusInM {
                    tempLostPets.append(lostPet!)
                }
            }
            print(matchingDocs)
            print("exiting query")

            dispatchGroup.leave()
        }
        
        

        // After all callbacks have executed, matchingDocs contains the result. Note that this
        // sample does not demonstrate how to wait on all callbacks to complete.
        print("number of queries \(queries.count)")
        for query in queries {
            print("entering query")

            dispatchGroup.enter()
            query.getDocuments(completion: getDocumentsCompletion)
        }
        
        dispatchGroup.notify(queue: .main, execute: {
            print("completed")
            self.lostPets = tempLostPets
            //completedFetch(roomArray, nil)
        })
        
//
//
//        let bounds: List<GeoQueryBounds> = GFUtils.getGeoHashQueryBounds(center, radiusInM)
//        let tasks: MutableList<Task<QuerySnapshot>> = getAllTasksForBounds(bounds, NewFirestoreUtil().getLostPetsCollectionReference(), "lostLocation")
//
//        Tasks.whenAllComplete(tasks)
//                .addOnCompleteListener {
//                    ViewModelProviders.of(requireActivity()).get(LostPetsViewModel::class.java).lostPets.postValue(getMatchingLostPetsFromTasks(center, radiusInM, tasks))
//                    showLoadingFinished()
//                }
    }
    
    func getLostPets(){
        db.collection("Lost").addSnapshotListener { (querySnapshot, error) in
            self.isLoadingLostPets = false

            guard (querySnapshot?.documents) != nil else {
                print("No documents")
                return
            }
            self.lostPets = querySnapshot!.documents.compactMap { (document) -> LostPet? in
                return try? document.data(as: LostPet.self)
            }
        }
    }
    
    
    
}

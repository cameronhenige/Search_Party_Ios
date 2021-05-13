//
//  AddLostPet.swift
//  searchparty
//
//  Created by Hannah Krolewski on 4/24/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import SwiftUI
import Combine
import PhotosUI
import iPhoneNumberField
import FirebaseAuth

struct AddLostPet: View {

    @ObservedObject private var addLostPetViewModel = AddLostPetViewModel()
    @EnvironmentObject var modelData: ModelData
    
    @State var currentLocation: CLLocationCoordinate2D?
    @State private var lostDate = Date()

    @State private var showingActionSheet = false
    @State private var shouldPresentImagePicker = false

    @State private var backgroundColor = Color.white
    
    var items: [GridItem] {
      Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }

    @State var name = ""
    @State var phoneNumber = ""
    @State var email = ""
    @State var otherContactMethod = ""

    
    @State var petName = ""
    @State var petAge = ""
    @State var petBreed = ""
    @State private var isShowPhotoLibrary = false
    @State private var isShowCamera = false
    @State private var isShowGallery = false

    @State private var images : [UIImage] = []
    @State var picker = false
    @State private var petDescription: String = ""

    @State private var petType = 0
    var petTypes = ["Dog", "Cat", "Bird", "Other"]
    
    @State private var petSex = 0
    var petSexes = ["Male", "Female"]
    
    @State private var preferredContactMethod = 0
    var preferredContactMethods = ["Phone Number", "Email", "Other"]
    
    @State var lostLocationDescription = ""


    var AddLostPetSections: some View {
        Form {
            
        Section(header: Text("Let's get some information about your lost pet.")) {
            TextField("Pet Name", text: $petName)

            Picker(selection: $petType, label: Text("Pet Type")) {
                ForEach(0 ..< petTypes.count) {
                    Text(self.petTypes[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())

            Picker(selection: $petSex, label: Text("Sex")) {
                ForEach(0 ..< petSexes.count) {
                    Text(self.petSexes[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())

            TextField("Approximate Age", text: $petAge)
                .keyboardType(.numberPad)
                .onReceive(Just(petAge)) { newValue in
                    let filtered = newValue.filter { "0123456789".contains($0) }
                    if filtered != newValue {
                        self.petAge = filtered
                    }
            }
            
            

            TextField("Breed", text: $petBreed)
            Text("Provide as many angles of your pet as possible.")
                LazyVGrid(columns: items, spacing: 10) {
                        ForEach(0..<images.count, id: \.self) { i in

                        ZStack {

                        Image(uiImage: images[i]).resizable().frame(height: 150).cornerRadius(20)

                                Image(systemName: "trash")
                                    .font(.largeTitle)
                                    .foregroundColor(.white).frame(width: 50, height: 50, alignment: .topTrailing).onTapGesture {
                                        images.remove(at: i)
                                    }
                        }
                    }


                    ZStack {


                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                        .fill(Color.gray)
                                        .frame(height: 150)

                        Image(systemName: "camera")
                            .font(.largeTitle)
                            .foregroundColor(.white).frame(width: 50, height: 50, alignment: .topTrailing).onTapGesture {
                                self.showingActionSheet = true
                            }
                    }


                }

        }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)

    Section(header: Text("Add a description of what you think people should know about PET.")) {
        TextEditor(text: $petDescription)
        Text("* Be sure to include things like unique markings, temperament, and health conditions.").font(.caption)

    }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)

    Section(header: Text("When and where was PET lost?")) {
        DatePicker(
            "Lost Date",
            selection: $lostDate,
            displayedComponents: [.date]
        )

        Text("Lost Location")

        if(addLostPetViewModel.userLocation != nil) { //todo set initial location first time.
            MapView(coordinate: self.$currentLocation, initialLocation: addLostPetViewModel.userLocation!).frame(height: 300).overlay(Image("dog").resizable().frame(width: 45.0, height: 45.0))
        }
        
        TextField("Location Description", text: $lostLocationDescription)

        
        

    }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)

            Section(header: Text("Let's get your contact information."), footer: Button(action: {
                                
                addLostPetViewModel.addLostPet(name: petName, sex: petSexes[petSex], age: Int(petAge), breed: petBreed, type: petTypes[petType], description: petDescription, lostDateTime: lostDate, lostLocation: (currentLocation?.geohash(length: 7))!, lostLocationDescription: lostLocationDescription, ownerName: name, ownerEmail: email, ownerPhoneNumber: phoneNumber, ownerPreferredContactMethod: preferredContactMethods[preferredContactMethod], ownerOtherContactMethod: otherContactMethod, owners: [Auth.auth().currentUser!.uid])
                
            }) {
                Text("Add Lost Pet")
            }.buttonStyle(PrimaryButtonStyle()).padding()) {
        TextField("Name", text: $name).textContentType(.name)
        iPhoneNumberField("Phone Number", text: $phoneNumber)
        TextField("Email", text: $email).textContentType(.emailAddress)

        TextField("Other Contact Method", text: $otherContactMethod)

        Text("Preferred Contact Method")

        Picker(selection: $preferredContactMethod, label: Text("Preferred Contact Method")) {
            ForEach(0 ..< preferredContactMethods.count) {
                Text(self.preferredContactMethods[$0])
            }
        }.pickerStyle(SegmentedPickerStyle())
            

    }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)
            
            
        }.alert(isPresented: $addLostPetViewModel.errorAddingLostPet) {
            Alert(title: Text("Error adding pet"), message: Text("There was an error adding your pet."), dismissButton: .default(Text("Ok")))
        }.alert(isPresented: $addLostPetViewModel.addNameError) {
            Alert(title: Text("Add a name"), message: Text("Add a name for your pet."), dismissButton: .default(Text("Ok")))
        }
        
    }
    

    
    var body: some View {
        
        VStack {

            AddLostPetSections

        }.onAppear() {
            self.addLostPetViewModel.requestLocation()
        }.actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Choose Photo Location"), message: Text("Select photo location"), buttons: [
                .default(Text("Gallery")) {
                    self.isShowGallery = true },
                .default(Text("Camera")) {
                    self.isShowCamera = true },
                .cancel()
            ])
        }.navigationTitle("Add Lost Pet").navigationBarColor(Constant.color.tintColor.uiColor())
        .sheet(isPresented: $isShowGallery) {
            MyImagePicker(images: $images, isShowGallery: self.$isShowGallery)
        }.sheet(isPresented: $isShowCamera) {
            SUImagePickerView(sourceType: .camera, images: self.$images, isShowCamera: self.$isShowCamera)
            
        }
        


        }
    
}

struct SUImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var images: [UIImage]
    @Binding var isShowCamera: Bool
    
    func makeCoordinator() -> ImagePickerViewCoordinator {
        return ImagePickerViewCoordinator(parent1: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = sourceType
        pickerController.delegate = context.coordinator
        return pickerController
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // Nothing to update here
    }
    
    class ImagePickerViewCoordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        var parent: SUImagePickerView

        
        init(parent1: SUImagePickerView) {
            parent = parent1
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                self.parent.images.append(image as! UIImage)
            }
            self.parent.isShowCamera = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.isShowCamera = false

        }
        
    }

}



struct MyImagePicker : UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var isShowGallery: Bool
    
    func makeCoordinator() -> Coordinator {
        return MyImagePicker.Coordinator(parent1: self)
    }
    
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate{
        var parent: MyImagePicker
        
        init(parent1: MyImagePicker) {
            parent = parent1
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.isShowGallery.toggle()
            for img in results{
                
            if img.itemProvider.canLoadObject(ofClass: UIImage.self){
                    
                img.itemProvider.loadObject(ofClass: UIImage.self) { (image, err) in
                
                    guard let image1 = image else {
                        print(err)
                        return
                    }
                    
                    self.parent.images.append(image as! UIImage)
                    
                }
            } else{
                print("cannot be loaded")
                
            }
            }
            
        }
    }
    
}

struct AddLostPet_Previews: PreviewProvider {
    static var previews: some View {
        AddLostPet()
    }
}

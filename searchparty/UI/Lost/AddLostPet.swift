

import SwiftUI
import Combine
import PhotosUI
import iPhoneNumberField
import FirebaseAuth
import MapKit

struct AddLostPet: View {
    
    @EnvironmentObject var lostViewRouter: SearchPartyAppState
    @ObservedObject var addLostPetViewModel: AddLostPetViewModel
    @State var map = MKMapView()
    @State var currentLocation: CLLocationCoordinate2D?
    @State private var showingPhotoActionSheet = false
    @State var title = ""
    @State var submitButton = ""
    @State var isShowCamera = false
    @State var isShowGallery = false
    var petTypes = ["Dog", "Cat", "Bird", "Other"]
    var petSexes = ["Male", "Female"]
    var preferredContactMethods = ["Phone Number", "Email", "Other"]
    var imageColumns: [GridItem] {
        Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    
    var AddLostPetSections: some View {
        Form {
            
            Section(header: Text("Let's get some information about your lost pet.")) {
                TextField("Pet Name", text: $addLostPetViewModel.lostPetForm.petName)
                
                Picker(selection: $addLostPetViewModel.lostPetForm.petType, label: Text("Pet Type")) {
                    ForEach(0 ..< petTypes.count) {
                        Text(self.petTypes[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Picker(selection: $addLostPetViewModel.lostPetForm.petSex, label: Text("Sex")) {
                    ForEach(0 ..< petSexes.count) {
                        Text(self.petSexes[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                TextField("Approximate Age", text: $addLostPetViewModel.lostPetForm.petAge)
                    .keyboardType(.numberPad)
                    .onReceive(Just(addLostPetViewModel.lostPetForm.petAge)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.addLostPetViewModel.lostPetForm.petAge = filtered
                        }
                    }
                
                TextField("Breed", text: $addLostPetViewModel.lostPetForm.petBreed)
                
                VStack(alignment: .leading) {
                    Text("Provide as many angles of your pet as possible.")
                    LazyVGrid(columns: imageColumns, spacing: 10) {
                        
                        ForEach(0..<addLostPetViewModel.lostPetForm.images.count, id: \.self) { i in
                            
                            ZStack {
                                
                                if(addLostPetViewModel.lostPetForm.images[i].isExisting){
                                    ExistingImage(url: addLostPetViewModel.lostPetForm.images[i].name!, lostPetId: lostViewRouter.selectedLostPet?.id)
                                    
                                } else {
                                    Image(uiImage: addLostPetViewModel.lostPetForm.images[i].image!).resizable().frame(height: 150).cornerRadius(20)
                                }
                                
                                Image(systemName: "trash")
                                    .font(.largeTitle)
                                    .foregroundColor(.white).frame(width: 50, height: 50, alignment: .topTrailing).onTapGesture {
                                        addLostPetViewModel.lostPetForm.images.remove(at: i)
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
                                    self.showingPhotoActionSheet = true
                                }
                        }.actionSheet(isPresented: $showingPhotoActionSheet) {
                            ActionSheet(title: Text("Choose Photo Location"), message: Text("Select photo location"), buttons: [
                                .default(Text("Gallery")) {
                                    self.isShowGallery = true },
                                .default(Text("Camera")) {
                                    self.isShowCamera = true },
                                .cancel()
                            ])
                        }
                        
                        
                    }
                }
                
            }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)
            
            Section(header: Text("Add a description of what you think people should know about your pet. Be sure to include things like unique markings, temperament, and health conditions.")) {
                TextArea("Description", text: $addLostPetViewModel.lostPetForm.petDescription)
            }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)
            
            
            Section(header: Text("When and where was your pet lost?")) {
                DatePicker(
                    "Lost Date",
                    selection: $addLostPetViewModel.lostPetForm.lostDate,
                    displayedComponents: [.date]
                )
                
                VStack(alignment: .leading){
                    Text("Lost Location").padding(.vertical)
                    Text("To obscure your exact location, only the bounding box is saved.").font(.caption).fixedSize(horizontal: false, vertical: true)
                    
                    if(addLostPetViewModel.userLocation != nil) {
                        
                        AddLostPetMapView(map: self.$map, name: self.$addLostPetViewModel.lostPetForm.name, coordinate: self.$currentLocation, initialLocation: addLostPetViewModel.userLocation!).frame(height: 300).overlay(Image("dog").resizable().frame(width: 45.0, height: 45.0))
                        
                    }
                    
                    TextField("Location Description", text: $addLostPetViewModel.lostPetForm.lostLocationDescription).padding(.vertical)
                    
                }
                
            }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)
            
            Section(header: Text("Let's get your contact information."), footer: Button(action: {
                
                addLostPetViewModel.addLostPet(lostPetId: lostViewRouter.selectedLostPet?.id, owners: [Auth.auth().currentUser!.uid], lostLocation: (currentLocation?.geohash(length: 7))!) { result in
                    lostViewRouter.isOnAddingLostPet = false
                    lostViewRouter.isOnEditingLostPet = false
                }

            }) {
                Text(submitButton)
            }.buttonStyle(PrimaryButtonStyle()).padding()) {
                TextField("Name", text: $addLostPetViewModel.lostPetForm.name).textContentType(.name)
                iPhoneNumberField("Phone Number", text: $addLostPetViewModel.lostPetForm.phoneNumber)
                TextField("Email", text: $addLostPetViewModel.lostPetForm.email).textContentType(.emailAddress)
                
                VStack(alignment: .leading) {
                    
                    Text("Preferred Contact Method").padding(.vertical)
                    
                    Picker(selection: $addLostPetViewModel.lostPetForm.preferredContactMethod, label: Text("Preferred Contact Method")) {
                        ForEach(0 ..< preferredContactMethods.count) {
                            Text(self.preferredContactMethods[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if(self.addLostPetViewModel.lostPetForm.preferredContactMethod == 2){
                        TextField("Other Contact Method", text: $addLostPetViewModel.lostPetForm.otherContactMethod).padding(.vertical)
                    }
                    
                    
                }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)
                
            }.alert(isPresented: $addLostPetViewModel.showAlert) {
                Alert(title: Text(addLostPetViewModel.errorTitle), message: Text(addLostPetViewModel.errorBody), dismissButton: .default(Text("Ok")))
            }
            
        }
        
    }
    
    
    var body: some View {
        
        VStack {
            
            AddLostPetSections
            
        }.onAppear() {
            
            if(addLostPetViewModel.isEditing) {
                self.title = "Edit Pet"
                self.submitButton = "Save"
            } else {
                self.title = "Add Lost Pet"
                self.submitButton = "Post Lost Pet"
            }
            
        }.navigationTitle("\(title)")
        .sheet(isPresented: $isShowGallery) {
            MyImagePicker(images: $addLostPetViewModel.lostPetForm.images, isShowGallery: self.$isShowGallery)
        }.sheet(isPresented: $isShowCamera) {
            SUImagePickerView(sourceType: .camera, images: self.$addLostPetViewModel.lostPetForm.images, isShowCamera: self.$isShowCamera)
        }
    }
    
}



struct AddLostPet_Previews: PreviewProvider {
    @State var lostPetForm: LostPetForm = LostPetForm()

    static var previews: some View {
        AddLostPet(addLostPetViewModel: AddLostPetViewModel(lostPetForm: LostPetForm(), isEditing: false))
    }
}

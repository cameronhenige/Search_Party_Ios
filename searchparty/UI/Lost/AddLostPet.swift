

import SwiftUI
import Combine
import PhotosUI
import iPhoneNumberField
import FirebaseAuth
import MapKit

struct AddLostPet: View {
    
    @Binding var lostPetForm: LostPetForm

    
    @EnvironmentObject var lostViewRouter: SearchPartyAppState
    @StateObject private var addLostPetViewModel = AddLostPetViewModel()
    
    @State var map = MKMapView()
    @State var currentLocation: CLLocationCoordinate2D?
    @State private var showingPhotoActionSheet = false
    @State var title = ""
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
                TextField("Pet Name", text: $lostPetForm.petName)
                
                Picker(selection: $lostPetForm.petType, label: Text("Pet Type")) {
                    ForEach(0 ..< petTypes.count) {
                        Text(self.petTypes[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                Picker(selection: $lostPetForm.petSex, label: Text("Sex")) {
                    ForEach(0 ..< petSexes.count) {
                        Text(self.petSexes[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                TextField("Approximate Age", text: $lostPetForm.petAge)
                    .keyboardType(.numberPad)
                    .onReceive(Just(lostPetForm.petAge)) { newValue in
                        let filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered != newValue {
                            self.lostPetForm.petAge = filtered
                        }
                    }
                
                TextField("Breed", text: $lostPetForm.petBreed)
                
                VStack(alignment: .leading) {
                    Text("Provide as many angles of your pet as possible.")
                    LazyVGrid(columns: imageColumns, spacing: 10) {
                        
                        ForEach(0..<lostPetForm.images.count, id: \.self) { i in
                            
                            ZStack {
                                
                                if(lostPetForm.images[i].isExisting){
                                    ExistingImage(url: lostPetForm.images[i].name!, lostPetId: lostViewRouter.selectedLostPet?.id)
                                    
                                } else {
                                    
                                    Image(uiImage: lostPetForm.images[i].image!).resizable().frame(height: 150).cornerRadius(20)
                                    
                                }
                                
                                Image(systemName: "trash")
                                    .font(.largeTitle)
                                    .foregroundColor(.white).frame(width: 50, height: 50, alignment: .topTrailing).onTapGesture {
                                        lostPetForm.images.remove(at: i)
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
                
                MultilineTextField("Description", text: $lostPetForm.petDescription)
                
            }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)
            
            
            Section(header: Text("When and where was your pet lost?")) {
                DatePicker(
                    "Lost Date",
                    selection: $lostPetForm.lostDate,
                    displayedComponents: [.date]
                )
                
                VStack(alignment: .leading){
                    Text("Lost Location").padding(.vertical)
                    Text("To obscure your exact location, only the bounding box is saved.").font(.caption).fixedSize(horizontal: false, vertical: true)
                    
                    if(addLostPetViewModel.userLocation != nil) {
                        
                        AddLostPetMapView(map: self.$map, name: self.$lostPetForm.name, coordinate: self.$currentLocation, initialLocation: addLostPetViewModel.userLocation!).frame(height: 300).overlay(Image("dog").resizable().frame(width: 45.0, height: 45.0))
                        
                    }
                    
                    TextField("Location Description", text: $lostPetForm.lostLocationDescription).padding(.vertical)
                    
                }
                
            }.padding(.vertical).disabled(addLostPetViewModel.isAddingLostPet)
            
            Section(header: Text("Let's get your contact information."), footer: Button(action: {
                
                let isEditing = lostViewRouter.isOnEditingLostPet
                addLostPetViewModel.addLostPet(lostPetForm: lostPetForm, isEditing: isEditing, lostPetId: lostViewRouter.selectedLostPet?.id, owners: [Auth.auth().currentUser!.uid], lostLocation: (currentLocation?.geohash(length: 7))!) { result in
                    lostViewRouter.isOnAddingLostPet = false
                    lostViewRouter.isOnEditingLostPet = false
                }
                
                

                
            }) {
                Text("Post Lost Pet")
            }.buttonStyle(PrimaryButtonStyle()).padding()) {
                TextField("Name", text: $lostPetForm.name).textContentType(.name)
                iPhoneNumberField("Phone Number", text: $lostPetForm.phoneNumber)
                TextField("Email", text: $lostPetForm.email).textContentType(.emailAddress)
                
                
                
                VStack(alignment: .leading) {
                    
                    Text("Preferred Contact Method").padding(.vertical)
                    
                    Picker(selection: $lostPetForm.preferredContactMethod, label: Text("Preferred Contact Method")) {
                        ForEach(0 ..< preferredContactMethods.count) {
                            Text(self.preferredContactMethods[$0])
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    
                    if(self.lostPetForm.preferredContactMethod == 2){
                        TextField("Other Contact Method", text: $lostPetForm.otherContactMethod).padding(.vertical)
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
            self.addLostPetViewModel.requestLocation()
            
            if(lostViewRouter.isOnEditingLostPet) {
                self.title = "Edit Pet"
                let selectedLostPet = lostViewRouter.selectedLostPet
//
//                self.lostDate = selectedLostPet?.lostDateTime?.dateValue() ?? Date()
//                self.name = selectedLostPet?.name ?? ""
//                self.phoneNumber = selectedLostPet?.ownerPhoneNumber ?? ""
//                self.email = selectedLostPet?.ownerEmail ?? ""
//                self.otherContactMethod = selectedLostPet?.ownerOtherContactMethod ?? ""
//                //todo self.petName = selectedLostPet?.name ?? ""
//                self.petAge = selectedLostPet?.age?.description ?? ""
//                self.petBreed = selectedLostPet?.breed ?? ""
//
//                self.images = []
//
//
//                if let tempExistingImages = selectedLostPet?.generalImages {
//                    for existingImage in tempExistingImages {
//                        let existingImageString = SelectedImage(name: existingImage, isExisting: true, image: nil)
//                        self.images.append(existingImageString)
//                    }
//                }
//
//                self.petDescription = selectedLostPet?.description ?? ""
//
//                if let type = selectedLostPet?.type {
//                    self.petType = getPetTypeFromLostPet(petType: type)
//                }
//
//                if let sex = selectedLostPet?.sex {
//                    self.petSex = getPetSexFromLostPet(sex: sex)
//                }
//
//                if let preferredContactMethod = selectedLostPet?.ownerPreferredContactMethod {
//                    self.preferredContactMethod = getPreferredContactMethod(method: preferredContactMethod)
//                }
//
//                self.lostLocationDescription = selectedLostPet?.lostLocationDescription ?? ""
//
//                self.otherContactMethod = selectedLostPet?.ownerOtherContactMethod ?? ""
                
                if let lostLocation = selectedLostPet?.lostLocation {
                    let geoHash = GeoHashConverter.decode(hash: lostLocation)
                    
                    let min = CLLocationCoordinate2D(latitude: (geoHash?.latitude.min)!, longitude: (geoHash?.longitude.min)!)
                    let max = CLLocationCoordinate2D(latitude: (geoHash?.latitude.max)!, longitude: (geoHash?.longitude.max)!)
                    
                    let midPoint = CLLocationCoordinate2D.midpoint(between: min, and: max)
                    
                    addLostPetViewModel.userLocation = midPoint
                    
                }
                
            } else {
                self.title = "Add Lost Pet"
            }
            
            
            
        }.navigationTitle("\(title)")
        .sheet(isPresented: $isShowGallery) {
            MyImagePicker(images: $lostPetForm.images, isShowGallery: self.$isShowGallery)
        }.sheet(isPresented: $isShowCamera) {
            SUImagePickerView(sourceType: .camera, images: self.$lostPetForm.images, isShowCamera: self.$isShowCamera)
            
        }
    }
    
    func getPetSexFromLostPet(sex: String) -> Int {
        switch sex {
        case "Male":
            return 0
        case "Female":
            return 1
        default:
            return 0
        }
    }
    
    func getPetTypeFromLostPet(petType: String) -> Int {
        switch petType {
        case "Dog":
            return 0
        case "Cat":
            return 1
        case "Bird":
            return 2
        case "Other":
            return 3
        default:
            return 0
        }
    }
    

    

    
}

struct SUImagePickerView: UIViewControllerRepresentable {
    
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var images: [SelectedImage]
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
                
                let selectedImage = SelectedImage(name: nil, isExisting: false, image: image )
                self.parent.images.append(selectedImage)
            }
            self.parent.isShowCamera = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.isShowCamera = false
            
        }
        
    }
    
}



struct MyImagePicker : UIViewControllerRepresentable {
    @Binding var images: [SelectedImage]
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
                        
                        guard image != nil else {
                            print(err)
                            return
                        }
                        
                        let selectedImage = SelectedImage(name: nil, isExisting: false, image: image as? UIImage)
                        self.parent.images.append(selectedImage)
                        
                    }
                } else{
                    print("cannot be loaded")
                    
                }
            }
            
        }
    }
    
}

//struct AddLostPet_Previews: PreviewProvider {
//    @State var lostPetForm: LostPetForm = LostPetForm()
//
//    static var previews: some View {
//        AddLostPet(lostPetForm: $lostPetForm)
//    }
//}

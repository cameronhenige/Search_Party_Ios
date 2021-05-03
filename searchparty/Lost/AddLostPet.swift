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

struct AddLostPet: View {
    @State private var showingActionSheet = false
       @State private var backgroundColor = Color.white
    var items: [GridItem] {
      Array(repeating: .init(.adaptive(minimum: 120)), count: 2)
    }
    @State var petName = ""
    @State var petAge = ""
    @State var petBreed = ""
    @State private var isShowPhotoLibrary = false
    @State private var isShowCamera = false
    @State private var image = UIImage()
    @State private var images : [UIImage] = []
    @State var picker = false

    @State private var petType = 0
    var petTypes = ["Dog", "Cat", "Bird", "Other"]
    
    @State private var petSex = 0
    var petSexes = ["Male", "Female"]

    
    var body: some View {
        Form {
            
                Section(header: Text("Let's get some information about your lost pet.")) {
                    TextField("Pet Name", text: $petName)
                    
                    Picker(selection: $petType, label: Text("Pet Type")) {
                        ForEach(0 ..< petTypes.count) {
                            Text(self.petTypes[$0])
                        }
                    }
                    
                    Picker(selection: $petSex, label: Text("Sex")) {
                        ForEach(0 ..< petSexes.count) {
                            Text(self.petSexes[$0])
                        }
                    }

                    
                    TextField("Approximate Age", text: $petAge)
                        .keyboardType(.numberPad)
                        .onReceive(Just(petAge)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.petAge = filtered
                            }
                    }
                    
                    TextField("Breed", text: $petBreed)
                    
                    if !images.isEmpty{
                        
                        LazyVGrid(columns: items, spacing: 10) {
                                ForEach(0..<images.count, id: \.self) { i in

                                
                                ZStack {
                                
                                Image(uiImage: images[i]).resizable().frame(height: 150).cornerRadius(20)
                                    
                                        Image(systemName: "trash")
                                            .font(.largeTitle)
                                            .foregroundColor(.white).frame(width: 50, height: 50, alignment: .topTrailing).onTapGesture {
                                                print("Delete button tapped!")
                                                images.remove(at: i)
                                            }
                                    
                                }
                            }
                        }
                    }
                    
                    Image(uiImage: self.image)
                        .resizable()
                        .frame(minWidth: 0, maxWidth: .infinity, maxHeight: 100.0)
                    
                    
                    Button(action: {
                        self.showingActionSheet = true
                        //self.picker = true
                    }) {
                        Text("Add Image")
                    }.buttonStyle(PrimaryButtonStyle()).padding([.top, .leading])

                }
        
                
        }.actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(title: Text("Choose Photo Location"), message: Text("Select photo location"), buttons: [
                .default(Text("Gallery")) {
                    self.showingActionSheet = false
                    self.picker = true },
                .default(Text("Camera")) {
                    //todo
                    self.isShowCamera = true },
                .cancel()
            ])
        }.navigationTitle("Add Lost Pet").navigationBarColor(Constant.color.tintColor.uiColor())
        .sheet(isPresented: $picker) {
            MyImagePicker(images: $images, picker: $picker)
        }.sheet(isPresented: $isShowCamera) {
            ImagePicker(sourceType: .camera, selectedImage: self.$image)
            
        }

        }
    
}

struct MyImagePicker : UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var picker: Bool
    
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
            parent.picker.toggle()
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

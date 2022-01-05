//
//  MyImagePicker.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/5/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//
import SwiftUI
import Combine
import PhotosUI

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
                            print(err.debugDescription)
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

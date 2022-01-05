//
//  SUImagePickerView.swift
//  searchparty
//
//  Created by Hannah Krolewski on 1/5/22.
//  Copyright © 2022 Filip Molcik. All rights reserved.
//

import SwiftUI
import Combine
import PhotosUI

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

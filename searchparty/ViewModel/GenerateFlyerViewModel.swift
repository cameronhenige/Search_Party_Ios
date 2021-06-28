//
//  GenerateFlyerViewModel.swift
//  searchparty
//
//  Created by Hannah Krolewski on 6/27/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import Foundation
import TPPDF
import UIKit

class GenerateFlyerViewModel: NSObject, ObservableObject {
    @Published var isGeneratingFlyer = false
    var document: PDFDocument!

    func generateFlyer(lostPet: LostPet) {
        self.isGeneratingFlyer = true
        self.createPdf()
        
    }
    
    
    func createPdf() {
        DispatchQueue.global().async { [self] in

            document = PDFDocument(format: .a4)
//            addFirstPage()
//
//        for (index, room) in everyThing.rooms.enumerated() {
//            DispatchQueue.main.async {
//                statusLabel.text = "Exporting \(room.name) " + String(index+1) + "/\(everyThing.rooms.count)"
//            }
//            self.addRoom(room: room)
//        }
//
//            DispatchQueue.main.async {
//                statusLabel.text = "Saving File."
//            }
            
            let generator = PDFGenerator(document: document)
            let url = try? generator.generateURL(filename: "Flyer.pdf")
        DispatchQueue.main.async {
            savePdf(url: url!)
            //statusLabel.text = "Pdf Generated."
            //hideLoading()

        }
        
        }
    

    }
    
    func savePdf(url: URL) {

//                        let objectsToShare = [url]
//                        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//                        if let popoverController = activityVC.popoverPresentationController {
//                            popoverController.sourceView = self.view
//                            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
//                            popoverController.permittedArrowDirections = []
//                        }
//
//                        self.present(activityVC, animated: true, completion: nil)
        
    }
    
}

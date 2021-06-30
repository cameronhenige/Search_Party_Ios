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
    
    
    @Published var isShowingFlyer = false
    @Published var flyerURL: URL? = nil

    
    var document: PDFDocument!

    func generateFlyer(lostPet: LostPet) {
        self.isGeneratingFlyer = true
        self.createPdf(lostPet: lostPet)
        
    }
    
    
    func createPdf(lostPet: LostPet) {
        DispatchQueue.global().async { [self] in

            document = PDFDocument(format: .a4)
            
//            let houseBookIcon = PDFImage(image: UIImage(named: "cat.png")!,
//                                        size: CGSize(width: 100, height: 100), options: [.none])
//            document.add(.contentCenter, image: houseBookIcon)
//            document.add(space: 10)
            addFirstPage(lostPet: lostPet)
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
            flyerURL = url
            self.isShowingFlyer = true
            let activityVC = UIActivityViewController(activityItems: [flyerURL], applicationActivities: nil)
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
        
        }
    

    }
    
    func addFirstPage(lostPet: LostPet) {
        let houseBookIcon = PDFImage(image: UIImage(named: "cat.png")!,
                                    size: CGSize(width: 100, height: 100), options: [.none])
        document.add(.contentCenter, image: houseBookIcon)
        document.add(space: 10)

            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
        
        let dateString = formatter.string(from: Date())
        var lostPetName = ""
        
        if(lostPet.type == "Other") {
            lostPetName = "PET"
        } else {
            lostPetName = lostPet.type ?? "PET"
        }
        document.add(.contentCenter, text: "LOST " + lostPetName.uppercased()) //todo handle OTHER type
        document.add(space: 10)
        
        
        lostPet.description
        
        if(lostPet.description != nil){
            document.add(.contentCenter, text: lostPet.description!)
            document.add(space: 60)
        }
        
//        val lostTextParagraph = Paragraph(lostText, superLarge)
//               lostTextParagraph.alignment = Element.ALIGN_CENTER
//
//               lostTextParagraph.spacingAfter = 60f
//               document.add(lostTextParagraph)
//
//
//
//               var numberOfColumns =0
//
//               if(lostPet.generalImages.size > 0){
//                   numberOfColumns = 2
//               }else{
//                   numberOfColumns = 1
//               }
//               val table = PdfPTable(numberOfColumns)
//
//               if(lostPet.generalImages.size > 0){
//                   table.setWidths(intArrayOf(1, 1))
//                   addLostPetImage(table, lostPet, context)
//               }else{
//                   table.setWidths(intArrayOf(1))
//               }
//
//               table.widthPercentage = 100f
//               table.spacingAfter = 25f
//               table.addCell(createPetDescriptionCell(lostPet))
//
//               document.add(table)
//
//               if(lostPet.ownerName != null) {
//                   val ownerName = addMediumCenterLine("Contact: " + lostPet.ownerName!!)
//                   ownerName.spacingAfter = 20f
//                   document.add(ownerName)
//               }
//
//               if(lostPet.ownerPhoneNumber != null) {
//                   val ownerLine = addMediumCenterLine(lostPet.ownerPhoneNumber!!)
//                   ownerLine.leading = 25f
//                   document.add(ownerLine)
//               }
//
//               if(lostPet.ownerEmail != null){
//                   val ownerEmail = addMediumCenterLine(lostPet.ownerEmail!!)
//                   ownerEmail.leading = 25f
//                   document.add(ownerEmail)
//               }
//
//               document.add(createQrCode(qrCodeLink))
//               document.add(addSmallCenteredLine("Scan QR Code to help find " + lostPet.name + " in the Search Party App."))
//
        
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

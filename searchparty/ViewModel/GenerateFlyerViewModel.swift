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
import Kingfisher
import FirebaseStorage
import CoreImage.CIFilterBuiltins

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
            document.set(font: UIFont.systemFont(ofSize: 40.0))

            addFirstPage(lostPet: lostPet)
            
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
        
        
        document.add(text: "LOST \(lostPetName.uppercased())") //todo handle OTHER type
        document.add(space: 10)
        
        document.resetFont()
        let section = PDFSection(columnWidths: [0.5, 0.5])
        
        if(lostPet.generalImages != nil && !lostPet.generalImages!.isEmpty){
            addImage(column: section.columns[0], lostPet: lostPet)

        }else {
            let houseBookIcon = PDFImage(image: UIImage(named: "cat.png")!,
                                         size: CGSize(width: 500, height: 500), options: [.resize])
            section.columns[0].add(image: houseBookIcon)
        }
        
        if(lostPet.description != nil){
            section.columns[1].add(text: lostPet.description!)
            section.columns[1].add(space: 10)

        }

        section.columns[1].add(text: "Name: " + lostPet.name)
        section.columns[1].add(space: 10)


        if(lostPet.breed != nil) {
            section.columns[1].add(text: "Breed: " + lostPet.breed!)
            section.columns[1].add(space: 10)

        }

        if(lostPet.age != nil) {
            section.columns[1].add(text: "Age: \(lostPet.age)")
            section.columns[1].add(space: 10)

        }

        if(lostPet.sex != nil) {
            section.columns[1].add(text: "Sex: " + lostPet.sex!)
            section.columns[1].add(space: 10)

        }

        if(lostPet.description != nil) {
            section.columns[1].add(text: "Description: " + lostPet.description!)
            section.columns[1].add(space: 10)

        }

        if(lostPet.lostDateTime != nil) {
            section.columns[1].add(text: "Date Lost: \(lostPet.lostDateTime)")
            section.columns[1].add(space: 10)

        }

        if(lostPet.lostLocationDescription != nil) {
            section.columns[1].add(text: "Location Lost: " + lostPet.lostLocationDescription!)
            section.columns[1].add(space: 10)

        }
        
        document.add(section: section)
        document.add(space: 20)
        
        if(lostPet.ownerName != nil) {
            document.add(.contentCenter, text: "Contact: " + lostPet.ownerName!)
            document.add(space: 10)

        }

        if(lostPet.ownerPhoneNumber != nil) {
            document.add(.contentCenter, text: lostPet.ownerPhoneNumber!)
            document.add(space: 10)

        }

        if(lostPet.ownerEmail != nil){
            document.add(.contentCenter, text: lostPet.ownerEmail!)
            document.add(space: 10)

        }
        
        var link = DynamicLinkGenerator.getShareLink(lostPetName: lostPet.name, lostPetId: lostPet.id!)
        

        //todo document.add(createQrCode(qrCodeLink))
        let imageElement = PDFImage(image: createQRCodeImage(lostPet: lostPet, url: link!.link.absoluteString)!,
                                    size: CGSize(width: 80, height: 80), options: [.none]) //todo use correct url
        document.add(.contentCenter, image: imageElement)

        document.add(.contentCenter, text: "Scan QR Code to help find \(lostPet.name) in the Search Party App.")

        
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
    
    func createQRCodeImage(lostPet: LostPet, url: String) -> UIImage? {
        let data = Data(url.utf8)
        
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = CIContext().createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        
        return nil
        
    }
    
    func addImage(column: PDFSectionColumn, lostPet: LostPet){


        if(lostPet.generalImages != nil && !lostPet.generalImages!.isEmpty){

            let imageReference : String = "Lost/" + lostPet.id! + "/generalImages/" + lostPet.generalImages![0]
            let storage = Storage.storage().reference().child(imageReference)
            let roomImageResult = self.getImage(imageReference: storage)
            
        switch roomImageResult {
          case let .success(data):

//            let heightRatio = roomImageHeight / data.size.height
//            let newWidth = data.size.width * heightRatio
            let imageElement = PDFImage(image: data,
                                        size: CGSize(width: data.size.width, height: data.size.height), options: [.none])
            column.add(image: imageElement)

        case .failure(_):
            showErrorGettingLostPetImage()
           }
        }


    }
    
    func showErrorGettingLostPetImage() {
        
    }
    
    func getImage(imageReference: StorageReference) -> Result<KFCrossPlatformImage, Error> {
        
        var getImageResult: Result<KFCrossPlatformImage, Error>!

        let semaphore = DispatchSemaphore(value: 0)
        

        imageReference.downloadURL { (url: URL?, error: Error?) in
            let resource = ImageResource(downloadURL: url!)

            
            KingfisherManager.shared.retrieveImage(with: resource, completionHandler: { result in
                switch result {
                case .success(let value):
                    getImageResult = .success(value.image)

                case .failure(let error):
                    getImageResult = .failure(error)
                }
                semaphore.signal()

            })
        }

        
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return getImageResult
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

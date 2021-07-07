//
//  GenerateFlyerViewModelX.swift
//  searchparty
//
//  Created by Hannah Krolewski on 7/6/21.
//  Copyright © 2021 Filip Molcik. All rights reserved.
//

import UIKit
import PDFKit
import Foundation
import Kingfisher
import FirebaseStorage
import CoreImage.CIFilterBuiltins

class GenerateFlyerViewModelX: NSObject {
  let contactInfo: String = "contactInfo"
    let lostPet: LostPet
    
    let taskDateFormat: DateFormatter = {
            let formatter = DateFormatter()
        formatter.dateStyle = .short
            return formatter
        }()
    
    init(lostPet: LostPet) {
      self.lostPet = lostPet
    }
  
    func createFlyer() -> Data {
    // 1
    let pdfMetaData = [
      kCGPDFContextCreator: "Flyer Builder",
      kCGPDFContextAuthor: "raywenderlich.com",
        kCGPDFContextTitle: lostPet.name + " Flyer"
    ]
    let format = UIGraphicsPDFRendererFormat()
    format.documentInfo = pdfMetaData as [String: Any]
    
    // 2
    let pageWidth = 8.5 * 72.0
    let pageHeight = 11 * 72.0
    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
    
    // 3
    let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
    // 4
    let data = renderer.pdfData { (context) in
      // 5
      context.beginPage()
      // 6
      let titleBottom = addTitle(pageRect: pageRect)
      let imageBottom = addImage(pageRect: pageRect, imageTop: titleBottom + 18.0)
      let bodyText = addBodyText(pageRect: pageRect, textTop: imageBottom + 18.0)
      addQRCode(pageRect: pageRect, imageTop: bodyText)


      //let context = context.cgContext
      //drawTearOffs(context, pageRect: pageRect, tearOffY: pageRect.height * 4.0 / 5.0, numberTabs: 8)
        //drawContactLabels(context, pageRect: pageRect, numberTabs: 8)
    }
    
    return data
  }
  
  func addTitle(pageRect: CGRect) -> CGFloat {
    // 1
    let titleFont = UIFont.systemFont(ofSize: 35.0, weight: .bold)
    // 2
    let titleAttributes: [NSAttributedString.Key: Any] =
      [NSAttributedString.Key.font: titleFont]
    
    
    var lostPetName = ""
    
    if(lostPet.type == "Other") {
        lostPetName = "PET"
    } else {
        lostPetName = lostPet.type ?? "PET"
    }
    
    let attributedTitle = NSAttributedString(string: "LOST \(lostPetName.uppercased())", attributes: titleAttributes)
    // 3
    let titleStringSize = attributedTitle.size()
    // 4
    let titleStringRect = CGRect(x: (pageRect.width - titleStringSize.width) / 2.0,
                                 y: 36, width: titleStringSize.width,
                                 height: titleStringSize.height)
    // 5
    attributedTitle.draw(in: titleStringRect)
    // 6
    return titleStringRect.origin.y + titleStringRect.size.height
  }

  func addBodyText(pageRect: CGRect, textTop: CGFloat) -> CGFloat {
    // 1
    let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
    // 2
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .natural
    paragraphStyle.lineBreakMode = .byWordWrapping
    
    // 3
    let textAttributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: textFont
    ]
    
    let fullText = getFullText()
    let attributedText = NSAttributedString(string: fullText, attributes: textAttributes)
    // 4
    let textRect = CGRect(x: 70, y: textTop, width: pageRect.width - 70,
                          height: pageRect.height - textTop - pageRect.height / 5.0)
    attributedText.draw(in: textRect)
    
    return textRect.origin.y + textRect.size.height
  }
    

    
    func getFullText() -> String {
        var text = ""
        if(lostPet.description != nil && !lostPet.description!.isEmpty){
            text.append("\(lostPet.description!)\n\n")
        }

        text.append("\nName: " + lostPet.name)

        if(lostPet.breed != nil && !lostPet.breed!.isEmpty) {
            text.append("\nBreed: " + lostPet.breed!)
        }

        if(lostPet.age != nil) {
            text.append("\nAge: \(lostPet.age!)")
        }

        if(lostPet.sex != nil && !lostPet.sex!.isEmpty) {
            text.append("\nSex: " + lostPet.sex!)
        }

        if(lostPet.lostDateTime != nil) {
            text.append("\nDate Lost: \(taskDateFormat.string(from: (lostPet.lostDateTime?.dateValue())!))")
        }

        if(lostPet.lostLocationDescription != nil && !lostPet.lostLocationDescription!.isEmpty) {
            text.append("\nLocation Lost: " + lostPet.lostLocationDescription!)
        }

        if(lostPet.ownerName != nil && !lostPet.ownerName!.isEmpty) {
            text.append("\nContact: " + lostPet.ownerName!)
        }

        if(lostPet.ownerPhoneNumber != nil && !lostPet.ownerPhoneNumber!.isEmpty) {
            text.append("\n\(lostPet.ownerPhoneNumber!)")
        }

        if(lostPet.ownerEmail != nil && !lostPet.ownerEmail!.isEmpty){
            text.append("\n\(lostPet.ownerEmail!)")
        }
        
        return text
    }

  func addImage(pageRect: CGRect, imageTop: CGFloat) -> CGFloat {
    
    let image = getImage()
    // 1
    let maxHeight = pageRect.height * 0.35
    let maxWidth = pageRect.width * 0.8
    // 2
    let aspectWidth = maxWidth / image.size.width
    let aspectHeight = maxHeight / image.size.height
    let aspectRatio = min(aspectWidth, aspectHeight)
    // 3
    let scaledWidth = image.size.width * aspectRatio
    let scaledHeight = image.size.height * aspectRatio
    // 4
    let imageX = (pageRect.width - scaledWidth) / 2.0
    let imageRect = CGRect(x: imageX, y: imageTop,
                           width: scaledWidth, height: scaledHeight)
    // 5
    image.draw(in: imageRect)
    return imageRect.origin.y + imageRect.size.height
  }
    
    func addQRCode(pageRect: CGRect, imageTop: CGFloat) {
        var link = DynamicLinkGenerator().getShareLink(lostPetName: lostPet.name, lostPetId: lostPet.id!)
        
        switch link {
          case let .success(data):
            let image = createQRCodeImage(lostPet: lostPet, url: data.absoluteString)!

            //tododocument.add(.contentCenter, text: "Scan QR Code to help find \(lostPet.name) in the Search Party App.")
            // 1
            let maxHeight = pageRect.height * 0.15
            let maxWidth = pageRect.width * 0.15
            // 2
            let aspectWidth = maxWidth / image.size.width
            let aspectHeight = maxHeight / image.size.height
            let aspectRatio = min(aspectWidth, aspectHeight)
            // 3
            let scaledWidth = image.size.width * aspectRatio
            let scaledHeight = image.size.height * aspectRatio
            // 4
            let imageX = (pageRect.width - scaledWidth) / 2.0
            let imageRect = CGRect(x: imageX, y: imageTop,
                                   width: scaledWidth, height: scaledHeight)
            // 5
            image.draw(in: imageRect)
            
            // 1
            let textFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
            // 2
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.lineBreakMode = .byWordWrapping
            
            // 3
            let textAttributes = [
              NSAttributedString.Key.paragraphStyle: paragraphStyle,
              NSAttributedString.Key.font: textFont
            ]
            
            let fullText = "Scan QR Code to help find \(lostPet.name) in the Search Party App."
            let attributedText = NSAttributedString(string: fullText, attributes: textAttributes)
            // 4
            
            let textSize = attributedText.size()

            
            let bottomOfQRCode = imageRect.origin.y + imageRect.height
            let textRect = CGRect(x: (pageRect.width - textSize.width) / 2.0, y: bottomOfQRCode + 5, width: textSize.width,
                                  height: textSize.height)
        
            
            attributedText.draw(in: textRect)
            
            
        case .failure(_):
            print("failure!")
            //todo show failed getting link
           }
        

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
    
    func getImage() -> UIImage {
      
      if(self.lostPet.generalImages != nil && !lostPet.generalImages!.isEmpty){
        return addImage(lostPet: lostPet)!

      } else {
  //        let houseBookIcon = PDFImage(image: UIImage(named: "cat.png")!,
  //                                     size: CGSize(width: 500, height: 500), options: [.resize])
  //        section.columns[0].add(image: houseBookIcon)
        
        let petImage = PetImageTypes().getPetImageType(petType: lostPet.type)
        if(petImage != nil){
            return UIImage(named: petImage!)!

        }else{
            return UIImage(imageLiteralResourceName: "map")
        }
      }
      
    }
    
    func addImage(lostPet: LostPet) -> UIImage?{


        if(lostPet.generalImages != nil && !lostPet.generalImages!.isEmpty){

            let imageReference : String = "Lost/" + lostPet.id! + "/generalImages/" + lostPet.generalImages![0]
            let storage = Storage.storage().reference().child(imageReference)
            let roomImageResult = self.getImage(imageReference: storage)
            
        switch roomImageResult {
          case let .success(data):

//            let heightRatio = roomImageHeight / data.size.height
//            let newWidth = data.size.width * heightRatio
//            let imageElement = PDFImage(image: data,
//                                        size: CGSize(width: data.size.width, height: data.size.height), options: [.none])
//            column.add(image: imageElement)
            return data

        case .failure(_):
            print("failed")
            return nil
            //todo showErrorGettingLostPetImage()
           }
        }
        return nil

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
  
  // 1
  func drawTearOffs(_ drawContext: CGContext, pageRect: CGRect,
                    tearOffY: CGFloat, numberTabs: Int) {
    // 2
    drawContext.saveGState()
    drawContext.setLineWidth(2.0)
    
    // 3
    drawContext.move(to: CGPoint(x: 0, y: tearOffY))
    drawContext.addLine(to: CGPoint(x: pageRect.width, y: tearOffY))
    drawContext.strokePath()
    drawContext.restoreGState()
    
    // 4
    drawContext.saveGState()
    let dashLength = CGFloat(72.0 * 0.2)
    drawContext.setLineDash(phase: 0, lengths: [dashLength, dashLength])
    // 5
    let tabWidth = pageRect.width / CGFloat(numberTabs)
    for tearOffIndex in 1..<numberTabs {
      // 6
      let tabX = CGFloat(tearOffIndex) * tabWidth
      drawContext.move(to: CGPoint(x: tabX, y: tearOffY))
      drawContext.addLine(to: CGPoint(x: tabX, y: pageRect.height))
      drawContext.strokePath()
    }
    // 7
    drawContext.restoreGState()
  }
  
  func drawContactLabels(_ drawContext: CGContext, pageRect: CGRect, numberTabs: Int) {
    let contactTextFont = UIFont.systemFont(ofSize: 10.0, weight: .regular)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.alignment = .natural
    paragraphStyle.lineBreakMode = .byWordWrapping
    let contactBlurbAttributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.font: contactTextFont
    ]
    let attributedContactText = NSMutableAttributedString(string: contactInfo, attributes: contactBlurbAttributes)
    // 1
    let textHeight = attributedContactText.size().height
    let tabWidth = pageRect.width / CGFloat(numberTabs)
    let horizontalOffset = (tabWidth - textHeight) / 2.0
    drawContext.saveGState()
    // 2
    drawContext.rotate(by: -90.0 * CGFloat.pi / 180.0)
    for tearOffIndex in 0...numberTabs {
      let tabX = CGFloat(tearOffIndex) * tabWidth + horizontalOffset
      // 3
      attributedContactText.draw(at: CGPoint(x: -pageRect.height + 5.0, y: tabX))
    }
    drawContext.restoreGState()
  }
}

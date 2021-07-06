

import Foundation
import Firebase

public class DynamicLinkGenerator {


//    static func getShareLink(lostPetName: String, lostPetId: String) -> DynamicLinkComponents?{
//        var components = URLComponents()
//
//        components.scheme = "https"
//        components.host = "www.searchparty.io/LostPet"
//
//        let shareIdQuery = URLQueryItem(name: "lostPetId", value: lostPetId)
//
//        components.queryItems = [shareIdQuery]
//
//        guard let linkParameter = components.url else { return nil}
//
//        let sharelink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://searchpartydev.page.link")
//
//
//        sharelink!.iOSParameters = DynamicLinkIOSParameters(bundleID: "chenige.chkchk.searchparty")
//
//        sharelink?.iOSParameters?.appStoreID = "" //todo get correct app store id
//
//        sharelink?.androidParameters = DynamicLinkAndroidParameters(packageName: "chenige.chkchk.searchparty")
//
//        sharelink?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
//        sharelink?.socialMetaTagParameters?.title = "Join my Search Party"
//        sharelink?.socialMetaTagParameters?.descriptionText = "Tap here to help me find my lost pet \(lostPetName)."
//
//
//        sharelink!.shorten() { url, warnings, error in
//          guard let url = url, error != nil else { return }
//          print("The short URL is: \(url)")
//        }
//
//        return sharelink!
//    }
    
    func getShareLink(lostPetName: String, lostPetId: String) -> Result<URL, Error> {
        
        var getLinkResult: Result<URL, Error>!

        let semaphore = DispatchSemaphore(value: 0)
        
        
        
        var components = URLComponents()
            
        components.scheme = "https"
        components.host = "www.searchparty.io"
        components.path = "/LostPet"
        let shareIdQuery = URLQueryItem(name: "lostPetId", value: lostPetId)

        components.queryItems = [shareIdQuery]

        let linkParameter = components.url
        
        
        //let searchPartyLink = "https://www.searchparty.io/LostPet?lostPetId=\(lostPetId)"

        let sharelink = DynamicLinkComponents.init(link: linkParameter!, domainURIPrefix: "https://searchpartydev.page.link")
        

        sharelink!.iOSParameters = DynamicLinkIOSParameters(bundleID: "chenige.chkchk.searchparty")

        sharelink?.iOSParameters?.appStoreID = "" //todo get correct app store id

        sharelink?.androidParameters = DynamicLinkAndroidParameters(packageName: "chenige.chkchk.searchparty")

        sharelink?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharelink?.socialMetaTagParameters?.title = "Join my Search Party"
        sharelink?.socialMetaTagParameters?.descriptionText = "Tap here to help me find my lost pet \(lostPetName)."
        
        sharelink!.shorten() { url, warnings, error in
            if(error == nil){
                print("The short URL is: \(url)")
                getLinkResult = .success(url!)
            }else {
                getLinkResult = .failure(error!)
            }
            
            semaphore.signal()

        }
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return getLinkResult
    }
    
    
}

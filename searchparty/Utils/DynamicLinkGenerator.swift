

import Foundation
import Firebase

public class DynamicLinkGenerator {


    static func getShareLink(lostPetName: String, lostPetId: String) -> DynamicLinkComponents?{
        var components = URLComponents()
            
        components.scheme = "https"
        components.host = "www.searchparty.io"

        let shareIdQuery = URLQueryItem(name: "lostPetId", value: lostPetId)

        components.queryItems = [shareIdQuery]

        guard let linkParameter = components.url else { return nil}

        let sharelink = DynamicLinkComponents.init(link: linkParameter, domainURIPrefix: "https://searchparty.page.link")

        sharelink!.iOSParameters = DynamicLinkIOSParameters(bundleID: "chenige.chkchk.searchparty")

        sharelink?.iOSParameters?.appStoreID = "" //todo get correct app store id

        sharelink?.androidParameters = DynamicLinkAndroidParameters(packageName: "chenige.chkchk.searchparty")

        sharelink?.socialMetaTagParameters = DynamicLinkSocialMetaTagParameters()
        sharelink?.socialMetaTagParameters?.title = "Join my Search Party"
        sharelink?.socialMetaTagParameters?.descriptionText = "Tap here to help me find my lost pet \(lostPetName)."
        
        return sharelink!
    }
}

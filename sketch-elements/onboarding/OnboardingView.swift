//
//  OnboardingView.swift
//  SearchPartyIos
//
//  Created by Hannah Krolewski on 3/10/21.
//

import SwiftUI

struct OnboardingView: View {
    
    
    @EnvironmentObject var viewRouter: OnboardingRouter

    @State var currentPageIndex = 0
    var titles = ["Welcome to Search Party!", "Add posts for lost and found pets", "Create or join a search party"]
    var captions =  ["Where lost pets are found.", "We'll create a flyer for you to post around your neighborhood. It has a QR code that links directly to your lost pet post.", "Use the map feature to track where you and others have searched for lost pets in your neighborhood. Users will be notified of lost pets in their area so they can join the search party."]
    var subviews = [
        UIHostingController(rootView: Subview(imageString: "flashlight")),
        UIHostingController(rootView: LottieSubview(filename: "flyer")),
        UIHostingController(rootView: LottieSubview(filename: "my_location"))

    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                .frame(height: 600)
            Group {
                Text(titles[currentPageIndex])
                    .font(.title)
                Text(captions[currentPageIndex])
                .font(.subheadline)
                .foregroundColor(.gray)
                    .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                .frame(width: 300, height: 50, alignment: .leading)
                .lineLimit(nil)
            }
                .padding()
            HStack {
                PageControl(numberOfPages: subviews.count, currentPageIndex: $currentPageIndex)
                Spacer()
                
                
                if currentPageIndex == 2 {
                                    Button(action: {
                                        withAnimation {
                                            self.viewRouter.currentPage = "signIn"
                                        }
                                    }) {
                                        ButtonContent()
                                    }
                                } else {
                                    Button(action: {
                                        if self.currentPageIndex+1 == self.subviews.count {
                                            self.currentPageIndex = 0
                                        } else {
                                            self.currentPageIndex += 1
                                        }
                                    }) {
                                        ButtonContent()
                                    }
                                }
                
                
                
                
                
            }
                .padding()
        }
    }
}

struct ButtonContent: View {
var body: some View {
Image(systemName: "arrow.right")
        .resizable()
        .foregroundColor(.white)
        .frame(width: 30, height: 30)
        .padding()
        .background(Color(#colorLiteral(red: 0.1568627451, green: 0.2941176471, blue: 0.3882352941, alpha: 1)))
        .cornerRadius(30)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}

//
//  ComplexRateView.swift
//  pokedexapp
//
//  Created by Paulik on 24.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import SwiftUI

struct ComplexRateView: View {
    
    var topInset: CGFloat?
    var subviews = [UIHostingController<RateView>]()
    @State var currentPageIndex = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
                PageViewController(currentPageIndex: $currentPageIndex, viewControllers: subviews)
                PageControl(numberPages: subviews.count, currentPageIndex: $currentPageIndex)
                    .padding(.bottom, 45)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.height - topInset!, alignment: .top)
        .background(SwiftUI.Color.white)
        .cornerRadius(30, corners: [.topLeft, .topRight])
        .padding(EdgeInsets(top: topInset!, leading: 0, bottom: 0, trailing: 0))
        .edgesIgnoringSafeArea(.all)
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

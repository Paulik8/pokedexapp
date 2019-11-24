//
//  PageControl.swift
//  pokedexapp
//
//  Created by Paulik on 18.11.2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import UIKit
import SwiftUI

struct PageControl: UIViewRepresentable {
    
    var numberPages: Int?
    @Binding var currentPageIndex: Int
    
    func updateUIView(_ uiView: UIPageControl , context: UIViewRepresentableContext<PageControl>) {
        guard let numberPages = self.numberPages else { return }
        uiView.numberOfPages = numberPages
        uiView.currentPage = currentPageIndex
    }
    
    func makeUIView(context: UIViewRepresentableContext<PageControl>) -> UIPageControl {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor.lightGray
        page.currentPageIndicatorTintColor = UIColor.darkGray
        guard let numberPages = self.numberPages else { return page }
        page.numberOfPages = numberPages
        return page
    }
    
}

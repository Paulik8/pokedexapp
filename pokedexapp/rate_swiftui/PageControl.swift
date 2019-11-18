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
    
    var current = 0
    var numberPages: Int?
    
    init(numberPages: Int) {
        self.numberPages = numberPages
    }
    
    func updateUIView(_ uiView: UIPageControl , context: UIViewRepresentableContext<PageControl>) {
        guard let numberPages = self.numberPages else { return }
        uiView.numberOfPages = numberPages
        uiView.currentPage = current
    }
    
    func makeUIView(context: UIViewRepresentableContext<PageControl>) -> UIPageControl {
        let page = UIPageControl()
        page.pageIndicatorTintColor = UIColor.lightGray
//            UIColor(red: 255/255, green: 225/255, blue: 240/255, alpha: 1)
        page.currentPageIndicatorTintColor = UIColor.darkGray
//            UIColor(red: 255/255, green: 135/255, blue: 195/255, alpha: 1)
        guard let numberPages = self.numberPages else { return page }
        page.numberOfPages = numberPages
        return page
    }
    
}

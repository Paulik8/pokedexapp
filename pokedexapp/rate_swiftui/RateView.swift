//
//  RateView.swift
//  pokedexapp
//
//  Created by Paulik on 15/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import SwiftUI
import Combine

struct RateView: View {
    var topInset: CGFloat?
    var chainId: Int?
    var id: Int?
    
    @State var currentPage = 0
    @ObservedObject var viewModel: RateNewViewModel = RateNewViewModel()
    
    func updateViewModel() {
        if let _ = viewModel.chainId {
            return
        } else {
            viewModel.id = id
            viewModel.chainId = chainId
        }
    }
    
    var body: some View {
        updateViewModel()
        return ZStack {
            VStack {
                ZStack {
                    CardView(arr: viewModel.stats)
                }
                
//                PageControl(current: currentPage, numberPages: viewModel.numberOfPages)
            }
//            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
//            .background(SwiftUI.Color.white)
//            .cornerRadius(30)
//            .padding(EdgeInsets(top: topInset!, leading: 0, bottom: 0, trailing: 0))
        }
//        .edgesIgnoringSafeArea(.all)
    }
}

struct CardView: View {
    
    var arr = [StatData]()
    
    var body: some View {
        HStack(spacing: 16) {
            ForEach(arr) { data in
                BarView(value: CGFloat(data.baseStat))
            }
        }
    }
    
}

struct BarView: View {
    
    var value: CGFloat
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Capsule().frame(width: 30, height: 200).foregroundColor(SwiftUI.Color(red: 240/255, green: 240/255, blue: 240/255, opacity: 1))
            Capsule().frame(width: 30, height: value).foregroundColor(.gray)
        }
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        print ("withURL")
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:200, height:200)
        }.onReceive(imageLoader.didChange) { data in
            self.image = UIImage(data: data) ?? UIImage()
        }
    }
}

#if DEBUG

struct RatePreviews: PreviewProvider {
    
    static var previews: some View {
        RateView()
    }
}

#endif

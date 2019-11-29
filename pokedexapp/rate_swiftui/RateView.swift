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
        return ZStack(alignment: .top) {
            CardView(arr: viewModel.stats, imageUrl: viewModel.name)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
    }
}

struct CardView: View {
    
    var arr = [StatData]()
    var imageUrl: String
    
    var body: some View {
        VStack(alignment: .center) {
            ImageView(withURL: imageUrl).padding(.top, 16)
            HStack(spacing: 12) {
                    ForEach(arr) { data in
                        BarView(value: CGFloat(data.baseStat), changable: 0, charName: data.stat!.name)
                    }
                    .padding(.top, 60)

            }
        }
    }
    
}

struct BarView: View {
    
    var value: CGFloat
   @State var changable: CGFloat
    var charName: String
    let maxHeight: CGFloat = 180
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                Capsule()
                    .frame(width: 30, height: maxHeight)
                    .foregroundColor(SwiftUI.Color(red: 240/255, green: 240/255, blue: 240/255, opacity: 1))
                    Capsule()
                        .frame(width: 30, height: changable)
                        .foregroundColor(.gray)
                        .onAppear {
                            withAnimation(.linear(duration: 0.8)) {
                                if (self.value * 1.2 >= self.maxHeight) {
                                    self.changable = self.maxHeight
                                } else {
                                    self.changable = self.value * 1.2
                                }
                            }
                }
            }
            Text(charName)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50, alignment: .center)
            .rotationEffect(.degrees(-45))
            .lineLimit(2)
            .padding(.top, 16)
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
            .frame(width:140, height:140)
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

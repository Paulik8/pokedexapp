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
    var id: Int?
    @State var capsuleHeight1: CGFloat = 0
    @State var capsuleHeight2: CGFloat = 0
    @State var capsuleHeight3: CGFloat = 0
    @ObservedObject var viewModel: RateNewViewModel = RateNewViewModel()
    
    func updateViewModel() {
        if let viewModelId = viewModel.id {
            return
        } else {
            viewModel.id = id
        }
    }
    
    var body: some View {
        updateViewModel()
        return ZStack {
            VStack {
                ImageView(withURL: viewModel.name).padding(.bottom, 30)
                
                HStack(spacing: 16) {
                    
                BarView(value: capsuleHeight1)
                    .onReceive(viewModel.didChange) { data in
                        self.capsuleHeight1 = CGFloat(integerLiteral: 150)
                }
                BarView(value: capsuleHeight2)
                    .onReceive(viewModel.didChange) { data in
                        self.capsuleHeight2 = CGFloat(integerLiteral: data.capsuleHeight)
                }
                BarView(value: capsuleHeight3)
                    .onReceive(viewModel.didChange) { data in
                        self.capsuleHeight3 = CGFloat(integerLiteral: 120)
                }
//                ZStack(alignment: .bottom) {
//                    Capsule().frame(width: 30, height: 200).foregroundColor(.gray)
//                    Capsule().frame(width: 30, height: capsuleHeight)
//                        .animation(.linear(duration: 1))
//                        .onReceive(viewModel.didChange) { data in
//                            self.capsuleHeight = CGFloat(integerLiteral: data.capsuleHeight)
//                    }
                }
                PageControl(numberPages: viewModel.numberOfPages)
                }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .background(SwiftUI.Color.white)
            .cornerRadius(30)
            .padding(EdgeInsets(top: topInset!, leading: 0, bottom: 0, trailing: 0))
            .animation(.default)
            
            
            
//            Button(action: {
//                self.viewModel.name = "keklik"
//            }) {
//                Text("Change name")
//            }
        }
        .edgesIgnoringSafeArea(.all)
        
//        .animation(.spring())
            
//        Text(viewModel.pokemonStats?.stats[0].stat?.name ?? "kek")
        
//        }
//        .onDisappear(perform: {
//            self.viewModel.removeObservable()
//        })
    }
}

struct BarView: View {
    
    var value: CGFloat
    
    var body: some View {
        ZStack (alignment: .bottom) {
            Capsule().frame(width: 30, height: 200).foregroundColor(SwiftUI.Color(red: 240/255, green: 240/255, blue: 240/255, opacity: 1))
            Capsule().frame(width: 30, height: value).foregroundColor(.gray)
                .animation(.linear(duration: 0.8))
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

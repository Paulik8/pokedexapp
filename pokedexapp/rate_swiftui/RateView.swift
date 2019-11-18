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
                ZStack(alignment: .bottom) {
                    Capsule().frame(width: 30, height: 200)
                    Capsule().frame(width: 30, height: 100).foregroundColor(.white)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .top)
            .background(SwiftUI.Color.orange)
            .cornerRadius(30)
            .padding(EdgeInsets(top: topInset!, leading: 0, bottom: 0, trailing: 0))
            
            
            
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

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        VStack {
            Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:200, height:200)
            .cornerRadius(100)
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

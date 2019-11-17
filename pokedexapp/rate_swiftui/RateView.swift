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
        return VStack  {
            Text("Your score is \(viewModel.name)")
            Button(action: {
                self.viewModel.name = "keklik"
            }) {
                Text("Change name")
            }
        }
            
//        Text(viewModel.pokemonStats?.stats[0].stat?.name ?? "kek")
//            Card(text: "\(viewModel?.pokemonStats?.id)")
//            .edgesIgnoringSafeArea(.all)
//            .padding(EdgeInsets(top: topInset!, leading: 0, bottom: 0, trailing: 0))
//        }
//        .onDisappear(perform: {
//            self.viewModel.removeObservable()
//        })
    }
}

#if DEBUG

struct RatePreviews: PreviewProvider {
    
    static var previews: some View {
        RateView()
    }
}

#endif

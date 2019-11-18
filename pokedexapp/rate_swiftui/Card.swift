//
//  Card.swift
//  pokedexapp
//
//  Created by Paulik on 15/11/2019.
//  Copyright © 2019 Paulik. All rights reserved.
//

import SwiftUI

struct Card: View {
    
    var text: String?
    
    var body: some View {
        VStack {
            Text(text ?? "")
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(SwiftUI.Color.orange)
        .cornerRadius(30)
    }
    
}

#if DEBUG

struct Card_Previews: PreviewProvider {

    static var previews: some View {
        Card()
    }
}

#endif

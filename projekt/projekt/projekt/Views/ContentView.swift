//
//  ContentView.swift
//  projekt
//
//  Created by Jagoda Krystosiak on 27/05/2022.
//  Copyright © 2022 pl. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    var main_color: Color = Color(red: 0.3019, green: 0.5725, blue: 0.9882)
    @State private var isActive: Bool = false
    
    var body: some View {
            NavigationView {
                VStack {
                    
                    Image("logo")
                    .resizable()
                    .frame(width: 220.0, height: 400.0)
                    
                    Text("<Dress Code/>")
                        .font(.system(size: 50))
                        .foregroundColor(.black)
                        .navigationBarTitle("Strona główna", displayMode: .inline).navigationBarHidden(true)
                    
                    NavigationLink(destination: DressesView(rootIsActive: $isActive), isActive: $isActive, label: {
                        Text("Sukienki")
                            .font(.system(size: 20))
                            .frame(width: 250, height: 20)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                            .foregroundColor(main_color)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(main_color, lineWidth: 2))
                    }).isDetailLink(false)
                    
                    NavigationLink(destination: OrdersView(), label: {
                        Text("Zamówienia")
                            .font(.system(size: 20))
                            .frame(width: 250, height: 20)
                            .padding()
                            .background(main_color)
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .overlay(RoundedRectangle(cornerRadius: 20).stroke(main_color, lineWidth: 2))
                    })
                }
            }
        
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

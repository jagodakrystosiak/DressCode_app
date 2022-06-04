//
//  CustomSizeView.swift
//  Lab11
//
//  Created by Jagoda Krystosiak on 28/05/2022.
//  Copyright © 2022 pl. All rights reserved.
//

import SwiftUI

enum ActiveAlert {
    case bad_size, not_all_sizes
}

struct CustomSizeView: View {
    
    var main_color: Color = Color(red: 0.3019, green: 0.5725, blue: 0.9882)
    var light_gray: Color = Color(red: 0.8784, green: 0.8784, blue: 0.8862)
    
    @Binding var showCustomSize: Bool
    @Binding var customSize: String
    
    @State private var sizes: [String] = ["","","","","",""]
    @State private var showingAlert = false
    @State private var activeAlert: ActiveAlert = .bad_size
    
    var body: some View {
        
        HStack{
            Image("size").resizable()
                .frame(width: 121, height: 480)
            VStack{
                Text("Wprowadź swoje wymiary w centymetrach")
                    .font(.system(size: 22))
                TextField("wysokość biustu", text: $sizes[0])
                    .keyboardType(.decimalPad)
                    .frame(width: 200, height: 30)
                    .border(light_gray, width: 1)
                TextField("obwód w biuście", text: $sizes[1])
                    .keyboardType(.decimalPad)
                    .frame(width: 200, height: 30)
                    .border(light_gray, width: 1)
                TextField("obwód pod biustem", text: $sizes[2])
                    .keyboardType(.decimalPad)
                    .frame(width: 200, height: 30)
                    .border(light_gray, width: 1)
                TextField("obwód w pasie", text: $sizes[3])
                    .keyboardType(.decimalPad)
                    .frame(width: 200, height: 30)
                    .border(light_gray, width: 1)
                TextField("obwód w biodrach 1", text: $sizes[4])
                    .keyboardType(.decimalPad)
                    .frame(width: 200, height: 30)
                    .border(light_gray, width: 1)
                TextField("obwód w biodrach 2", text: $sizes[5])
                    .keyboardType(.decimalPad)
                    .frame(width: 200, height: 30)
                    .border(light_gray, width: 1)
                Button(action: filterSize, label: {
                    Text("Gotowe")
                        .font(.system(size: 20))
                        .frame(width: 200, height: 20)
                        .padding()
                        .background(main_color)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(main_color, lineWidth: 2))
                })
                    
            }.alert(isPresented: $showingAlert){
                switch activeAlert {
                            case .bad_size:
                                return Alert(title: Text("Błąd!"), message: Text("Nieprawidłowe wymiary"))
                            case .not_all_sizes:
                                return Alert(title: Text("Błąd!"), message: Text("Nie podano wszystkich wymiarów"))
                            }
            }
        }
    }
    
    private func filterSize(){
        customSize = ""
        var size_table: [String] = []
        let size_name: [String] = ["Wysokość biustu", "Obwód w biuście","Obwód pod biustem", "Obwód w pasie","Obwód w biodrach 1", "Obwód w biodrach 2"]
        for i in 0..<sizes.count{
            let filter_number = sizes[i].filter(\.isNumber)
            if sizes[i].range(of: ".*[^0-9].*", options: .regularExpression) != nil {
                activeAlert = .bad_size
                showingAlert = true
            } else if(filter_number == ""){
                activeAlert = .not_all_sizes
                showingAlert = true
            } else {
                size_table.append(filter_number)
            }
        }
         if(sizes.count == size_table.count){
             for i in 0..<size_table.count {
                 customSize += "\(size_name[i]): \(size_table[i])cm\n"
             }
             showCustomSize.toggle()
         }
    }
}

struct CustomSizeView_Previews: PreviewProvider {
    static var previews: some View {
        CustomSizeView(showCustomSize: .constant(false), customSize: .constant(""))
    }
}

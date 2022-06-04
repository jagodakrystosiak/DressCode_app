//
//  DressView.swift
//  Lab11
//
//  Created by Jagoda Krystosiak on 27/05/2022.
//  Copyright © 2022 pl. All rights reserved.
//

import SwiftUI

struct DressView: View {
    
    var main_color: Color = Color(red: 0.3019, green: 0.5725, blue: 0.9882)
    var number_of_img: [String:Int] = ["Afrodyta":2,
                                       "Ananke":5,
                                       "Atena":4,
                                       "Demeter":5,
                                       "Dione":2,
                                       "Eurybia":6,
                                       "Hera":3,
                                       "Nemezis":2,
                                       "Reja":4,
                                       "Temida":2]
    
    @Binding var selectedDress: Dress?
    @Binding var rootIsActive: Bool
    @State private var dress_img: String = ""
    @State var location: CGPoint = CGPoint(x:146, y:210)
    
    var body: some View {
        VStack {
            
            Text(selectedDress!.name!)
                .navigationBarTitle("Podgląd", displayMode: .inline)
                .font(.title)
            
            Image(dress_img)
                .resizable()
                .frame(width: 267.0, height: 400.0)
                .position(location)
                .scaledToFit()
                .gesture(TapGesture()
                            .onEnded(){
                    changeImage()
                })
                .gesture(DragGesture().onChanged{
                    value in
                    self.location = value.location
                }.onEnded(){_ in
                    self.location = CGPoint(x:146, y:210)
                })
                .onAppear(){
                    dress_img = selectedDress!.name! + String(1)
                }

            Text("Cena: \(String(format: "%.2f", selectedDress!.price)) zł")
            
            NavigationLink(destination: FormView(selectedDress: $selectedDress, shouldPopToRootView: $rootIsActive), label: {
            Text("Zamów")
                    .font(.system(size: 20))
                    .frame(width: 250, height: 20)
                    .padding()
                    .background(main_color)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(main_color, lineWidth: 2))
                    .padding()
            }).isDetailLink(false)
        }
    }
    
    private func changeImage(){
        for (dress, i) in number_of_img {
            if(dress == selectedDress!.name!){
                let img_number_string =  String(dress_img[dress_img.index(dress_img.startIndex, offsetBy: dress.count)])
                var img_number = Int(img_number_string)!
                if(img_number != i){
                    img_number+=1
                } else {
                    img_number = 1
                }
                dress_img = selectedDress!.name! + String(img_number)
            }
        }
    }
}

struct DressView_Previews: PreviewProvider {
    static var previews: some View {
        DressView(selectedDress: .constant(nil), rootIsActive: .constant(false))
    }
}

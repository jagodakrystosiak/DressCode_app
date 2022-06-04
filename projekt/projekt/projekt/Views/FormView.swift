//
//  FormView.swift
//  Lab11
//
//  Created by Jagoda Krystosiak on 27/05/2022.
//  Copyright © 2022 pl. All rights reserved.
//

import SwiftUI
import CoreData

enum Colors: String, CaseIterable{
    case biały, czerwony, niebieski, fioletowy

    func displayColor() -> String {
        self.rawValue.capitalized
    }
}

struct FormView: View {
    
    var main_color: Color = Color(red: 0.3019, green: 0.5725, blue: 0.9882)
    var light_gray: Color = Color(red: 0.8784, green: 0.8784, blue: 0.8862)
    @State private var fabrics_price: [String:Double] = [
        "Aksamit":120.00,
        "Atłas":44.00,
        "Bawełna":68.00,
        "Ecoskóra":120.00,
        "Jeans":120.00,
        "Poliester":40.00,
        "Satyna":64.00,
        "Wiskoza":156.00,
        "Polar":140.00,
        "Welur":100.00 ]
    
    @Binding var selectedDress: Dress?
    @Binding var shouldPopToRootView: Bool
    @State private var selectedFabric: Fabric?
    
    @State private var selectedColor = Colors.biały
    @State private var selectedSize: Double = 32.00
    @State private var customSize: String = ""
    @State private var isEditing: Bool = false
    @State private var showCustomSize: Bool = false
    @State private var showingAlert: Bool = false
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Fabric.name, ascending: true)],
        animation: .default)
    
    private var fabrics: FetchedResults<Fabric>
    
    
    var body: some View {
        VStack {
            
            Text("\(selectedDress!.name!)")
                .navigationBarTitle("Zamówienie", displayMode: .inline)
                .font(.system(size: 22))
            
            VStack(alignment: .leading){
                HStack {
                    Text("Materiał:")
                    Picker(selection: $selectedFabric, label: Text("Wybierz materiał"), content: {
                        ForEach(fabrics) {fabric in
                            Text("\(fabric.name!) \(String(format: "%.2f", fabric.price)) zł").tag(fabric as Fabric?)
                        }
                    }
                    ).pickerStyle(DefaultPickerStyle())
                        .font(.system(size: 20))
                        .frame(width: 200, height: 30)
                    
                    if(fabrics.count == 0){
                        Button(action:addFabrics){
                            Text("Dodaj materiały")
                        }
                    }
                }
                
                HStack {
                    Text("Kolor:")
                    Picker(selection: $selectedColor, content: {
                        ForEach(Colors.allCases, id: \.self) { color in
                            Text(color.displayColor())
                        }
                    }, label: {
                        Text("Kolor")
                    }).colorMultiply(color(selectedColor)).pickerStyle(SegmentedPickerStyle())
                    
                }
                
                HStack {
                    Text("Rozmiar: ")
                    VStack {
                        Slider(value: $selectedSize, in: 32...46, step: 2, onEditingChanged: {
                            editing in isEditing=editing
                        })
                        Text("\(String(format: "%2.0f", selectedSize))").foregroundColor(isEditing ? .red : .blue)
                    }
                }
            }.padding()
            
            Button(action: {self.showCustomSize.toggle()}, label: {
                Text("Podaj swoje wymiary")
                    .font(.system(size: 18))
                    .frame(width: 200, height: 10)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .foregroundColor(main_color)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(main_color, lineWidth: 2))
            })
                .sheet(isPresented: $showCustomSize){
                    CustomSizeView(showCustomSize: $showCustomSize, customSize: $customSize)
                }
            
            if(customSize != ""){
                Text("Wybrane rozmiary:").font(.system(size: 18)).fontWeight(.bold)
                Text(customSize)
            }
            
            if(selectedDress != nil){
                Text("Cena sukienki: \(String(format: "%0.2f", selectedDress!.price))zł")
            }
            
            if(selectedFabric != nil){
                Text("Cena materiału: \(String(format: "%0.2f", selectedFabric!.price))zł")
                if let overallPrice = selectedDress!.price + selectedFabric!.price {
                    Text("Razem: \(String(format: "%0.2f", overallPrice))zł").font(.system(size: 18)).fontWeight(.bold)
                }
            }
            
            Button(action: {
                if(selectedFabric != nil){
                    addOrder()
                    self.shouldPopToRootView = false
                } else {
                    showingAlert.toggle()
                }
            }, label: {
                Text("Złóż zamówienie")
                    .font(.system(size: 20))
                    .frame(width: 250, height: 20)
                    .padding()
                    .background(main_color)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(main_color, lineWidth: 2))
            })
            
        }.alert(isPresented: $showingAlert){
            Alert(title: Text("Błąd!"), message: Text("Materiał nie został wybrany"))
        }
    }
    
    private func addFabrics(){
        for (fabric, price) in fabrics_price{
            let newFabric = Fabric(context: viewContext)
            newFabric.name = fabric
            newFabric.price = Double(price)
            do {
                try viewContext.save() } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    private func color(_ selected: Colors) -> Color {
            switch selected {
            case .biały:
                return .white
            case .czerwony:
                return .red
            case .niebieski:
                return .blue
            case .fioletowy:
                return .purple
            }
    }
    
    private func addOrder(){
        let newOrder = Order(context: viewContext)
        newOrder.id = Int16.random(in: 10000..<32767)
        newOrder.date = Date()
        newOrder.dress = selectedDress
        newOrder.fabric = selectedFabric
        if(customSize != ""){
            newOrder.size = customSize
        } else {
            newOrder.size = "Standardowy rozmiar: \(selectedSize)"
        }
        do {
        try viewContext.save() } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError),\(nsError.userInfo)")
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView(selectedDress: .constant(nil), shouldPopToRootView: .constant(false))
    }
}

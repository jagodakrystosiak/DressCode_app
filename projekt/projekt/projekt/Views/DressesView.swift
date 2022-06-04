//
//  DressesView.swift
//  Lab11
//
//  Created by Jagoda Krystosiak on 27/05/2022.
//  Copyright © 2022 pl. All rights reserved.
//

import SwiftUI
import CoreData

struct DressesView: View {
    
    var main_color: Color = Color(red: 0.3019, green: 0.5725, blue: 0.9882)
    @Binding var rootIsActive: Bool
    @State private var dresses_price: [String:Double] = [
        "Afrodyta":349.9,
        "Ananke":249.99,
        "Atena":299.99,
        "Demeter":399.99,
        "Dione":279.99,
        "Eurybia":199.99,
        "Hera":149.99,
        "Nemezis":420.00,
        "Reja":239.99,
        "Temida":249.99 ]
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dress.name, ascending: true)],
        animation: .default)
    
    private var dresses: FetchedResults<Dress>
    
    var body: some View {
        VStack {
            
            Text("Greckie boginie")
                .navigationBarTitle("Sukienki", displayMode: .inline)
                .font(.title)
            
            List {
                ForEach(dresses) { dress in
                    NavigationLink {
                        DressView(selectedDress: .constant(dress as Dress?), rootIsActive: $rootIsActive)
                    } label: {
                        Text("\(dress.name!)")
                    }.isDetailLink(false)
                }
                //.onDelete(perform: deleteDress)
            }
            
            if(dresses.count == 0){
                Button(action:addDresses){
                    Text("Dodaj sukienki")
                        .font(.system(size: 20))
                        .frame(width: 250, height: 20)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(20)
                        .foregroundColor(main_color)
                        .overlay(RoundedRectangle(cornerRadius: 20).stroke(main_color, lineWidth: 2))
                }
            }
        }
    }
    
    private func addDresses(){
        for (dress, price) in dresses_price{
            let newDress = Dress(context: viewContext)
            newDress.name = dress
            newDress.price = Double(price)
            do {
                try viewContext.save() } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteDress(offsets: IndexSet) {
        withAnimation {
            offsets.map { dresses[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct DressesView_Previews: PreviewProvider {
    static var previews: some View {
        DressesView(rootIsActive: .constant(false))
    }
}


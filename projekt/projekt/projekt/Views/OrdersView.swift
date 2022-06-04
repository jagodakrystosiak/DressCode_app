//
//  OrdersView.swift
//  Lab11
//
//  Created by Jagoda Krystosiak on 27/05/2022.
//  Copyright © 2022 pl. All rights reserved.
//

import SwiftUI
import CoreData

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct OrdersView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.id, ascending: true)],
        animation: .default)
    
    private var orders: FetchedResults<Order>
    
    var body: some View {
        List {
            ForEach(orders) { order in
                let id_string = String(order.id)
                let overallPrice = order.dress_price + order.fabric_price
                NavigationLink {
                    Text("Numer zamówienia: \(id_string)")
                        .font(.title)
                        .navigationBarTitle("Informacje", displayMode: .inline)
                    VStack(alignment: .leading){
                        Text("Data zamówienia: \(order.date!, formatter: itemFormatter)")
                        Text("Wybrana sukienka: \(order.dress_name)")
                        Text("Wybrany materiał: \(order.fabric_name)")
                        Text("Wybrany rozmiar: \(order.size!)")
                    }.padding()
                    Text("Razem: \(String(format: "%0.2f", overallPrice))zł").fontWeight(.bold)
                } label: {
                    Text("\(order.date!, formatter: itemFormatter)")
                }
            }
            .onDelete(perform: deleteOrder)
            .navigationBarTitle("Zamówienia", displayMode: .inline)
        }
    }
    
    private func deleteOrder(offsets: IndexSet) {
        withAnimation {
        offsets.map { orders[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save() }
        catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        }
        
    }
    
    
}

struct OrdersView_Previews: PreviewProvider {
    static var previews: some View {
        OrdersView()
    }
}

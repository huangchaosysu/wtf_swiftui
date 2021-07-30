//
//  WRCountryPicker.swift
//  weridego
//
//  Created by chao huang on 2021/7/30.
//

import SwiftUI

struct CountryPicker: View {
    @State private var selected = "+86"
    var body: some View {
        NavigationLink("\(selected)", destination: CustomPickerView(selected: $selected))
    }
}

struct CustomPickerView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var selected: String
    
    var body: some View {
        List{
            renderList()
        }
        .navigationTitle("选择国家/地区")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func renderList() -> some View {
        let data = loadCountries()

        return ForEach(data.keys.sorted(), id: \.self) { k  in
            Section(header: Text(k.isEmpty ? "常用" : k )) {
                ForEach(data[k]!, id: \.self) { v in
                    HStack {
                        Text(v.split(separator: "+")[0])
                        Spacer()
                        Text("+" + String(v.split(separator: "+")[1]))
                    }
                    .background(Color.white)
                    .onTapGesture {
                        selected = "+\(v.split(separator: "+")[1])"
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func loadCountries() -> [String: [String]] {
        let filename = "sortedName\(WRHelper.getCurrentLanguage().uppercased())"
        let path = Bundle.main.path(forResource: filename, ofType: "plist")
        let data = try! Data(contentsOf: URL(fileURLWithPath: path!))
        let plist = try! PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil) as! [String: [String]]
        
        return plist
    }
}


//
//  ContentView.swift
//  ResignTest
//
//  Created by Krisztián Gödrei on 15/02/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let profile = MobileProvision.read() {
            VStack(alignment: .leading) {
                Text("Provisining Profile:")
                Text("Name: " + profile.name)
                Text("Type: " + profile.distributionType())
                Text("- has provisioned devices: " + (profile.provisionedDevices.isEmpty ? "false" : "true"))
                Text("- provisions all devices: " + (profile.provisionsAllDevices ?? false ? "true" : "false"))
                Text("- get task allow: " + (profile.entitlements.getTaskAllow ? "true" : "false"))
            }
            .padding()
        } else {
            Text("Failed to read profile")
        }
    }
}


#Preview {
    ContentView()
}

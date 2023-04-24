//
//  ArtApp.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import SwiftUI

@main
struct ArtApp: App {
    @StateObject var departmentVM = DepartmentViewModel()
    @StateObject var artworkListVM = ArtworkViewModel()

    var body: some Scene {
        
        WindowGroup {
            ArtHomePage()
                .environmentObject(departmentVM)
                .environmentObject(artworkListVM)
        }
    }
}

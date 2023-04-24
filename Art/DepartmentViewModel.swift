//
//  DepartmentViewModel.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import Foundation

@MainActor
class DepartmentViewModel: ObservableObject {
    @Published var departments: [Department] = []
    @Published var isLoading = false
    
    private struct Results: Codable {
        var departments: [Department] = []
    }
    
    var urlString = "https://collectionapi.metmuseum.org/public/collection/v1/departments"
    
    func getData() async {
        isLoading = true
        print("We are accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not convert \(urlString) to a URL")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let results = try JSONDecoder().decode(Results.self, from: data)
                self.departments = results.departments
                print("JSON returned: \n\(self.departments)")
                isLoading = false
                
            } catch {
                print("ERROR: Could not decode data")
                isLoading = false
            }
        } catch {
            print("ERROR: Could not get data from \(urlString). \(error.localizedDescription)")
            isLoading = false
        }
    }
}

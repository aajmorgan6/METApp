//
//  ArtworkViewModel.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import Foundation

@MainActor
class ArtworkViewModel: ObservableObject {
    @Published var artworksId: [Int] = []
    @Published var artwork = Artwork()
    @Published var isLoading = false
    @Published var artworkOfTheDay = Artwork()
    @Published var artOfDayLoading = false
    
    var lastDeptId = 0
    
    private struct Result: Codable {
        var objectIDs: [Int] = []
    }
    
    func getDataOfArtwork(artID: Int) async {
        isLoading = true
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects/\(artID)"
        print("We are accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not convert \(urlString) to a URL")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let returned = try JSONDecoder().decode(Artwork.self, from: data)
                self.artwork = returned
                print("JSON returned: \n\(self.artwork)")
//                isLoading = false
                
            } catch {
                print("ERROR: Could not decode data")
//                isLoading = false
            }
        } catch {
//            isLoading = false
            print("ERROR: Could not get data from \(urlString). \(error.localizedDescription)")
        }
    }
    
    func getAllArtwork() async {
        var dept = Int.random(in: 1...21)
        while dept == 2 || dept == 20 {
            dept = Int.random(in: 1...21)
        }
        lastDeptId = dept
        isLoading = true
        artworksId = []
        artwork = Artwork()
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=\(dept)"
        print("We are accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not convert \(urlString) to a URL")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                self.artworksId = result.objectIDs
                print("JSON returned: \n\(result.objectIDs)")
                await loadArt()
                isLoading = false
                
            } catch {
                print("ERROR: Could not decode data")
                isLoading = false
            }
        } catch {
            print("ERROR: Could not get data from \(urlString). \(error.localizedDescription)")
            isLoading = false
        }
        
        isLoading = false
    }
    
    func getDatabyDepartment(departmentID: Int) async {
        isLoading = true
        lastDeptId = departmentID
        artworksId = []
        artwork = Artwork()
        let urlString = "https://collectionapi.metmuseum.org/public/collection/v1/objects?departmentIds=\(departmentID)"
        print("We are accessing the url \(urlString)")
        guard let url = URL(string: urlString) else {
            print("ERROR: Could not convert \(urlString) to a URL")
            isLoading = false
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            do {
                let result = try JSONDecoder().decode(Result.self, from: data)
                self.artworksId = result.objectIDs
                print("JSON returned: \n\(result.objectIDs)")
                await loadArt()
                isLoading = false
                
            } catch {
                print("ERROR: Could not decode data")
                isLoading = false
            }
        } catch {
            print("ERROR: Could not get data from \(urlString). \(error.localizedDescription)")
            isLoading = false
        }
        
        isLoading = false
    }
    
    func loadArt() async {
        guard artworksId.count != 0 else {
            await getDatabyDepartment(departmentID: lastDeptId)
            return
        }
        repeat {
            let id = artworksId.randomElement()!
            await getDataOfArtwork(artID: id)
        } while self.artwork.primaryImage == ""
        isLoading = false
    }
    
    func saveArt() {
        let path = URL.documentsDirectory.appending(component: "artOfDayArt")
        let data = try? JSONEncoder().encode(artworkOfTheDay)
        do {
            try data?.write(to: path)
        } catch {
            print("   ERROR: Could not save data \(error.localizedDescription)")
        }
    }
    
    func saveDay() async {
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        let path = URL.documentsDirectory.appending(component: "artOfDayDate")
        let data = try? JSONEncoder().encode(formattedDate)
        do {
            try data?.write(to: path)
        } catch {
            print("   ERROR: Could not save data \(error.localizedDescription)")
        }
        await getAllArtwork()
        artworkOfTheDay = artwork
        saveArt()
    }
    
    func loadArtOfDay() {
        let path = URL.documentsDirectory.appending(component: "artOfDayArt")
        guard let data = try? Data(contentsOf: path) else {return}
        do {
            artworkOfTheDay = try JSONDecoder().decode(Artwork.self, from: data)
        } catch {
            print(" ERROR: Could not load data \(error.localizedDescription)")
        }
    }
    
    func loadDay() async {
        artOfDayLoading = true
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd"
        let formattedDate = format.string(from: date)
        let path = URL.documentsDirectory.appending(component: "artOfDayDate")
        guard let data = try? Data(contentsOf: path) else {return}
        do {
            let today = try JSONDecoder().decode(String.self, from: data)
            if "\(formattedDate)" == "\(today)" {
                loadArtOfDay()
            } else {
                await saveDay()
            }
            artOfDayLoading = false
        } catch {
            print(" ERROR: Could not load data \(error.localizedDescription)")
            artOfDayLoading = false
        }
    }
    
    func guessYear(year: String) -> Bool {
        let newYear = Int(year)
        return true
    }
    
}

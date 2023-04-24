//
//  ArtworkDetailView.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import SwiftUI

struct ArtworkDetailView: View {
    
//    @State var artwork: Artwork
    @EnvironmentObject var artworkVM: ArtworkViewModel
    @State var department: Department
    
    var body: some View {
        VStack {
            if !artworkVM.isLoading {
                Group {
                    Text(artworkVM.artwork.department ?? "No Department found")
                        .bold()
                        .padding(.bottom, 8)
                    Text(artworkVM.artwork.title ?? "No Title found")
                        .italic()
                        .padding(.bottom, 8)
                    if artworkVM.artwork.artistDisplayName != "" {
                        Text("By: \(artworkVM.artwork.artistDisplayName ?? "Unknown")")
                    }
                    Text("\(artworkVM.artwork.objectDate?.count == 4 ? "Year" : "Period"): \(artworkVM.artwork.objectDate ?? "Unknown")")
                }
                .font(.title2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                AsyncImage(url: URL(string: artworkVM.artwork.primaryImage ?? "")) {image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                        .shadow(radius: 15)
//                        .animation(.default, value: image)
                    
                } placeholder: {
                    ProgressView()
                        .scaleEffect(3)
                }
                
                Spacer()
                
                Button("Next Image") {
                    if department.departmentId == 0 {
                        Task {
                            await artworkVM.getAllArtwork()
                        }
                    } else {
                        Task {
                            await artworkVM.loadArt()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                
            } else {
                ProgressView()
                    .scaleEffect(4)
            }
            
        }
        .onAppear {
            if department.departmentId != 0 {
                Task {
                    await artworkVM.getDatabyDepartment(departmentID: department.departmentId)
                }
            } else {
                Task {
                    await artworkVM.getAllArtwork()
                }
            }
        }
        .padding()
    }
}

struct ArtworkDetailView_Previews: PreviewProvider {
    static var previews: some View {
//        ArtworkDetailView(artworkId: Artwork(objectId: 437133, title: "This Is America"))
//        ArtworkDetailView(artworkId: 341346)
        ArtworkDetailView(department: Department(departmentId: 0, displayName: "America"))
            .environmentObject(ArtworkViewModel())
    }
}

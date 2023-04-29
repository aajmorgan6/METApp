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
    @State private var easeIn = false
    
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
                .onAppear {
                    easeIn = false
                }
                .font(.title2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                
                Spacer()
                
                AsyncImage(url: URL(string: artworkVM.artwork.primaryImage ?? "")) { phase in
                    if let image = phase.image {
                        Spacer()
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .shadow(radius: 15)
                        Spacer()
                    } else if phase.error != nil {
                        //                        RoundedRectangle(cornerRadius: 15)
                        //                            .foregroundColor(.clear)
                        //                            .frame(height: .infinity)
                        Image(systemName: "questionmark.square.dashed")
                            .resizable()
                            .scaledToFit()
                        Text("We're sorry, we couldn't load the image 😔")
                        
                    } else {
                        Spacer()
                        ProgressView()
                            .scaleEffect(3)
                            .multilineTextAlignment(.center)
                        Text("Loading your image...")
                            .padding(.top, 40)
                            .animation(.linear(duration: 3.0), value: phase.image)
                        Spacer()
                    }
                }
                
                if artworkVM.artwork.objectURL != "" {
                    VStack {
                        Link("More about the Piece", destination: URL(string: artworkVM.artwork.objectURL ?? "https://www.metmuseum.org/")!)
                            .padding()
                        ShareLink(item: URL(string: artworkVM.artwork.objectURL ?? "https://www.metmuseum.org/")!) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    
                } else if artworkVM.artwork.linkResource != "" {
                    VStack {
                        Link("More about the Piece", destination: URL(string: artworkVM.artwork.linkResource ?? "https://www.metmuseum.org/")!)
                            .padding()
                        ShareLink(item: URL(string: artworkVM.artwork.linkResource ?? "https://www.metmuseum.org/")!)
                    }
                } else {
                    Link("Visit the MET!", destination: URL(string: "https://www.metmuseum.org/")!)
                }
                
                Button("Next Image") {
                    easeIn = true
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
                .padding(.top)
                
            } else {
                VStack {
                    Spacer()
                    ProgressView()
                        .scaleEffect(4)
                    
                    Text("Loading the next Piece...")
                        .font(.title2)
                        .animation(.easeIn(duration: 3.0), value: artworkVM.isLoading)
                        .padding(.top, 40)
                    //                        .onAppear {
                    //                            withAnimation(.linear(duration: 3.0)) {
                    //                                easeIn.toggle()
                    //                            }
                    //                        }
                        .animation(.default, value: artworkVM.isLoading)
                    Spacer()
                }
                .animation(.linear(duration: 2.0), value: artworkVM.isLoading)
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

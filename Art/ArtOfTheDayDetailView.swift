//
//  ArtOfTheDayDetailView.swift
//  Art
//
//  Created by AJ Morgan on 4/20/23.
//

import SwiftUI

struct ArtOfTheDayDetailView: View {
    
    @EnvironmentObject var artworkVM: ArtworkViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if !artworkVM.artOfDayLoading {
                    Group {
                        Text(artworkVM.artworkOfTheDay.department ?? "No Department found")
                            .bold()
                            .padding(.bottom, 8)
                        Text(artworkVM.artworkOfTheDay.title ?? "No Title found")
                            .italic()
                            .padding(.bottom, 8)
                        if artworkVM.artworkOfTheDay.artistDisplayName != "" {
                            Text("By: \(artworkVM.artworkOfTheDay.artistDisplayName ?? "Unknown")")
                        }
                        Text("\(artworkVM.artworkOfTheDay.objectDate?.count == 4 ? "Year" : "Period"): \(artworkVM.artworkOfTheDay.objectDate ?? "Unknown")")
                    }
                    .font(.title2)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    Spacer()
                    
                    AsyncImage(url: URL(string: artworkVM.artworkOfTheDay.primaryImage ?? "")) {image in
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                            .shadow(radius: 15)
                            .animation(.default, value: image)
                        
                    } placeholder: {
                        ProgressView()
                            .scaleEffect(3)
                    }
                    
                    Spacer()
                    
                    if artworkVM.artworkOfTheDay.objectURL != "" {
                        VStack {
                            Link("More about the Piece", destination: URL(string: artworkVM.artworkOfTheDay.objectURL ?? "https://www.metmuseum.org/")!)
                                .padding(.vertical, 4)
                            ShareLink(item: URL(string: artworkVM.artworkOfTheDay.objectURL ?? "https://www.metmuseum.org/")!) {
                                Label("Share", systemImage: "square.and.arrow.up")
                                    
                            }
                            .padding(.bottom, 4)
                        }
                        
                    } else if artworkVM.artworkOfTheDay.linkResource != "" {
                        VStack {
                            Link("More about the Piece", destination: URL(string: artworkVM.artworkOfTheDay.linkResource ?? "https://www.metmuseum.org/")!)
    //                            .padding(.bottom, 2)
                            ShareLink(item: URL(string: artworkVM.artworkOfTheDay.linkResource ?? "https://www.metmuseum.org/")!)
                        }
                    }
                    
                    Link("Visit the MET!", destination: URL(string: "https://www.metmuseum.org/")!)
                    Spacer()
                } else {
                    ProgressView()
                        .scaleEffect(4)
                }
            }
            .onAppear {
                Task {
                    await artworkVM.loadDay()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}


struct ArtOfTheDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArtOfTheDayDetailView()
                .environmentObject(ArtworkViewModel())
        }
    }
}

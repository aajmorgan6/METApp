//
//  ArtOfTheDayDetailView.swift
//  Art
//
//  Created by AJ Morgan on 4/20/23.
//

import SwiftUI

struct ArtOfTheDayDetailView: View {
    
    @EnvironmentObject var artworkVM: ArtworkViewModel
    
    var body: some View {
        VStack {
            if !artworkVM.artOfDayLoading {
                Group {
                    Text(artworkVM.artworkOfTheDay.department ?? "No Department found")
                        .bold()
                        .padding(.bottom, 8)
                    Text(artworkVM.artworkOfTheDay.title ?? "No Title found")
                        .italic()
                        .padding(.bottom, 8)
                    Text("By: \(artworkVM.artworkOfTheDay.artistDisplayName ?? "Unknown")")
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
                
                if artworkVM.artworkOfTheDay.artistWikidata_URL != "" {
                    Link("More about the Artist", destination: URL(string: artworkVM.artworkOfTheDay.artistWikidata_URL ?? "") ?? URL(string: "https://www.metmuseum.org/")!)
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
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}


struct ArtOfTheDayDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArtOfTheDayDetailView()
            .environmentObject(ArtworkViewModel())
    }
}

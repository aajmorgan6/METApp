//
//  QuizDetailView.swift
//  Art
//
//  Created by AJ Morgan on 4/20/23.
//

import SwiftUI

struct QuizDetailView: View {
    
    @EnvironmentObject var artworkVM: ArtworkViewModel
    @State var department: Department
    @State private var guessYear = ""
    @State private var msgString = ""
    @State private var msgColor = Color.green
    @FocusState private var focus: Bool
    
    var body: some View {
        VStack {
            Text(artworkVM.artwork.title ?? " ")
                .font(.title2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(3)
            AsyncImage(url: URL(string: artworkVM.artwork.primaryImage ?? "")) {image in
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
            
            TextField("Guess the Year", text: $guessYear)
                .focused($focus)
                .keyboardType(.decimalPad)
            
            Button("Enter Guess") {
                focus.toggle()
                let correct = artworkVM.guessYear(year: guessYear)
                if correct {
                    msgString = "Correct! This was from \(artworkVM.artwork.objectDate ?? "")"
                    msgColor = .green
                } else {
                    msgString = "Incorrect. This was from \(artworkVM.artwork.objectDate ?? "")"
                    msgColor = .red
                }
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Text(msgString)
                .font(.title)
                .foregroundColor(msgColor)
            
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
        .navigationBarTitleDisplayMode(.inline)
        .padding()
    }
}

struct QuizDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            QuizDetailView(department: Department(departmentId: 0, displayName: "America"))
                .environmentObject(ArtworkViewModel())
        }
    }
}

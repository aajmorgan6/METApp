//
//  QuizDetailView.swift
//  Art
//
//  Created by AJ Morgan on 4/20/23.
//

import SwiftUI

struct QuizDetailView: View {
    
    enum Century: String, CaseIterable {
        case BC, BCE
    }
    
    enum Guess: String, CaseIterable {
        case year, department
    }
        
    @EnvironmentObject var artworkVM: ArtworkViewModel
    @EnvironmentObject var departmentVM: DepartmentViewModel
    @State var department: Department
    @State private var guessYear = ""
    @State private var msgString = ""
    @State private var msgColor = Color.green
    @FocusState private var focus1: Bool
    @FocusState private var focus2: Bool
    @State private var guessed = false
    @State private var yearRange = Century.BCE
    @State private var guess = Guess.year
    @State private var deptGuess = Department(departmentId: 0, displayName: "")
    @State var isDeptQuiz: Bool
    
    var body: some View {
        VStack {
            Text(artworkVM.artwork.title ?? " ")
                .font(.title2)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(3)
            if isDeptQuiz && artworkVM.artwork.department != nil {
                Text("In " + (artworkVM.artwork.department ?? " "))
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .italic()
                    .padding(.top)
            }
            Spacer()
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
                Text("Loading your image...")
                    .padding(.top, 40)
            }
            
            Spacer()
            
            if !isDeptQuiz {
                Picker("", selection: $guess) {
                    ForEach(Guess.allCases, id: \.self) { g in
                        Text(g.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            
            if guess == .year {
                
                HStack {
                    Text("Year:")
                    TextField("", text: $guessYear)
                        .focused($focus1)
                        .keyboardType(.decimalPad)
                        .frame(width: 70)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(.gray.opacity(0.5), lineWidth: 2)
                        }
                        .multilineTextAlignment(.center)
                        .disabled(guessed)
                        .onChange(of: guessYear) { _ in
                            guessYear = guessYear.trimmingCharacters(in: .decimalDigits.inverted)
                        }
                }
                    Picker("Year Range", selection: $yearRange) {
                        ForEach(Century.allCases, id: \.self) { range in
                            Text(range.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 100)
            } else {
                Text("Department:")
                Picker("", selection: $deptGuess) {
                    ForEach(departmentVM.departments, id: \.self) { dept in
                        Text(dept.displayName)
                    }
                }
                .pickerStyle(.menu)
            }
            
            if guessed {
                
                if artworkVM.artwork.objectURL != "" {
                    VStack {
                        Link("More about the Piece", destination: URL(string: artworkVM.artwork.objectURL ?? "https://www.metmuseum.org/")!)
                            .padding(.vertical, 4)
                        ShareLink(item: URL(string: artworkVM.artwork.objectURL ?? "https://www.metmuseum.org/")!) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                    }
                    
                } else if artworkVM.artwork.linkResource != "" {
                    VStack {
                        Link("More about the Piece", destination: URL(string: artworkVM.artwork.linkResource ?? "https://www.metmuseum.org/")!)
//                            .padding(.bottom, 2)
                        ShareLink(item: URL(string: artworkVM.artwork.linkResource ?? "https://www.metmuseum.org/")!)
                    }
                } else {
                    Link("Visit the MET!", destination: URL(string: "https://www.metmuseum.org/")!)
                }
                
                Button("Next Piece?") {
                    guessed.toggle()
                    msgString = ""
                    guessYear = ""
                    if department.departmentId != 0 {
                        Task {
                            await artworkVM.loadArt()
                        }
                    } else {
                        Task {
                            await artworkVM.getAllArtwork()
                        }
                    }
                }
                .buttonStyle(.borderedProminent)
                
                Text("\(msgString) This piece is from \(artworkVM.artwork.objectDate ?? "") and is in the \(artworkVM.artwork.department ?? "") department.")
                    .font(.title)
                    .foregroundColor(msgColor)
                    .multilineTextAlignment(.center)
                
            } else {
                
                Button("Enter Guess") {
                    focus1 = false
                    focus2 = false
                    guessed.toggle()
                    switch guess {
                    case .year :
                        let guess = yearRange == .BCE ? "\(guessYear)" : guessYear
                        let correct = artworkVM.guessYear(year: guess)
                        if correct == "yes" {
                            msgString = "Correct!"
                            msgColor = .green
                        } else if correct == "close" {
                            msgString = "Close!"
                            msgColor = .yellow
                        } else {
                            msgString = "Incorrect."
                            msgColor = .red
                        }
                    case .department:
                        let correct = artworkVM.guessDepartment(dept: deptGuess)
                        if correct {
                            msgString = "Correct!"
                            msgColor = .green
                        } else {
                            msgString = "Incorrect."
                            msgColor = .red
                        }
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .disabled(guessYear == "" && guess == .year)
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
                    await departmentVM.getData()
                    deptGuess = departmentVM.departments[0]
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
            QuizDetailView(department: Department(departmentId: 0, displayName: "America"), isDeptQuiz: true)
                .environmentObject(ArtworkViewModel())
                .environmentObject(DepartmentViewModel())
        }
    }
}

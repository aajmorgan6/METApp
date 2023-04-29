//
//  ContentView.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import SwiftUI

struct ArtHomePage: View {
    @State private var sheetIsPresented = false
    @State var next = false
    var body: some View {
        ZStack {
            if next {
                NavigationStack {
                    VStack {
                        Text("Welcome to the MET Database!")
                            .ignoresSafeArea()
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("AccentColor"))
                        VStack {
                            Group {
                                Text("Would You Like to Test Your Knowledge?")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                    .padding(.bottom, 30)
                                
                                NavigationLink {
                                    DepartmentListView(quiz: true)
                                } label: {
                                    Text("Quiz by Department")
                                }
                                .buttonStyle(.borderedProminent)
                                
                                NavigationLink {
                                    QuizDetailView(department: Department(departmentId: 0, displayName: ""), isDeptQuiz: false)
                                } label: {
                                    Text("Quiz by All Pieces")
                                }
                                .buttonStyle(.borderedProminent)
                                .padding(.bottom)
                                
                                
                                Text("OR")
                                    .padding(.bottom)
                                Text("Would You Like To See Some Pieces?")
                                    .font(.title2)
                            }
                            
                            NavigationLink {
                                DepartmentListView(quiz: false)
                            } label: {
                                Text("Browse by Department")
                            }
                            .buttonStyle(.borderedProminent)
                            NavigationLink {
                                ArtworkDetailView(department: Department(departmentId: 0, displayName: ""))
                                
                            } label: {
                                Text("See from All Pieces")
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.bottom)
                            Group {
                                Text("OR")
                                    .padding(.bottom)
                                Text("Would You Like to See the Piece of the Day")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                
                                Button("Piece of the Day", action: {
                                    sheetIsPresented.toggle()
                                })
                                .buttonStyle(.borderedProminent)
                                
                                Spacer()
                                
                                Link("Visit the MET!", destination: URL(string: "https://www.metmuseum.org/")!)
                            }
                        }
                        .padding()
                        .sheet(isPresented: $sheetIsPresented) {
                            ArtOfTheDayDetailView()
                        }
                    }
                }
            }
            
            if !next {
                VStack {
                    Text("Welcome to the MET Database!")
                        .ignoresSafeArea()
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("AccentColor"))
                    
                    Spacer()
                    
                    Text("Continue to look through the available MET pieces, quiz your knowledge, and learn more about history's best art!")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("AccentColor"), lineWidth: 5)
                        }
                        .padding()
                    
                    
                    Text("If a piece piques your interest, feel free to click the link and learn more about it!")
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("AccentColor"), lineWidth: 5)
                        }
                        .padding()
                    
                    Spacer()
                    
                    Button("Let's Get Started!", action: {
                        next.toggle()
                    })
                    .buttonStyle(.borderedProminent)
                    .font(.title2)
                    .padding(.bottom)

                }
            }
        }
    }
}

struct ArtHomePage_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ArtHomePage()
        }
    }
}

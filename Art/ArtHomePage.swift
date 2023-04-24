//
//  ContentView.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import SwiftUI

struct ArtHomePage: View {
    var body: some View {
        NavigationStack {
            VStack {
                Group {
                    Text("Welcome to the MET Quiz!")
                        .font(.title)
                        .bold()
                    Spacer()
                    
                    Text("How Would You Like to Test Your Knowledge?")
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
                        QuizDetailView(department: Department(departmentId: 0, displayName: ""))
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
                
                Text("OR")
                    .padding(.bottom)
                Text("Would You Like to See the Piece of the Day")
                    .font(.title2)
                    .multilineTextAlignment(.center)
                
                NavigationLink(destination: {
                    ArtOfTheDayDetailView()
                }, label: {
                    Text("Piece of the Day")
                })
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
        }
    }
}

struct ArtHomePage_Previews: PreviewProvider {
    static var previews: some View {
        ArtHomePage()
    }
}

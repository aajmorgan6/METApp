//
//  HomePage.swift
//  Art
//
//  Created by AJ Morgan on 4/25/23.
//

import SwiftUI

struct HomePage: View {
    var body: some View {
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
                
                NavigationLink {
                    ArtHomePage()
                } label: {
                    Text("Let's Get Started!")
                }
                .buttonStyle(.borderedProminent)
                .font(.title2)
                .padding(.bottom)

            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}

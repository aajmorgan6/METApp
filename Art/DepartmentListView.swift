//
//  DepartmentListView.swift
//  Art
//
//  Created by AJ Morgan on 4/19/23.
//

import SwiftUI

struct DepartmentListView: View {
    
    @EnvironmentObject var departmentVM: DepartmentViewModel
    @EnvironmentObject var artworkListVM: ArtworkViewModel
    @State var quiz: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    ForEach(departmentVM.departments) { department in
                        NavigationLink(department.displayName) {
//                            ArtworkListView(department: department)
                            if quiz {
                                QuizDetailView(department: department)
                            } else {
                                ArtworkDetailView(department: department)
                            }
                        }
                    }

                }
                .listStyle(.plain)
                .onAppear {
                    Task {
                        await departmentVM.getData()
                    }
                }
                
                if departmentVM.isLoading {
                    ProgressView()
                        .scaleEffect(4)
                }
            }
            .navigationTitle("Departments")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Text("Welcome to the MET!")
                }
            }
        }
    }
}

struct DepartmentListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DepartmentListView(quiz: false)
                .environmentObject(DepartmentViewModel())
                .environmentObject(ArtworkViewModel())
        }
    }
}

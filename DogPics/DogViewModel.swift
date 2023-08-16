//
//  DogViewModel.swift
//  DogPics
//
//  Created by Bob Witmer on 2023-08-16.
//

import Foundation

@MainActor
class DogViewModel: ObservableObject {
    struct Result: Codable {
        var message: String
        var status: String
    }
    
    @Published var imageURL = ""
    @Published var status = ""
    @Published var isLoading = false
    @Published var urlString = "https://dog.ceo/api/breeds/image/random"
    
    func getData() async {
        print("🕸️ We are accessing the URL \(urlString)")
        isLoading = true
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            guard let returned = try? JSONDecoder().decode(Result.self, from: data) else {
                print("😡 JSON ERROR: Could not decode returned JSON data")
                isLoading = false
                return
            }
            print("The imageURL is: \(imageURL) and status is: \(status)")
            self.imageURL = returned.message
            self.status = returned.status
            isLoading = false
        } catch {
            print("😡 ERROR: Could not use URL at \(urlString) to get data and response --> \(error.localizedDescription)")
            isLoading = false
        }
    }
}

//
//  ContentView.swift
//  DogPics
//
//  Created by Bob Witmer on 2023-08-15.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @StateObject var dogVM = DogViewModel()
    @State private var audioPlayer: AVAudioPlayer!
    @State var dogImage: Image = Image(systemName: "photo")
    @State private var imageIsRetrieved = false
    @State private var selectedBreed: Breed = .boxer
    let randomURL = "https://dog.ceo/api/breeds/image/random"
    let allBreedsURL = "https://dog.ceo/api/breeds/list/all"
    
    enum Breed: String, CaseIterable {
        case boxer, bulldog, chihuahua, corgi, labradoodle, poodle, pug, retriever, spaniel
    }
    
    var body: some View {
        VStack {
            Text("🐶 Dog Pics!")
                .font(.custom("Avenir Next Condensed", size: 60))
                .fontWeight(.bold)
                .foregroundColor(.brown)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5)
                .lineLimit(1)
            
            Spacer()

            AsyncImage(url: URL(string: dogVM.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(15)
                    .shadow(radius: 15)
                    .animation(.default, value: image)
                
            } placeholder: {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
            }

            
            Spacer()
            
            Button("Any Random Dog") {
                dogVM.urlString = randomURL
                Task {
                    await dogVM.getData()
                }
                imageIsRetrieved = true
            }
            .buttonStyle(.borderedProminent)
            .tint(.brown)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.bottom)
            
            HStack {
                Button("Show Breed") {
                    dogVM.urlString = "https://dog.ceo/api/breed/\(selectedBreed.rawValue)/images/random"
                    Task {
                        await dogVM.getData()
                    }
                    imageIsRetrieved = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown)
                .font(.title2)
                .fontWeight(.bold)
                
                Picker("", selection: $selectedBreed) {
                    ForEach(Breed.allCases, id: \.self) {breed in
                        Text(breed.rawValue.capitalized)
                    }
                }
                .pickerStyle(.automatic)
                .fontWeight(.bold)
                .tint(.brown)

            }
        }
        .onAppear() {
            playSound(soundName: "bark")
        }
        .padding()
    }
    
    // Function to Play a sound
    // Requires:    import AVFAudio
    //              @State private var audioPlayer: AVAudioPlayer!
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else {
            print("😡 Could not read file named \(soundName).")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch {
            print("😡 ERROR: \(error.localizedDescription) creating audioPlayer.")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

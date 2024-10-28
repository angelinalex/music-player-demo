//
//  MusicPlayerView.swift
//  Music Player
//
//  Created by Angelina on 10/26/24.
//
//
//  MusicPlayerView.swift
//  Music Player
//
//  Created by Angelina on 10/26/24.
//
import AVFAudio
import SwiftUI

struct MusicPlayerView: View {
    
    var backgroundColor = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    @State var paused = true
    @State var totalTime = 70
    @State var timeCompleted = 0
    @State var timeRemaining = 70
    var song: Song;
    var playlist: [Song]
    
    
    @State private var player: AVAudioPlayer?
    
    func configurePlayer(sound: String, type: String) {
        do {
            // Configure the audio session
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)

            // Get the file path for the audio resource
            guard let urlString = Bundle.main.path(forResource: sound, ofType: type) else {
                print("URL string is nil")
                return
            }

            // Create a URL from the file path
            let url = URL(fileURLWithPath: urlString)

            // Initialize the audio player
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = 0.09
            player?.numberOfLoops = -1
            player?.prepareToPlay()
            
            // Set totalTime based on audio duration
            totalTime = Int(player?.duration ?? 0)
            timeRemaining = totalTime

        } catch {
            print("Error occurred: \(error.localizedDescription)")
        }
    }

    var body: some View {
        VStack {
            Spacer()
            
            Image(song.album_cover)
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.9)
                .clipShape(RoundedRectangle(cornerRadius: 15))
            HStack{
                VStack(alignment:.leading){
                    Text(song.name)
                        .foregroundColor(.black)
                    Text(song.artist)
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }
                Spacer()
                
            }
            .padding()
            HStack {
                Spacer()
                
                Button {
                    // Optional additional play button actions
                } label: {
                    Image(systemName: "playpause.fill")
                        .scaleEffect(x: -1, y: 1) // Flips horizontally
                        .foregroundColor(.black)
                }
                Button {
                    paused.toggle()
                    if paused {
                        player?.pause()
                    } else {
                        player?.play()
                    }
                } label: {
                    Image(systemName: paused ? "play.circle.fill" : "pause.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.black)
                }
                .padding()
                
                Button {
                    // Optional additional play button actions
                } label: {
                    Image(systemName: "playpause.fill")
                        .foregroundColor(.black)
                }
                
                Spacer()
            }
             
            // ProgressBarView now uses @Binding for time variables
            ProgressBarView(
                timeRemainingInSeconds: $timeRemaining,
                timeCompletedInSeconds: $timeCompleted,
                totalTimeInSeconds: totalTime,
                paused: $paused,
                onProgressChange: { newTimeCompleted in
                    // Update the player's current time based on the new completed time
                    player?.currentTime = TimeInterval(newTimeCompleted)
                }
            )
            
            Spacer()
        }
        .onAppear() {
            configurePlayer(sound: song.file_name, type: "wav")
        }
        .ignoresSafeArea(.all)
        .background(backgroundColor)
    }
}


#Preview {
    MusicPlayerView( song:   Song(name: "Relaxing Ocean Soundscape", artist: "Nature", album_cover: "pink", file_name: "Ocean"), playlist: [])
}

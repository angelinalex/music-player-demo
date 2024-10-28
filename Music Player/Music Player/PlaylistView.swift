//
//  PlaylistView.swift
//  Music Player
//
//  Created by Angelina on 10/26/24.
//

import SwiftUI

struct PlaylistView: View {
    
    var songs: [Song] = [
        Song(name: "Relaxing Ocean Soundscape", artist: "Nature", album_cover: "oceanalbum", file_name: "Ocean"),
        
        Song(name: "Calming Forrest Ambience", artist: "Nature", album_cover: "woodsalbum", file_name: "Forrest")
        ,
        Song(name: "Invigorating Waterfalls", artist: "Nature", album_cover: "waterfallsalbum", file_name: "Waterfalls")
        ]
    var backgroundColor = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    
    var body: some View {
        
        
        
        NavigationStack{
            VStack{
                
                
                VStack(alignment:.leading){
                 
                    
                    ForEach(songs, id: \.name) { song in
                        
                        
                        NavigationLink{
                            MusicPlayerView( song: song, playlist: songs)
                            
                        }
                       label:{
                        HStack{

                            Image(song.album_cover)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                .padding(.leading)
                            
                            VStack(alignment:.leading){
                                Text(song.name) // Display the name of the song
                                 
                                    .foregroundColor(.black)
                               
                                
                                Text(song.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                
                            }
                            
                            Spacer()
                       
                        }
                        .padding(.top)
                        .padding(.bottom)
                      
                    }
                        
                
                    
                       
                        
                    
                              
                        
                        
                        
                        
                        
                        
                        
                 }
                }
                .padding(.top, 100)
       
                
                Spacer()
                
                
                
                
            }
            .background(backgroundColor)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        }
        
  

        
        
        
        
        
    }
}

#Preview {
    PlaylistView()
}

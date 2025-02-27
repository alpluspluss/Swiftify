/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct FavoritesView: View 
{
    @StateObject private var libraryManager = LibraryManager.shared
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some View 
    {
        ZStack 
        {
            Color.black.opacity(0.95).edgesIgnoringSafeArea(.all)
            
            if libraryManager.favoriteSongs.isEmpty 
            {
                VStack
                {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                        .padding()
                    
                    Text("No Favorites Yet")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                    Text("Mark songs as favorites to see them here")
                        .foregroundColor(.gray)
                }
            } 
            else
            {
                List 
                {
                    ForEach(libraryManager.favoriteSongs) { song in
                        SongRowView(song: song).onTapGesture
                        {
                            audioManager.currentPlaylist = Playlist(name: "Favorites", songs: libraryManager.favoriteSongs)
                            audioManager.load(song: song)
                            audioManager.play()
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
    }
}

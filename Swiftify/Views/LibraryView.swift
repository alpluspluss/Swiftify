/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct LibraryView: View 
{
    @StateObject private var libraryManager = LibraryManager.shared
    @StateObject private var audioManager = AudioManager.shared
    let searchText: String
    
    var filteredSongs: [ Song ]
    {
        libraryManager.searchSongs(query: searchText)
    }
    
    var body: some View 
    {
        List 
        {
            ForEach(filteredSongs) { song in
                SongRowView(song: song)
                    .onTapGesture 
                {
                    audioManager.currentPlaylist = Playlist(name: "Now Playing", songs: filteredSongs)
                    audioManager.load(song: song)
                    audioManager.play()
                }
            }
        }
        .listStyle(PlainListStyle())
    }
}

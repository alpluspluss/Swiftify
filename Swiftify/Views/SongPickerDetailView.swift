/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct SongPickerView: View 
{
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var playlist: Playlist
    @StateObject private var libraryManager = LibraryManager.shared
    @State private var selectedSongs = Set<UUID>()
    
    var body: some View 
    {
        NavigationView 
        {
            List {
                ForEach(libraryManager.allSongs) { song in
                    Button(action: 
                        {
                        if selectedSongs.contains(song.id) 
                        {
                            selectedSongs.remove(song.id)
                        } 
                        else
                        {
                            selectedSongs.insert(song.id)
                        }
                    }) 
                    {
                        HStack 
                        {
                            SongRowView(song: song)
                            
                            if selectedSongs.contains(song.id) 
                            {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
            .navigationTitle("Add Songs")
            .toolbar 
            {
                ToolbarItem(placement: .cancellationAction)
                {
                    Button("Cancel") 
                    {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction)
                {
                    Button("Add") 
                    {
                        for songId in selectedSongs
                        {
                            if let song = libraryManager.allSongs.first(where: { $0.id == songId }),
                               !playlist.songs.contains(where: { $0.id == songId }) 
                            {
                                playlist.songs.append(song)
                            }
                        }
                        LibraryManager.shared.savePlaylists()
                        presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(selectedSongs.isEmpty)
                }
            }
        }
    }
}

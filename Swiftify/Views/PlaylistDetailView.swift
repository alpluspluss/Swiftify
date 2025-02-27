/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct PlaylistDetailView: View 
{
    @ObservedObject var playlist: Playlist
    @StateObject private var audioManager = AudioManager.shared
    @State private var isEditing = false
    @State private var showingSongPicker = false
    @State private var showingArtworkPicker = false
    
    var body: some View
    {
        VStack 
        {
            /* playlist header */
            VStack 
            {
                ZStack 
                {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [ .purple, .blue ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 150, height: 150)
                    
                    if let customArtwork = playlist.customArtworkPath,
                       let nsImage = NSImage(contentsOfFile: customArtwork) 
                    {
                        Image(nsImage: nsImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .cornerRadius(12)
                    } 
                    else
                    {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 60))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top)
                .onTapGesture 
                {
                    showingArtworkPicker = true
                }
                
                Text(playlist.name)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("\(playlist.songs.count) songs")
                    .foregroundColor(.secondary)
                
                updatedButtonsView()
            }
            
            Divider()
            
            /* list of songs */
            if playlist.songs.isEmpty
            {
                VStack 
                {
                    Text("No songs in this playlist")
                        .foregroundColor(.secondary)
                        .padding()
                    
                    Button(action: { showingSongPicker = true })
                    {
                        Text("Add Songs")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                }
                .frame(maxHeight: .infinity)
            } 
            else
            {
                List
                {
                    ForEach(playlist.songs) { song in
                        SongRowView(song: song)
                            .onTapGesture
                        {
                            audioManager.currentPlaylist = playlist
                            audioManager.load(song: song)
                            audioManager.play()
                        }
                    }
                    .onDelete { indexSet in
                        playlist.songs.remove(atOffsets: indexSet)
                        LibraryManager.shared.savePlaylists()
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .sheet(isPresented: $showingSongPicker) 
        {
            SongPickerView(playlist: playlist)
        }
        .fileImporter(
            isPresented: $showingArtworkPicker,
            allowedContentTypes: [.image],
            allowsMultipleSelection: false
        ) { result in
            do
            {
                guard let selectedURL = try result.get().first 
                else
                {
                    return
                }
                
                guard selectedURL.startAccessingSecurityScopedResource()
                else 
                {
                    return
                }
                
                defer
                {
                    selectedURL.stopAccessingSecurityScopedResource()
                }
                
                let fileName = selectedURL.lastPathComponent
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let destination = documentsDirectory.appendingPathComponent(fileName)
                
                try FileManager.default.copyItem(at: selectedURL, to: destination)
            
                
                playlist.customArtworkPath = destination.path
                LibraryManager.shared.savePlaylists()
            } 
            catch
            {
                print("Error selecting artwork: \(error)")
            }
        }
        .toolbar 
        {
            ToolbarItem
            {
                Button(action: { showingSongPicker = true })
                {
                    Image(systemName: "plus")
                }
            }
            
            ToolbarItem
            {
                Button(action: { showingArtworkPicker = true }) 
                {
                    Image(systemName: "photo")
                }
            }
        }
    }
}

extension PlaylistDetailView 
{
    func updatedButtonsView() -> some View 
    {
        HStack 
        {
            Button(action: {
                if !playlist.songs.isEmpty 
                {
                    audioManager.currentPlaylist = playlist
                    audioManager.load(song: playlist.songs[0])
                    audioManager.play()
                }
            }) 
            {
                HStack 
                {
                    Image(systemName: "play.fill")
                    Text("Play All")
                }
            }
            .buttonStyle(MacButtonStyle())
            .disabled(playlist.songs.isEmpty)
            
            Button(action: { isEditing.toggle() })
            {
                HStack 
                {
                    Image(systemName: isEditing ? "checkmark" : "pencil")
                    Text(isEditing ? "Done" : "Edit")
                }
            }
            .buttonStyle(MacButtonStyle(isPrimary: false))
        }
        .padding()
    }
}

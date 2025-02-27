import SwiftUI

struct PlaylistsView: View 
{
    @StateObject private var libraryManager = LibraryManager.shared
    @State private var showingCreatePlaylist = false
    @State private var newPlaylistName = ""
    
    var body: some View 
    {
        ZStack 
        {
            Color.black.opacity(0.95).edgesIgnoringSafeArea(.all)
            
            VStack 
            {
                if libraryManager.playlists.isEmpty 
                {
                    VStack
                    {
                        Image(systemName: "music.note.list")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                            .padding()
                        
                        Text("No Playlists Yet")
                            .font(.title)
                            .foregroundColor(.gray)
                        
                        Text("Create your first playlist")
                            .foregroundColor(.gray)
                        
                        Button(action: { showingCreatePlaylist = true })
                        {
                            HStack 
                            {
                                Image(systemName: "plus")
                                Text("Create Playlist")
                            }
                            .font(.headline)
                        }
                        .buttonStyle(MacButtonStyle())
                        .padding()
                    }
                } 
                else
                {
                    List 
                    {
                        ForEach(libraryManager.playlists) { playlist in
                            NavigationLink(destination: PlaylistDetailView(playlist: playlist))
                            {
                                HStack
                                {
                                    ZStack
                                    {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(LinearGradient(
                                                gradient: Gradient(colors: [.purple, .blue]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ))
                                            .frame(width: 50, height: 50)
                                        
                                        if let customArtwork = playlist.customArtworkPath,
                                           let nsImage = NSImage(contentsOfFile: customArtwork)
                                        {
                                            Image(nsImage: nsImage)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 50, height: 50)
                                                .cornerRadius(8)
                                        }
                                        else
                                        {
                                            Image(systemName: "music.note.list")
                                                .foregroundColor(.white)
                                        }
                                    }
                                    
                                    VStack(alignment: .leading)
                                    {
                                        Text(playlist.name)
                                            .font(.headline)
                                        
                                        Text("\(playlist.songs.count) songs")
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                        .onDelete(perform: libraryManager.deletePlaylist)
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Playlists")
            .toolbar 
            {
                ToolbarItem 
                {
                    Button(action: { showingCreatePlaylist = true })
                    {
                        Image(systemName: "plus")
                    }
                    .buttonStyle(MacToolbarButtonStyle())
                }
            }
        }
        .alert("Create Playlist", isPresented: $showingCreatePlaylist) 
        {
            TextField("Playlist Name", text: $newPlaylistName)
            
            Button("Cancel", role: .cancel) 
            {
                newPlaylistName = ""
            }
            
            Button("Create") 
            {
                if !newPlaylistName.isEmpty
                {
                    _ = libraryManager.createPlaylist(name: newPlaylistName)
                    newPlaylistName = ""
                }
            }
        }
    message:
        {
            Text("Enter a name for your new playlist")
        }
        .onAppear 
        {
            NotificationCenter.default.addObserver(
                forName: Notification.Name("CreateNewPlaylist"),
                object: nil,
                queue: .main) { _ in
                    showingCreatePlaylist = true
                }
        }
    }
}

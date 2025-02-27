/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct MainView: View 
{
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var libraryManager = LibraryManager.shared
    @State private var searchText = ""
    @State private var showingPlaylistView = false
    @State private var selectedTab = 0
    
    var body: some View 
    {
        TabView(selection: $selectedTab)
        {
            NavigationView 
            {
                ZStack 
                {
                    Color.black.opacity(0.95).edgesIgnoringSafeArea(.all)
                    
                    VStack 
                    {
                        SearchBarView(searchText: $searchText)
                            .padding()
                        
                        if selectedTab == 0 
                        {
                            LibraryView(searchText: searchText)
                        } 
                        else if selectedTab == 1 
                        {
                            PlaylistsView()
                        } 
                        else
                        {
                            FavoritesView()
                        }
                        
                        Spacer()
                        
                        /* always visible; mini player */
                        if audioManager.currentSong != nil 
                        {
                            MiniPlayerView()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.purple.opacity(0.7), Color.blue.opacity(0.7)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(15)
                                .padding(.horizontal)
                                .padding(.bottom, 8)
                                .shadow(radius: 5)
                                .onTapGesture {
                                    showingPlaylistView.toggle()
                                }
                        }
                    }
                }
                .sheet(isPresented: $showingPlaylistView) 
                {
                    if let song = audioManager.currentSong 
                    {
                        FullPlayerView(song: song)
                    }
                }
                .navigationTitle("Swiftify")
                .toolbar 
                {
                    ToolbarItem
                    {
                        Button(action: { libraryManager.importMusicFiles() })
                        {
                            Label("Import", systemImage: "square.and.arrow.down")
                        }
                    }
                }
            }
            
            .tabItem 
            {
                Label("Library", systemImage: "music.note.list")
            }
            .tag(0)
            
            NavigationView 
            {
                PlaylistsView()
                    .navigationTitle("Playlists")
            }
            .tabItem 
            {
                Label("Playlists", systemImage: "music.note")
            }
            .tag(1)
            
            NavigationView 
            {
                FavoritesView()
                    .navigationTitle("Favorites")
            }
            .tabItem 
            {
                Label("Favorites", systemImage: "heart.fill")
            }
            .tag(2)
        }
        .accentColor(.purple)
    }
}

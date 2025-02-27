/* created by alpluspluss; Feb 26 2025 */

import Foundation
import SwiftUI
import Combine
import AVFoundation
import UniformTypeIdentifiers

class LibraryManager: ObservableObject 
{
    static let shared = LibraryManager() /* shared music lib */
    
    @Published var allSongs: [Song] = []
    @Published var playlists: [Playlist] = []
    @Published var favoriteSongs: [Song] = []
    
    private let songsKey = "swiftify_songs"
    private let playlistsKey = "swiftify_playlists"
    private let favoritesKey = "swiftify_favorites"
    
    private init() 
    {
        loadData()
    }
    
    func loadData() 
    {
        loadSongs()
        loadPlaylists()
        loadFavorites()
    }
    
    private func loadSongs() 
    {
        if let data = UserDefaults.standard.data(forKey: songsKey),
           let songs = try? JSONDecoder().decode([Song].self, from: data) 
        {
            allSongs = songs
        }
    }
    
    private func loadPlaylists() 
    {
        if let data = UserDefaults.standard.data(forKey: playlistsKey),
           let playlists = try? JSONDecoder().decode([Playlist].self, from: data) 
        {
            self.playlists = playlists
        }
    }
    
    private func loadFavorites() 
    {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([Song].self, from: data) 
        {
            favoriteSongs = favorites
        }
    }
    
    func saveSongs() 
    {
        if let data = try? JSONEncoder().encode(allSongs) 
        {
            UserDefaults.standard.set(data, forKey: songsKey)
        }
    }
    
    func savePlaylists() 
    {
        if let data = try? JSONEncoder().encode(playlists) 
        {
            UserDefaults.standard.set(data, forKey: playlistsKey)
        }
    }
    
    func saveFavorites() 
    {
        if let data = try? JSONEncoder().encode(favoriteSongs) 
        {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    func addSong(_ song: Song) 
    {
        allSongs.append(song)
        saveSongs()
    }
    
    func createPlaylist(name: String) -> Playlist 
    {
        let newPlaylist = Playlist(name: name)
        playlists.append(newPlaylist)
        savePlaylists()
        return newPlaylist
    }
    
    func deletePlaylist(at indexSet: IndexSet) 
    {
        playlists.remove(atOffsets: indexSet)
        savePlaylists()
    }
    
    func toggleFavorite(song: Song) -> Song 
    {
        var updatedSong = song
        updatedSong.isFavorite.toggle()
        
        if let index = allSongs.firstIndex(where: { $0.id == song.id }) 
        {
            allSongs[index] = updatedSong
            saveSongs()
        }
        
        if updatedSong.isFavorite 
        {
            favoriteSongs.append(updatedSong)
        } 
        else
        {
            favoriteSongs.removeAll { $0.id == song.id }
        }
        saveFavorites()
        
        return updatedSong
    }
    
    func searchSongs(query: String) -> [Song] {
        guard !query.isEmpty else { return allSongs }
        
        return allSongs.filter { song in
            song.title.lowercased().contains(query.lowercased()) ||
            song.artist.lowercased().contains(query.lowercased()) ||
            song.album.lowercased().contains(query.lowercased())
        }
    }
    
    func importMusicFiles() 
    {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [UTType.mp3, UTType.audio]
        
        panel.begin { [weak self] response in
            guard let self = self, response == .OK else { return }
            
            for url in panel.urls 
            {
                let fileName = url.lastPathComponent
                let fileExtension = url.pathExtension.lowercased()
                
                if fileExtension == "mp3" 
                {
                    let asset = AVAsset(url: url)
                    let metadata = asset.metadata
                    
                    var title = fileName
                    var artist = "Unknown Artist"
                    var album = "Unknown Album"
                    
                    for item in metadata 
                    {
                        guard let key = item.commonKey?.rawValue, let value = item.value 
                        else
                        {
                            continue
                        }
                        
                        switch key 
                        {
                        case "title":
                            title = value as? String ?? fileName
                        case "artist":
                            artist = value as? String ?? "Unknown Artist"
                        case "albumName":
                            album = value as? String ?? "Unknown Album"
                        default:
                            break
                        }
                    }
                    
                    let duration = CMTimeGetSeconds(asset.duration)
                    let song = Song(
                        title: title,
                        artist: artist,
                        album: album,
                        duration: duration,
                        filePath: url.path
                    )
                    
                    /* add to lib */
                    self.addSong(song)
                }
            }
        }
    }
    
    func deleteSong(_ song: Song) 
    {
        allSongs.removeAll(where: { $0.id == song.id })
        favoriteSongs.removeAll(where: { $0.id == song.id })
        for playlist in playlists 
        {
            playlist.songs.removeAll(where: { $0.id == song.id })
        }
        
        saveSongs()
        savePlaylists()
        saveFavorites()
    }
}

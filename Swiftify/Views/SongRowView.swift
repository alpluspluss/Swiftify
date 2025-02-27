/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct SongRowView: View 
{
    @State var song: Song
    @StateObject private var libraryManager = LibraryManager.shared
    @State private var showingDeleteConfirmation = false
    
    var body: some View 
    {
        HStack 
        {
            ZStack 
            {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [ .purple, .blue ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 50, height: 50)
                
                Text(String(song.title.prefix(1)))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4)
            {
                Text(song.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack 
                {
                    Text(song.artist)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text(song.duration.formattedTime())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Button(action: { song = libraryManager.toggleFavorite(song: song) }) 
            {
                Image(systemName: song.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(song.isFavorite ? .red : .gray)
            }
            
            Spacer()
            Button(action: { showingDeleteConfirmation = true })
            {
                Image(systemName: "trash")
                    .foregroundColor(.red.opacity(0.7))
            }
            buttonStyle(BorderlessButtonStyle())
            Button(action: {  song = libraryManager.toggleFavorite(song: song) })
            {
                Image(systemName: song.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(song.isFavorite ? .red : .gray)
            }
        }
        .padding(.vertical, 8)
        .alert("Delete Song", isPresented: $showingDeleteConfirmation) 
        {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive)
            {
                libraryManager.deleteSong(song)
            }
        }
    message:
        {
            Text("Are you sure you want to delete '\(song.title)'? This will remove it from all playlists.")
        }
    }
}

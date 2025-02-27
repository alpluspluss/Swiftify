/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct MiniPlayerView: View 
{
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some View 
    {
        if let song = audioManager.currentSong 
        {
            HStack 
            {
                ZStack 
                {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [ .purple, .blue ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 40, height: 40)
                    
                    Text(String(song.title.prefix(1)))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.leading, 4)
                
                VStack(alignment: .leading) 
                {
                    Text(song.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    
                    Text(song.artist)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))
                        .lineLimit(1)
                }
                .padding(.leading, 4)
                
                Spacer()
                
                Button(action: { audioManager.playPreviousSong() }) 
                {
                    Image(systemName: "backward.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                
                Button(action: { audioManager.togglePlayback() }) 
                {
                    Image(systemName: audioManager.isPlaying ? "pause.fill" : "play.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                
                Button(action: {  audioManager.playNextSong() })
                {
                    Image(systemName: "forward.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 4)
        }
    }
}

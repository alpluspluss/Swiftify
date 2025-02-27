/* created by alpluspluss; Feb 26 2025 */

import SwiftUI
import AVFoundation

struct FullPlayerView: View 
{
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var audioManager = AudioManager.shared
    @State private var showingPlaylist = false
    @State private var viewSize: CGSize = .zero
    let song: Song
    
    var body: some View 
    {
        GeometryReader { geometry in
            ZStack
            {
                VisualEffectView(material: .hudWindow, blendingMode: .behindWindow)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20)
                {
                    HStack 
                    {
                        Button(action: { presentationMode.wrappedValue.dismiss() })
                        {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Spacer()
                        
                        Text("Now Playing")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        Button(action: { showingPlaylist.toggle() })
                        {
                            Image(systemName: "music.note.list")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    ZStack
                    {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [.purple, .blue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(
                                width: min(geometry.size.width * 0.5, 300),
                                height: min(geometry.size.width * 0.5, 300)
                            )
                            .shadow(radius: 10)
                        
                        if let customArtwork = audioManager.currentPlaylist?.customArtworkPath,
                           let nsImage = NSImage(contentsOfFile: customArtwork) 
                        {
                            Image(nsImage: nsImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(
                                    width: min(geometry.size.width * 0.5, 300),
                                    height: min(geometry.size.width * 0.5, 300)
                                )
                                .cornerRadius(20)
                        } 
                        else
                        {
                            VStack 
                            {
                                Text(String(song.title.prefix(1)))
                                    .font(.system(size: min(geometry.size.width * 0.15, 100)))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white.opacity(0.5))
                                
                                if audioManager.isPlaying 
                                {
                                    Image(systemName: "waveform")
                                        .font(.system(size: min(geometry.size.width * 0.08, 50)))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                            }
                        }
                    }
                    
                    VStack(spacing: 8) {
                        Text(song.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .lineLimit(1)
                        
                        Text(song.artist)
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                        
                        Text(song.album)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    .padding(.horizontal)
                    
                    WaveformView()
                        .frame(height: 60)
                        .padding(.horizontal)
                    
                    VStack 
                    {
                        Slider(
                            value: Binding(
                                get: { audioManager.currentTime },
                                set: { audioManager.seek(to: $0) }
                            ),
                            in: 0...song.duration
                        )
                        .controlSize(.large)
                        
                        HStack {
                            Text(audioManager.currentTime.formattedTime())
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(song.duration.formattedTime())
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.horizontal)
                    
                    HStack(spacing: 40) {
                        Button(action: {
                            audioManager.playPreviousSong()
                        }) {
                            Image(systemName: "backward.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            audioManager.togglePlayback()
                        }) {
                            Image(systemName: audioManager.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: {
                            audioManager.playNextSong()
                        }) {
                            Image(systemName: "forward.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.primary)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.secondary)
                        
                        Slider(
                            value: Binding(
                                get: { Double(audioManager.volume) },
                                set: { audioManager.setVolume(value: Float($0)) }
                            ),
                            in: 0...1
                        )
                        .controlSize(.large)
                        
                        Image(systemName: "speaker.wave.3.fill")
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .onChange(of: geometry.size) { newSize in
                viewSize = newSize
            }
        }
        .sheet(isPresented: $showingPlaylist) 
        {
            if let playlist = audioManager.currentPlaylist
            {
                NavigationView 
                {
                    List 
                    {
                        ForEach(playlist.songs) { song in
                            Button(action: 
                            {
                                audioManager.load(song: song)
                                audioManager.play()
                                showingPlaylist = false
                            }) 
                            {
                                HStack 
                                {
                                    SongRowView(song: song)
                                    if audioManager.currentSong?.id == song.id 
                                    {
                                        Spacer()
                                        
                                        Image(systemName: "music.note")
                                            .foregroundColor(.accentColor)
                                    }
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .navigationTitle("Current Playlist")
                    .toolbar 
                    {
                        ToolbarItem 
                        {
                            Button("Done") 
                            {
                                showingPlaylist = false
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .frame(minWidth: 500, minHeight: 400)
            }
        }
    }
}

struct VisualEffectView: NSViewRepresentable 
{
    let material: NSVisualEffectView.Material
    let blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView 
    {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) 
    {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

struct MacToolbarButtonStyle: ButtonStyle 
{
    func makeBody(configuration: Configuration) -> some View 
    {
        configuration.label
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(configuration.isPressed ? Color.accentColor.opacity(0.2) : Color.clear)
            )
            .foregroundColor(configuration.isPressed ? .accentColor : .primary)
    }
}

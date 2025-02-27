/* created by alpluspluss; Feb 26 2025 */

import Foundation
import AVFoundation
import SwiftUI
import Combine
import AppKit

class AudioManager: ObservableObject 
{
    static let shared = AudioManager()
    
    private var audioPlayer: AVAudioPlayer?
    private var timer: Timer?
    private var waveformAnimationTimer: Timer?
    
    @Published var currentSong: Song?
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var volume: Float = 0.7
    @Published var waveformPoints: [CGFloat] = []
    @Published var currentPlaylist: Playlist?
    
    private let waveformSampleCount = 30
    
    private init()
    {
        generateInitialWaveform()
    }
    
    private func generateInitialWaveform() 
    {
        waveformPoints = Array(repeating: CGFloat.random(in: 0.1...0.5), count: waveformSampleCount)
    }
    
    func updateWaveform() 
    {
        guard isPlaying else { return }
        
        waveformAnimationTimer?.invalidate()
        waveformAnimationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self 
            else
            { return }
            for i in 0..<self.waveformPoints.count 
            {
                if self.audioPlayer?.isPlaying == true 
                {
                    /* active */
                    self.waveformPoints[i] = CGFloat.random(in: 0.1...1.0)
                } 
                else
                {
                    /* passive */
                    self.waveformPoints[i] = CGFloat.random(in: 0.1...0.3)
                }
            }
        }
    }
    
    func load(song: Song)
    {
        let url: URL
        if let stringUrl = URL(string: song.filePath)
        {
            url = stringUrl
        }
        else
        {
            url = URL(fileURLWithPath: song.filePath)
        }
            
        do
        {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.volume = volume
            currentSong = song
            startTimer()
        }
        catch
        {
            print("Failed to load audio file: \(error)")
        }
    }
    
    func play() 
    {
        audioPlayer?.play()
        isPlaying = true
        updateWaveform()
    }
    
    func pause() 
    {
        audioPlayer?.pause()
        isPlaying = false
        waveformAnimationTimer?.invalidate()
    }
    
    func togglePlayback() 
    {
        if isPlaying 
        {
            pause()
        } 
        else
        {
            play()
        }
    }
    
    func stop() 
    {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
        currentTime = 0
        waveformAnimationTimer?.invalidate()
    }
    
    func seek(to time: Double) 
    {
        audioPlayer?.currentTime = time
        currentTime = time
    }
    
    func setVolume(value: Float) 
    {
        volume = value
        audioPlayer?.volume = value
    }
    
    private func startTimer() 
    {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self, let player = self.audioPlayer 
            else
            {
                return
            }
            
            self.currentTime = player.currentTime
            if !player.isPlaying && self.isPlaying 
            {
                self.playNextSong()
            }
        }
    }
    
    func playNextSong() 
    {
        guard let currentPlaylist = currentPlaylist, let currentSong = currentSong,
              let currentIndex = currentPlaylist.songs.firstIndex(where: { $0.id == currentSong.id }) 
        else
        {
            return
        }
        
        let nextIndex = (currentIndex + 1) % currentPlaylist.songs.count
        let nextSong = currentPlaylist.songs[nextIndex]
        
        load(song: nextSong)
        play()
    }
    
    func playPreviousSong() 
    {
        guard let currentPlaylist = currentPlaylist, let currentSong = currentSong,
              let currentIndex = currentPlaylist.songs.firstIndex(where: { $0.id == currentSong.id }) 
        else
        {
            return
        }
        
        let previousIndex = (currentIndex - 1 + currentPlaylist.songs.count) % currentPlaylist.songs.count
        let previousSong = currentPlaylist.songs[previousIndex]
        
        load(song: previousSong)
        play()
    }

}

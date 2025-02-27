/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct WaveformView: View 
{
    @StateObject private var audioManager = AudioManager.shared
    
    var body: some View
    {
        HStack(spacing: 4) 
        {
            ForEach(0..<audioManager.waveformPoints.count, id: \.self) { index in
                WaveformBar(height: audioManager.waveformPoints[index])
            }
        }
        .frame(height: 50)
        .padding(.vertical)
    }
}

struct WaveformBar: View 
{
    let height: CGFloat
    
    var body: some View 
    {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [.purple, .blue]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .frame(width: 3, height: 40 * height)
            .animation(.easeInOut(duration: 0.2), value: height)
    }
}


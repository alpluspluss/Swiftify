/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct MacButtonStyle: ButtonStyle 
{
    var isPrimary: Bool = true
    
    func makeBody(configuration: Configuration) -> some View 
    {
        configuration.label
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isPrimary
                          ? (configuration.isPressed ? Color.purple.opacity(0.7) : Color.purple)
                          : (configuration.isPressed ? Color.purple.opacity(0.15) : Color.purple.opacity(0.1)))
            )
            .foregroundColor(isPrimary ? .white : .purple)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isPrimary ? Color.clear : Color.purple.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: isPrimary ? Color.purple.opacity(0.3) : Color.clear,
                    radius: 2, x: 0, y: 1)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

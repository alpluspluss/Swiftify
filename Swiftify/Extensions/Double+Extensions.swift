/* created by alpluspluss; Feb 26 2025 */

import Foundation

extension Double 
{
    func formattedTime() -> String 
    {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}

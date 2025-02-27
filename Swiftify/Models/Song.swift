/* created by alpluspluss; Feb 26 2025 */

import Foundation

struct Song: Identifiable, Codable, Equatable
{
    var id = UUID()
    var title: String
    var artist: String
    var album: String
    var duration: Double
    var filePath: String
    var isFavorite: Bool = false
    var albumArtPath: String?
    
    static func == (lhs: Song, rhs: Song) -> Bool
    {
        return lhs.id == rhs.id
    }
}

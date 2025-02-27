/* created by alpluspluss; Feb 26 2025 */

import Foundation
import SwiftUI
import Combine

class Playlist: Identifiable, ObservableObject, Codable 
{
    var id = UUID()
    var name: String
    var customArtworkPath: String?
    @Published var songs: [Song]
    
    enum CodingKeys: String, CodingKey 
    {
        case id, name, customArtworkPath, songs
    }
    
    init(name: String, songs: [Song] = [], customArtworkPath: String? = nil) 
    {
        self.name = name
        self.songs = songs
        self.customArtworkPath = customArtworkPath
    }
    
    required init(from decoder: Decoder) throws 
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        customArtworkPath = try container.decodeIfPresent(String.self, forKey: .customArtworkPath)
        songs = try container.decode([Song].self, forKey: .songs)
    }
    
    func encode(to encoder: Encoder) throws 
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(customArtworkPath, forKey: .customArtworkPath)
        try container.encode(songs, forKey: .songs)
    }
}

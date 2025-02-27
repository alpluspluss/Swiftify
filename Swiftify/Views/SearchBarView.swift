/* created by alpluspluss; Feb 26 2025 */

import SwiftUI

struct SearchBarView: View 
{
    @Binding var searchText: String
    
    var body: some View 
    {
        HStack 
        {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $searchText)
                .foregroundColor(.primary)
            
            if !searchText.isEmpty 
            {
                Button(action: { searchText = "" })
                {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(10)
        .background(Color(.systemGray))
        .cornerRadius(10)
    }
}

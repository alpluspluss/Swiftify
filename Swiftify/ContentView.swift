import SwiftUI

struct ContentView: View 
{
    var body: some View
    {
        MainView()
            .frame(minWidth: 800, minHeight: 600)
            .onAppear
            {
                #if os(macOS)
                NSWindow.allowsAutomaticWindowTabbing = false
                #endif
            }
    }
}

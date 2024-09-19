//
//  ContentView.swift
//  HapticDemo
//
//  Created by yanguo sun on 2024/9/19.
//

import SwiftUI
import CoreData
import CoreHaptics

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var engine: CHHapticEngine?

    var body: some View {
        NavigationView {
            HStack {
                Button("Boop") { playHapticFeedback(file: "Boop") }
                Button("FastSwoop") { playHapticFeedback(file: "FastSwoop") }
                Button("Hangup") { playHapticFeedback(file: "Hangup") }
                Button("TrickleTap") { playHapticFeedback(file: "TrickleTap") }
            }
            .padding()
        }
        .onAppear(perform: prepareHaptics)
    }

    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    private func playHapticFeedback(file: String) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            let pattern = try CHHapticPattern(contentsOf: Bundle.main.url(forResource: file, withExtension: "ahap")!)
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }

}


#Preview {
    ContentView()
}

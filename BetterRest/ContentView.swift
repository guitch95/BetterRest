//
//  ContentView.swift
//  BetterRest
//
//  Created by Guillaume Richard on 27/01/2026.
//

import SwiftUI

struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    var body: some View {
        NavigationStack {
            VStack {
                Text("When do you want to wake up ?")
                    .font(.headline)
                DatePicker(
                    "Please enter a time",
                    selection: $wakeUp,
                    displayedComponents: .hourAndMinute
                )
                .labelsHidden()
                // hidden from the interface but still there for voiceover

                Text("Desire amount of sleep")
                    .font(.headline)

                Stepper(
                    "\(sleepAmount.formatted())hours",
                    value: $sleepAmount,
                    in: 4...12,
                    step: 0.25
                )
                Text("Daily coffee intake")
                    .font(.headline)
                Stepper(
                    "\(coffeeAmount) cup(s)",
                    value: $coffeeAmount,
                    in: 1...20
                )

            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate") {
                    calculateBedTime()
                }
            }
        }
    }
    func calculateBedTime() {}
}

#Preview {
    ContentView()
}

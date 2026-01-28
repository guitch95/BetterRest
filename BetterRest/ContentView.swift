//
//  ContentView.swift
//  BetterRest
//
//  Created by Guillaume Richard on 27/01/2026.
//

import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false

    // static can be read whenever we want.
    // It makes the computed variable belong to the struct itself
    // rather than one instance.
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }

    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()

            NavigationStack {
                VStack {
                    Form {
                        Section("When do you want to wake up ?") {
                            DatePicker(
                                "Please enter a time",
                                selection: $wakeUp,
                                displayedComponents: .hourAndMinute
                            )
                            //                    .labelsHidden()
                        }
                        // hidden from the interface but still there for voiceover

                        Section("Desire amount of sleep") {
                            Stepper(
                                "\(sleepAmount.formatted()) hours",
                                value: $sleepAmount,
                                in: 4...12,
                                step: 0.25
                            )
                        }

                        Section("Daily coffee intake") {
                            Stepper(
                                // Handles the pluralization of the word automatically
                                "^[\(coffeeAmount) cup](inflect:true)",
                                value: $coffeeAmount,
                                in: 1...20
                            )
                        }
                    }
                    .navigationTitle("BetterRest")
                    .toolbar {
                        Button("Calculate", action: calculateBedTime)
                    }
                    .alert(alertTitle, isPresented: $showingAlert) {
                        Button("Ok") {}

                    } message: {
                        Text(alertMessage)
                    }

                }

            }
        }
    }
    func calculateBedTime() {
        // CoreML can throw error, this is why we have a catch in order to "catch" the error.
        do {
            // Config de notre Model de ML
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents(
                [
                    .hour,
                    .minute,
                ],
                from: wakeUp
            )
            // Optionals so if it can't be read it gonna apply 0
            // To get seconds from hour
            let hour = (components.hour ?? 0) * 60 * 60
            // To get seconds from minute
            let minute = (components.minute ?? 0) * 60

            let prediction = try model.prediction(
                wake: Double(hour + minute),
                estimatedSleep: sleepAmount,
                coffee: Double(coffeeAmount)
            )
            let sleepTime = wakeUp - prediction.actualSleep

            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)

        } catch {
            // Catch en eventual error
            alertTitle = "Error"
            alertMessage =
                "Sorry, there was a problem calculating your bedtime. Please try again."
        }
        showingAlert.toggle()
    }

}

#Preview {
    ContentView()
}

// INTEGRATION BACKGROUNG LINEARGRADIENT COULEUR COFFEE BROWN/RED VIA STACK

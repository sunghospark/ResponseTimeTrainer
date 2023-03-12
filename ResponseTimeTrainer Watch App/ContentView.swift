import SwiftUI

struct ContentView: View {
    @State var responseState: ResponseState = .ready
    @State var responseTime: TimeInterval = 0
    
    var body: some View {
        ZStack {
            if responseState == .ready {
                Color.green
                    .ignoresSafeArea()
                    .overlay(Text("Tap to start").font(.largeTitle))
                    .onTapGesture {
                        responseState = .waiting
                    }
            } else if responseState == .waiting {
                Color.green
                    .ignoresSafeArea()
                    .overlay(Text("Ready").font(.largeTitle))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 1...5)) {
                            responseState = .showingRed
                        }
                    }
            } else if responseState == .showingRed {
                Color.red
                    .ignoresSafeArea()
                    .overlay(
                        Text(String(format: "%.2f", responseTime))
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                    .onAppear {
                        responseTime = 0
                        Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { timer in
                            responseTime += 0.001
                            if responseState == .showingGreen {
                                timer.invalidate()
                            }
                        }
                    }
                    .onTapGesture {
                        responseState = .showingGreen
                    }
            } else {
                Color.green
                    .ignoresSafeArea()
                    .overlay(
                        Text("Response time: \(String(format: "%.3f", responseTime)) seconds")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                    .onTapGesture {
                        responseState = .waiting
                    }
            }
        }
    }
}

enum ResponseState {
    case ready
    case waiting
    case showingRed
    case showingGreen
}

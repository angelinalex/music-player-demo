//
//  ProgressBarView.swift
//  Music Player
//
//  Created by Angelina on 10/26/24.
//

import SwiftUI

struct ProgressBarView: View {
    @Binding var timeRemainingInSeconds: Int
    @Binding var timeCompletedInSeconds: Int
    let totalTimeInSeconds: Int
    @Binding var paused: Bool
    var onProgressChange: ((Int) -> Void)? // New closure for updating player position
    var onCountdownComplete: (() -> Void)?
    
    var start = Color(#colorLiteral(red: 0.9262059331, green: 0.9234025478, blue: 1, alpha: 1))
    var mid = Color(#colorLiteral(red: 0.9262059331, green: 0.9234025478, blue: 1, alpha: 1))
    var end = Color(#colorLiteral(red: 0.9262059331, green: 0.9234025478, blue: 1, alpha: 1))
    var backbar = Color(#colorLiteral(red: 0.269230932, green: 0.2702178657, blue: 0.2702003717, alpha: 1))
    
    @State private var timeRemainingString = ""
    @State private var timeCompletedString = ""
    @State private var dragOffset: CGFloat = 0
    @State private var isDragging = false // Flag to indicate dragging state

    private let totalWidth: CGFloat = 270 // Width of the progress bar
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    private func setTimeString() {
        let completedMinutes = timeCompletedInSeconds / 60
        let completedSeconds = timeCompletedInSeconds % 60
        timeCompletedString = String(format: "%02d:%02d", completedMinutes, completedSeconds)
        
        let remainingMinutes = timeRemainingInSeconds / 60
        let remainingSeconds = timeRemainingInSeconds % 60
        timeRemainingString = String(format: "%02d:%02d", remainingMinutes, remainingSeconds)
    }
    
    private func calculateProgressWidth() -> CGFloat {
        let progress = CGFloat(timeCompletedInSeconds) / CGFloat(totalTimeInSeconds)
        return totalWidth * progress
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(timeCompletedString)
                    .foregroundColor(.black)
                    .font(.subheadline)
                
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: 20)
                        .fill(backbar)
                        .frame(width: totalWidth, height: 3)
                    
                    // Foreground progress bar
                    RoundedRectangle(cornerRadius: 25)
                        .fill(
                            LinearGradient(
                                colors: [start, mid, end],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: calculateProgressWidth() + dragOffset, height: 3)

                    // Draggable handle
                    Circle()
                        .foregroundColor(.black)
                        .frame(width: 15, height: 15)
                        .offset(x: calculateProgressWidth() + dragOffset - 7.5)
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    isDragging = true // Set dragging state
                                    let clampedX = min(max(0, value.location.x), totalWidth)
                                    dragOffset = clampedX - calculateProgressWidth()
                                    
                                    let newTimeCompleted = Int((clampedX / totalWidth) * CGFloat(totalTimeInSeconds))
                                    timeCompletedInSeconds = min(newTimeCompleted, totalTimeInSeconds)
                                    timeRemainingInSeconds = totalTimeInSeconds - timeCompletedInSeconds
                                    setTimeString()
                                    
                                    // Notify about the progress change
                                    onProgressChange?(timeCompletedInSeconds)
                                }
                                .onEnded { _ in
                                    dragOffset = 0
                                    isDragging = false // Reset dragging state
                                }
                        )
                }
                
                Text(timeRemainingString)
                    .foregroundColor(.black)
                    .font(.subheadline)
            }
            .onAppear {
                setTimeString()
            }
            .onReceive(timer) { _ in
                guard !paused, !isDragging, timeRemainingInSeconds > 0 else { return }
                
                timeCompletedInSeconds = min(timeCompletedInSeconds + 1, totalTimeInSeconds)
                timeRemainingInSeconds = max(timeRemainingInSeconds - 1, 0)
                setTimeString()
                
                if timeRemainingInSeconds == 0 {
                    onCountdownComplete?()
                }
            }
        }
    }
}

//
//  FocusSpaceWidgetsLiveActivity.swift
//  FocusSpaceWidgets
//
//  Created by Panachai Sulsaksakul on 9/14/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct FocusSpaceWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerActivityAttributes.self) { context in
            // Lock screen/banner UI
            LockScreenLiveActivityView(context: context)
        } dynamicIsland: { context in
            // Dynamic Island UI
            DynamicIsland {
                // Expanded UI (when user long presses or gets update)
                DynamicIslandExpandedRegion(.leading) {
                    HStack(spacing: 8) {
                        Circle()
                            .fill(context.state.sessionType.color)
                            .frame(width: 16, height: 16)
                        VStack {
                            Text("Focus Session")
                                .font(.caption2)
                                .foregroundColor(.white)
                            
                            Text(context.state.sessionType.displayName)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    Text(timerInterval: Date()...context.state.endTime, countsDown: true)
                        .font(.title)
                        .fontWeight(.semibold)
                        .monospacedDigit()
                }
                /// Description
                /// might add back progress bar
                //                DynamicIslandExpandedRegion(.bottom) {
                //                    HStack {
                ////                        ProgressView(value: context.state.progress)
                ////                            .progressViewStyle(LinearProgressViewStyle(tint: context.state.sessionType.color))
                //                        Image(systemName: context.state.isRunning ? "pause.fill" : "play.fill")
                //                            .font(.caption)
                //                            .foregroundColor(.secondary)
                //                    }
                //                    .padding(.horizontal, 12)
                //                }
            } compactLeading: {
                // Compact leading (left side of notch) - main timer display
                Circle()
                    .fill(context.state.sessionType.color)
                    .frame(width: 16, height: 16)
            } compactTrailing: {
                // Compact trailing (right side of notch) - time display
                 Text(timerInterval: Date()...context.state.endTime, countsDown: true)
                    .font(.caption2)
                    .monospacedDigit()
                    .frame(width: 40)
            } minimal: {
                // Minimal state (when another activity takes priority)
                Circle()
                    .fill(context.state.sessionType.color)
                    .frame(width: 16, height: 16)
            }
            /// Description
            /// custom properties on dynamic island
            //            .contentMargins(.trailing, 32, for: .expanded)
            //            .contentMargins([.leading, .top, .bottom], 6, for: .compactLeading)
            //            .contentMargins(.all, 6, for: .minimal)
            //            .widgetURL(URL(string: "foodtruck://order/\(context.attributes.orderID)"))
        }
    }
}

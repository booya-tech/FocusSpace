//
//  AppRouter.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/23/25.
//
//  Navigation coordinator for the app

import SwiftUI

/// Centrailized navigation routing for the app
@MainActor
final class AppRouter: ObservableObject {
    @Published var currentRoute: Route = .timer

    enum Route {
        case auth
        case timer
        case dashboard
        case profile
    }

    func navigate(to route: Route) {
        currentRoute = route
    }
}

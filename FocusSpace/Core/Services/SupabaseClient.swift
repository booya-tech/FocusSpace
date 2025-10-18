//
//  SupabaseClient.swift
//  FocusSpace
//
//  Created by Panachai Sulsaksakul on 8/24/25.
//
//  Supabase configuration and client setup
//

import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()

    let client: SupabaseClient

    private init() {
        guard let supabaseURLString = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_URL") as? String, !supabaseURLString.isEmpty, let supabaseURL = URL(string: supabaseURLString) else {
            fatalError("Invalid or missing SUPABASE_URL configuration")
        }

        guard let supabaseKey = Bundle.main.object(forInfoDictionaryKey: "SUPABASE_ANON_KEY") as? String, !supabaseKey.isEmpty else {
            fatalError("Invalid or missing SUPABASE_ANON_KEY configuration")
        }

        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )

        #if DEBUG
        print("Supabase configured: \(supabaseURL.host ?? "unknown")")
        #endif
    } 
}

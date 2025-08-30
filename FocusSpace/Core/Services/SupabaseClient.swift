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
        guard let supabaseURL = URL(string: "https://ocsisshxfpqxqzocafxv.supabase.co") else { fatalError("Invalid Supabase URL configuration") }
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jc2lzc2h4ZnBxeHF6b2NhZnh2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYwMjM4MzksImV4cCI6MjA3MTU5OTgzOX0.T_-l_N3ufj9WDa4Q2BUkK-MR9ZbeFAGJu5yrFBS9IAc"

        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    } 
}

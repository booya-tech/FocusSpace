//
//  MonoTextField.swift
//  MonoTimer
//
//  Created by Panachai Sulsaksakul on 10/23/25.
//

import Foundation
import SwiftUI

struct MonoTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(12)
            .background(AppColors.background)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppColors.secondaryText.opacity(0.3), lineWidth: 1)
            )
    }
}

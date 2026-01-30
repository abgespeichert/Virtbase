//
//  WarningView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI

struct WarningView: View {
    var body: some View {
        VStack(spacing: 10) {
            
            Image(systemName: "person.fill.questionmark")
                .font(.system(size: 45))
                .foregroundStyle(.tertiary)
            
            Text("Nicht angemeldet")
                .font(.headline)
            
            Text("Sie sind nicht angemeldet. Bitte verbinden Sie sich mit dem Internet und melden Sie sich mit einem gültigen Schlüssel an.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
            
        }
    }
}

#Preview {
    WarningView()
}

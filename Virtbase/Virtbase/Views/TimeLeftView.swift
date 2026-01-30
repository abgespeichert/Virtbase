//
//  TimeLeftView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//

import SwiftUI

struct TimeLeftView: View {
    
    var expire: Date
    
    var expireDays: Int {
        Calendar.current.dateComponents(
            [.day],
            from: Date.now,
            to: expire
        ).day ?? 0
    }
    
    var body: some View {
        HStack {
            Image(systemName: "clock.fill")
            if expireDays == 1 {
                Text("Noch 1 Tag")
            } else {
                Text("Noch \(expireDays) Tage")
            }
        }
        .font(.subheadline)
        .foregroundStyle(.secondary)
    }
}

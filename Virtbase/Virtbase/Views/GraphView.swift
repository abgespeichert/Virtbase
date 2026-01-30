//
//  GraphView.swift
//  Virtbase
//
//  Created by Karl Ehrlich on 30.01.26.
//


import SwiftUI

struct GraphView: View {
    
    let samples: [ServerGraph]
    
    var body: some View {
        Canvas { context, size in
            
            guard samples.count > 1 else { return }
            
            let cpu      = normalized(\.processor)
            let ram      = normalized(\.memory)
            let diskRead = normalized(\.read)
            let diskWrite = normalized(\.write)
            let netIn    = normalized(\.incoming)
            let netOut   = normalized(\.outgoing)
            
            context.stroke(path(for: cpu, in: size), with: .color(.yellow), lineWidth: 2)
            context.stroke(path(for: ram, in: size), with: .color(.green), lineWidth: 2)
            context.stroke(path(for: diskWrite, in: size), with: .color(.teal), lineWidth: 2)
            context.stroke(path(for: diskRead, in: size), with: .color(.purple), lineWidth: 2)
            context.stroke(path(for: netIn, in: size), with: .color(.blue), lineWidth: 2)
            context.stroke(path(for: netOut, in: size), with: .color(.orange), lineWidth: 2)
        }
        .frame(minHeight: 220)
    }
    
    private func normalized(_ keyPath: KeyPath<ServerGraph, Double>) -> [CGFloat] {
        let values = samples.map { max(0, $0[keyPath: keyPath]) }
        guard let maxVal = values.max(), maxVal > 0 else {
            return values.map { _ in 0 }
        }
        return values.map { CGFloat($0 / maxVal) }
    }
    
    private func path(for values: [CGFloat], in size: CGSize) -> Path {
        var path = Path()
        guard values.count > 1 else { return path }
        
        let stepX = size.width / CGFloat(values.count - 1)
        
        let points: [CGPoint] = values.enumerated().map { index, value in
            CGPoint(
                x: CGFloat(index) * stepX,
                y: size.height * (1 - value)
            )
        }
        
        path.move(to: points[0])
        
        if points.count == 2 {
            path.addLine(to: points[1])
        } else {
            for i in 0..<(points.count - 1) {
                let p0 = i > 0 ? points[i - 1] : points[i]
                let p1 = points[i]
                let p2 = points[i + 1]
                let p3 = i + 2 < points.count ? points[i + 2] : points[i + 1]
                
                let segments = 20
                for t in 1...segments {
                    let t = CGFloat(t) / CGFloat(segments)
                    let tt = t * t
                    let ttt = tt * t
                    
                    let q0 = -ttt + 2 * tt - t
                    let q1 = 3 * ttt - 5 * tt + 2
                    let q2 = -3 * ttt + 4 * tt + t
                    let q3 = ttt - tt
                    
                    let x = 0.5 * (p0.x * q0 + p1.x * q1 + p2.x * q2 + p3.x * q3)
                    let y = 0.5 * (p0.y * q0 + p1.y * q1 + p2.y * q2 + p3.y * q3)
                    
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
        }
        
        return path
    }
}
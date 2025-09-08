//
//  SineWaveView.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 9/2/25.
//
import Foundation
import UIKit

//class SineWaveView: UIView {
//    private var phase: CGFloat = 0
//    private var displayLink: CADisplayLink?
//    private var amplitude: CGFloat = 30 // Wave height
//    private var frequency: CGFloat = 6.0 // Number of wave cycles
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        backgroundColor = .clear
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        backgroundColor = .clear
//    }
//    
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else { return }
//        
//        // Clear previous drawing
//        context.clear(rect)
//        
//        // Set up the wave properties
//        context.setStrokeColor(UIColor.systemBlue.cgColor)
//        context.setLineWidth(2.5)
//        context.setLineCap(.round)
//        context.setLineJoin(.round)
//        
//        let width = rect.width
//        let height = rect.height
//        let midY = height / 2
//        
//        // Create a smoother path
//        let path = UIBezierPath()
//        
//        for i in 0...Int(width) {
//            let x = CGFloat(i)
//            let normalizedX = x / width
//            let y = sin(normalizedX * frequency * 2 * .pi + phase) * amplitude + midY
//            
//            if i == 0 {
//                path.move(to: CGPoint(x: x, y: y))
//            } else {
//                path.addLine(to: CGPoint(x: x, y: y))
//            }
//        }
//        
//        // Draw the path
//        context.addPath(path.cgPath)
//        context.strokePath()
//    }
//    
//    func startAnimating() {
//        displayLink?.invalidate() // Make sure we don't have multiple running
//        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
//        displayLink?.preferredFramesPerSecond = 60 // Smooth 60fps
//        displayLink?.add(to: .main, forMode: .common) // Use .common instead of .default
//    }
//    
//    func stopAnimating() {
//        displayLink?.invalidate()
//        displayLink = nil
//    }
//    
//    @objc private func updateWave() {
//        phase += 0.08 // Slower, smoother animation
//        setNeedsDisplay()
//    }
//    
//    // Clean up when view is removed
//    deinit {
//        stopAnimating()
//    }
//}
class SineWaveView: UIView {
    private var phase: CGFloat = 0
    private var displayLink: CADisplayLink?
    private var amplitude: CGFloat = 50 // Taller waves
    private var frequency: CGFloat = 6.0 // More frequent waves
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.clear(rect)
        
        let width = rect.width
        let height = rect.height
        let midY = height / 2
        
        // Draw two waves with complementary colors
        drawWave(context: context, rect: rect, amplitude: amplitude, color: .systemBlue, alpha: 0.8, phaseOffset: 0, lineWidth: 2.0)
        drawWave(context: context, rect: rect, amplitude: amplitude * 0.6, color: .systemPurple, alpha: 0.6, phaseOffset: 0.5, lineWidth: 1.5)
    }
    
    private func drawWave(context: CGContext, rect: CGRect, amplitude: CGFloat, color: UIColor, alpha: CGFloat, phaseOffset: CGFloat, lineWidth: CGFloat) {
        let width = rect.width
        let height = rect.height
        let midY = height / 2
        
        // Use the specified color with alpha
        context.setStrokeColor(color.withAlphaComponent(alpha).cgColor)
        context.setLineWidth(lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        let path = UIBezierPath()
        let step: CGFloat = 1.5 // Smooth curve
        
        for i in stride(from: 0, through: width, by: step) {
            let normalizedX = i / width
            let y = sin(normalizedX * frequency * 2 * .pi + phase + phaseOffset) * amplitude + midY
            
            if i == 0 {
                path.move(to: CGPoint(x: i, y: y))
            } else {
                path.addLine(to: CGPoint(x: i, y: y))
            }
        }
        
        context.addPath(path.cgPath)
        context.strokePath()
    }
    
    func startAnimating() {
        displayLink?.invalidate()
        displayLink = CADisplayLink(target: self, selector: #selector(updateWave))
        displayLink?.preferredFramesPerSecond = 60
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateWave() {
        phase += 0.06 // Smooth animation speed
        setNeedsDisplay()
    }
    
    deinit {
        stopAnimating()
    }
}

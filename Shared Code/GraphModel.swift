//
//  GraphModel.swift
//  MathTutor
//
//  Created by Keith on 10/09/2017.
//  Copyright © 2017 Keith. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

enum Orientation {
    case horizontal
    case vertical
}

/// Defines the type of axis - bottom, top, left, or right
enum AxisType {
    case bottom
    case top
    case left
    case right
}
enum TickType {
    case major
    case minor
}

class Graph {
    private (set) var axes: [AxisType:Axis]
    init(title: String = "", minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        axes[.bottom] = Axis(type: .bottom, min: minX, max: maxX, title: "Angle 𝜃")
    }
}


struct Axis: LineStyled {
    var lineStyle: LineStyle { return axisLine.lineStyle }
    var axisLine: AnchoredLine
    var type: AxisType
    var min: Double
    var max: Double
    var firstMajorTick: Double
    var showMajorTicks: Bool = false
    var showMinorTicks: Bool = false
    var majorTickSeparation: Double
    var minorTicksPerMajorTick: Int = 4
    var title: String? = nil
    var majorTickStyle: TickStyle
    var minorTicStyle: TickStyle
    var minorTickSeparation: Double { return majorTickSeparation / Double(minorTicksPerMajorTick + 1) }
    
    func generateTicks() -> [TickMark] {
        var ticks = [TickMark]()
        var p = firstMajorTick
        var tickIndex: Int = 0
        while p <= max {
            let style = createStyleForIndex(tickIndex)
            ticks.append(createTickMark(pos: p, style: style))
            p = Double(tickIndex) * minorTickSeparation
            tickIndex += 1
        }
    }
    
    func createTickMark(pos: Double, style: TickStyle) -> TickMark {
        
    }
    
    func createStyleForIndex(_ index:Int) -> TickStyle {
        switch tickTypeForIndex(index) {
        case .major:
            return TickStyle(lineStyle: LineStyle(lineWidthPoints: 4.0), tickToLabelSeparationPoints: 4.0, isLabelled: true)
        case .minor:
            return TickStyle(lineStyle: LineStyle(lineWidthPoints: 2.0), tickToLabelSeparationPoints: 4.0, isLabelled: false)
        }
    }
    
    /// Returns the type of tick (eg major or minor) for the specified index
    ///
    /// - parameter index: the number of ticks (of any sort) between the current tick and the first major tick
    func tickTypeForIndex(_ index:Int) -> TickType {
        return index % (minorTicksPerMajorTick+1) == 0 ? .major : .minor
    }
}

/// A tickmark consists of the value it represents, and an anchored line representing the lick itself, and a label 
struct TickMark {
    var formatter: NumberFormatter
    /// The line of the tick mark
    var line: AnchoredLine
    /// value the tickmark indicates
    var value: Double
    
    /// The text that should appear in the label the tick
    lazy var tickLabel: String = {
        let value = NSNumber(value: self.value)
        return self.formatter.string(from: value)!
    }()
    
    /// The gap between the end of the tick's line and its label
    var lineToLabelGap: CGFloat
}

struct TickStyle : LineStyled {
    var lineStyle: LineStyle = LineStyle(lineWidthPoints: 2)
    /// The gap in points between the end of the tick and its label
    var tickToLabelSeparationPoints: CGFloat = 4
    /// True if the tick is to be labelled, otherwise false
    var isLabelled: Bool = false
}

protocol LineStyled {
    var lineStyle: LineStyle { get }
}

struct LineStyle {
    var lineWidthPoints: CGFloat
    var lineColor: UIColor
    init(lineWidthPoints: CGFloat = 4, lineColor: UIColor = UIColor.black) {
        self.lineWidthPoints = lineWidthPoints
        self.lineColor = lineColor
    }
}

/// A styled line drawn from an anchor point in a specified direction and with a specifed length
struct AnchoredLine : LineStyled {
    /// Anchor x coordinate
    var xAnchor: Double
    /// Anchor y coordinate
    var yAnchor: Double
    /// length
    var length: Double
    /// direction
    var direction: Orientation
    /// styling
    var lineStyle: LineStyle
}


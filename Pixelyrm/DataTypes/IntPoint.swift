//
//  IntPoint.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 6/16/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import CoreGraphics

public struct IntPoint: Hashable, Codable {
    let x: Int
    let y: Int
    
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    public init(point: CGPoint) {
        self.x = Int(point.x)
        self.y = Int(point.y)
    }
}

extension IntPoint {
    static var zero: IntPoint { .init(x: 0, y: 0) }
    
    public func offset(x: Int, y: Int) -> IntPoint {
        return IntPoint(x: self.x + x, y: self.y + y)
    }
    
    public func validOffset(x: Int, y: Int, size: IntSize) -> IntPoint? {
        guard self.x + x >= 0, self.x + x <= size.width - 1, self.y + y >= 0, self.y + y <= size.height - 1 else {
            return nil
        }
        return IntPoint(x: self.x + x, y: self.y + y)
    }
    
    public func adjacent4Points(size: IntSize) -> [IntPoint] {
        var points: [IntPoint] = []
        // TODO: Check if the size is big enough? EX: Not a 1x1 pixel
        if x > 0 {
            points.append(offset(x: -1, y: 0))
        }
        if x < size.width - 1 {
            points.append(offset(x: 1, y: 0))
        }
        if y > 0 {
            points.append(offset(x: 0, y: -1))
        }
        if y < size.height - 1 {
            points.append(offset(x: 0, y: 1))
        }
        return points
    }
    
    public func adjacent8Points(size: IntSize) -> [IntPoint] {
        var points: [IntPoint] = []
        // TODO: Check if the size is big enough? EX: Not a 1x1 pixel
        if x > 0 {
            points.append(offset(x: -1, y: 0))
        }
        if x < size.width - 1 {
            points.append(offset(x: 1, y: 0))
        }
        if y > 0 {
            points.append(offset(x: 0, y: -1))
        }
        if y < size.height - 1 {
            points.append(offset(x: 0, y: 1))
        }
        if let topLeftPoint = validOffset(x: -1, y: -1, size: size) {
            points.append(topLeftPoint)
        }
        if let topRightPoint = validOffset(x: 1, y: -1, size: size) {
            points.append(topRightPoint)
        }
        if let bottomLeftPoint = validOffset(x: -1, y: 1, size: size) {
            points.append(bottomLeftPoint)
        }
        if let bottomRightPoint = validOffset(x: 1, y: 1, size: size) {
            points.append(bottomRightPoint)
        }
        return points
    }
    
    public func addingAdjacent8Points(size: IntSize) -> [IntPoint] {
        var points: [IntPoint] = [self]
        if x > 0 {
            points.append(offset(x: -1, y: 0))
        }
        if x < size.width - 1 {
            points.append(offset(x: 1, y: 0))
        }
        if y > 0 {
            points.append(offset(x: 0, y: -1))
        }
        if y < size.height - 1 {
            points.append(offset(x: 0, y: 1))
        }
        if let topLeftPoint = validOffset(x: -1, y: -1, size: size) {
            points.append(topLeftPoint)
        }
        if let topRightPoint = validOffset(x: 1, y: -1, size: size) {
            points.append(topRightPoint)
        }
        if let bottomLeftPoint = validOffset(x: -1, y: 1, size: size) {
            points.append(bottomLeftPoint)
        }
        if let bottomRightPoint = validOffset(x: 1, y: 1, size: size) {
            points.append(bottomRightPoint)
        }
        return points
    }
}

extension CGPoint {
    public var intPoint: IntPoint { .init(x: Int(x), y: Int(y)) }
}

//
//  Math.swift
//  iBun
//
//  Created by h on 22.06.17.
//  Copyright © 2017 h. All rights reserved.
//

import Foundation

/* Adding points together */
func + (left: CGPoint, right : CGPoint) -> CGPoint
{
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
func - (left: CGPoint, right : CGPoint) -> CGPoint
{
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
func += ( left: inout CGPoint, right: CGPoint)
{
    left = left + right
}
func -= ( left: inout CGPoint, right: CGPoint)
{
    left = left + right
}
/* Working with scalars */
func + (left: CGPoint, right: CGFloat) -> CGPoint
{
    return CGPoint(x: left.x + right, y: left.y + right)
}
func - (left: CGPoint, right: CGFloat) -> CGPoint
{
    return left + (-right)
}
func * (left: CGPoint, right: CGFloat) -> CGPoint
{
    return CGPoint(x: left.x * right, y: left.y * right)
}
func / (left: CGPoint, right: CGFloat) -> CGPoint
{
    return CGPoint(x: left.x / right, y: left.y / right)
}
func += ( left: inout CGPoint, right: CGFloat)
{
    left = left + right
}
func -= ( left: inout CGPoint, right: CGFloat)
{
    left = left - right
}
func *= ( left: inout CGPoint, right: CGFloat)
{
    left = left * right
}
func /= ( left: inout CGPoint, right: CGFloat)
{
    left = left / right
}
//extend the CGPoint type to add properties like length and normalized:
extension CGPoint
{
    var length : CGFloat
    {
        return sqrt(self.x * self.x + self.y * self.y)
    }
    var normalized : CGPoint
    {
        return self / length
    }
    func rotatedBy(radians : CGFloat) -> CGPoint
    {
        var rotatedPoint = CGPoint(x: 0, y: 0)
        rotatedPoint.x = self.x * cos(radians) - self.y * sin(radians)
        rotatedPoint.y = self.y * cos(radians) + self.x * sin(radians)
        return rotatedPoint
    }
    func dot(other : CGPoint) -> CGFloat
    {
        return self.x * other.x + self.y * other.y
    }
    init (angleRadians : CGFloat)
    {
        self.x = sin(angleRadians)
        self.y = cos(angleRadians)
    }
}

//
//  XView.swift
//  Lecture07
//
//  Created by Van Simmons on 7/8/19.
//  Copyright © 2019 ComputeCycles, LLC. All rights reserved.
//

import UIKit

struct DummyGrid: GridDataSource {
    var size = GridSize(10,10)
    var allPositions: [Position] {
        return (0 ..< size.rows).flatMap { zip( [Int](repeating: $0, count: size.cols) , 0 ..< size.cols ) }
    }
    var cellStates: [[CellState]] = (0 ..< 10).map { row in (0 ..< 10).map { col in .empty } }
}

@IBDesignable class XView: UIView {
    @IBInspectable var inset = CGFloat(2.0)
    @IBInspectable var lineWidth: CGFloat = 2.0
    @IBInspectable var lineColor: UIColor = .black
    @IBInspectable var aliveColor: UIColor = .green
    @IBInspectable var deadColor: UIColor = .black
    
    var dataSource: GridDataSource! = DummyGrid()
    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = false
        let rect = CGRect(
            x: rect.origin.x + (lineWidth/2.0),
            y: rect.origin.y + (lineWidth/2.0),
            width: rect.size.width - lineWidth,
            height: rect.size.height - lineWidth
        )
        
        let horizontalSpacing = rect.size.width / CGFloat(dataSource.size.rows)
        let horizontalXStart = rect.origin.x
        let horizontalXEnd = rect.origin.x + rect.size.width
        
        let verticalSpacing = rect.size.height / CGFloat(dataSource.size.cols)
        let verticalYStart = rect.origin.y
        let verticalYEnd = rect.origin.y + rect.size.height
        
        // Horizontal lines
        (0 ... dataSource.size.rows).forEach { index in
            let x = (CGFloat(index) * horizontalSpacing) + rect.origin.x
            let startPoint = CGPoint(x: x, y: verticalYStart)
            let endPoint = CGPoint(x: x, y: verticalYEnd)
            
            let verticalPath = UIBezierPath()
            verticalPath.lineWidth = lineWidth
            verticalPath.move(to: startPoint)
            verticalPath.addLine(to: endPoint)
            lineColor.setStroke()
            verticalPath.stroke()
        }
        
        // Vertical lines
        (0 ... dataSource.size.cols).forEach { index in
            let y = (CGFloat(index) * verticalSpacing) + rect.origin.y
            let startPoint = CGPoint(x: horizontalXStart, y: y)
            let endPoint = CGPoint(x: horizontalXEnd, y: y)
            
            let horizontalPath = UIBezierPath()
            horizontalPath.lineWidth = lineWidth
            horizontalPath.move(to: startPoint)
            horizontalPath.addLine(to: endPoint)
            lineColor.setStroke()
            horizontalPath.stroke()
        }
        
        // Cells
        dataSource.allPositions.forEach { (row, col) in
            let xOrigin = (CGFloat(col) * verticalSpacing) + rect.origin.x
            let yOrigin = (CGFloat(row) * horizontalSpacing) + rect.origin.y
            //let cellRect = CGRect( x: xOrigin, y: yOrigin, width: verticalSpacing, height: horizontalSpacing)
            
            let cellRect = CGRect(
                x: xOrigin + inset + (lineWidth / 2.0),
                y: yOrigin  + inset + (lineWidth / 2.0),
                width: verticalSpacing - ((2.0 * inset) + (lineWidth)),
                height: horizontalSpacing - ((2.0 * inset) + (lineWidth))
            )
            
            let path = UIBezierPath(ovalIn: cellRect)
            switch dataSource.cellStates[row][col] {
            case .alive, .born: aliveColor.setFill()
            case .died, .empty: deadColor.setFill()
            }
            path.fill()
        }
    }
    
    func convert(touch: UITouch) -> Position? {
        let touchY = touch.location(in: self).y - (lineWidth/2.0)
        let gridHeight = frame.size.height - lineWidth
        let row = touchY / gridHeight * CGFloat(dataSource.size.rows)
        
        let touchX = touch.location(in: self).x - (lineWidth/2.0)
        let gridWidth = frame.size.width - lineWidth
        let col = touchX / gridWidth * CGFloat(dataSource.size.cols)
        
        let pos = Position(row: Int(row), col: Int(col))
        guard pos.row >= 0 && pos.row < dataSource.size.rows && pos.col >= 0 && pos.col < dataSource.size.cols
            else { return nil }
        return pos
    }
    
    var lastPosition: Position?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        dataSource.cellStates[pos.row][pos.col] = dataSource.cellStates[pos.row][pos.col].isAlive ? .empty : .alive
        lastPosition = pos
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard touches.count == 1 else { return }
        let touch = touches.first!
        guard let pos = convert(touch: touch) else { return }
        guard pos.row != lastPosition?.row || pos.col != lastPosition?.col else { return }
        dataSource.cellStates[pos.row][pos.col] = dataSource.cellStates[pos.row][pos.col].isAlive ? .empty : .alive
        lastPosition = pos
        setNeedsDisplay()
    }
}

//
//  GridView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/22/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

enum GridViewLayout {
    
    /// Goes from left to right filling the width of the view
    case wrapToNextLine(proxy: GeometryProxy, maxRows: Int)
    
    /// This causes views to be centered if they don't fill the screen
    case rows(_ rows: Int)
    
    /// Only have `columns` number of cells per row
    case maxColumns(_ columns: Int)
    
    func numberOfColumns(forColorCount count: Int, cellSize: CGSize, padding: CGSize) -> Int {
        switch self {
        case .wrapToNextLine(let geometry, let maxRows):
            let columnsPerRow = Int(max(1, floor((geometry.size.width) / (cellSize.width + padding.width))))
            let columns = Int(ceil((CGFloat(count) / CGFloat(maxRows))))
            if columns > columnsPerRow {
                return columns
            } else {
                return columnsPerRow
            }
        case .rows(let rows):
            return Int(ceil(Float(count) / Float(rows)))
        case .maxColumns(let columns):
            return columns
        }
    }
}

struct GridView<Content: View> : View {
    
    enum CellSize {
        case flexibleWidth(height: CGFloat)
        case flexibleHeight(width: CGFloat)
        case custom(width: CGFloat, height: CGFloat)
    }
    
    let maxColumns: Int
    let cellSize: CGSize
    let cellPadding: CGSize
    let count: Int
    let view: (_ index: Int) -> Content
    
    public init(layout: GridViewLayout, cellSize: CGSize = .init(width: 32, height: 32), cellPadding: CGSize = .init(width: 2, height: 2), count: Int, view: @escaping (_ index: Int) -> Content) {
        self.maxColumns = layout.numberOfColumns(forColorCount: count, cellSize: cellSize, padding: cellPadding)
        self.cellPadding = cellPadding
        self.cellSize = cellSize
        self.count = count
        self.view = view
    }
    
    private func rowStack() -> some View {
        let columns = max(1, maxColumns)
        let rows = ceil(CGFloat(self.count) / CGFloat(columns))
        
        let maxHeight = rows * (cellSize.height + cellPadding.height)
        let maxWidth = (CGFloat(columns) * (cellSize.width + cellPadding.width))
        
        return VStack(alignment: .leading, spacing: cellPadding.height) {
            ForEach(0..<Int(rows), id: \.self) { row in
                self.columns(row: row, columnsPerRow: columns)
            }
        }
        .frame(minWidth: 0, idealWidth: maxWidth, maxWidth: maxWidth, minHeight: 0, idealHeight: maxHeight, maxHeight: maxHeight, alignment: .topLeading)
    }
    
    private func columns(row: Int, columnsPerRow: Int) -> some View {
        let columns = count - row * columnsPerRow < columnsPerRow ? (count % columnsPerRow) : columnsPerRow
        let rowStartIndex = row * columnsPerRow
        return HStack(spacing: cellPadding.width) {
            ForEach(0..<Int(columns), id: \.self) { column in
                return self.view(rowStartIndex + column)
                    .frame(width: self.cellSize.width, height: self.cellSize.height)
            }
//            Spacer() // TODO: Remove?
        }
    }
    
    var body: some View {
        self.rowStack()
    }
}

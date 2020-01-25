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
    
    func numberOfColumns(itemCount: Int, cellSize: CGSize, padding: CGSize) -> Int {
        switch self {
        case .wrapToNextLine(let geometry, let maxRows):
            let columnsPerRow = Int(max(1, floor((geometry.size.width) / (cellSize.width + padding.width))))
            let columns = Int(ceil((CGFloat(itemCount) / CGFloat(maxRows))))
            if columns > columnsPerRow {
                return columns
            } else {
                return columnsPerRow
            }
        case .rows(let rows):
            return Int(ceil(Float(itemCount) / Float(rows)))
        case .maxColumns(let columns):
            return columns
        }
    }
}

struct GridView<Item: Any & Identifiable, Content: View> : View {
    
    typealias ViewForItemClosure = (_ item: Item, _ index: Int) -> Content
    
    enum CellSize {
        case flexibleWidth(height: CGFloat)
        case flexibleHeight(width: CGFloat)
        case custom(width: CGFloat, height: CGFloat)
    }
    
    let maxColumns: Int
    let cellSize: CGSize
    let cellPadding: CGSize
    let items: [Item]
    let view: ViewForItemClosure
    
    public init(layout: GridViewLayout, cellSize: CGSize = .init(width: 32, height: 32), cellPadding: CGSize = .init(width: 2, height: 2), items: [Item], view: @escaping ViewForItemClosure) {
        self.maxColumns = layout.numberOfColumns(itemCount: items.count, cellSize: cellSize, padding: cellPadding)
        self.cellPadding = cellPadding
        self.cellSize = cellSize
        self.items = items
        self.view = view
    }
    
    private func rowStack() -> some View {
        let columns = max(1, maxColumns)
        let rows = ceil(CGFloat(items.count) / CGFloat(columns))
        
        let maxHeight = rows * (cellSize.height + cellPadding.height)
        let maxWidth = (CGFloat(columns) * (cellSize.width + cellPadding.width))
        
        return VStack(alignment: .leading, spacing: cellPadding.height) {
            ForEach(0..<Int(rows), id: \.self) { row in
                self.columns(row: row, columnsPerRow: columns)
            }
        }
        .frame(minWidth: 0, idealWidth: maxWidth, maxWidth: maxWidth, minHeight: 0, idealHeight: maxHeight, maxHeight: maxHeight, alignment: .topLeading)
    }
    
    func contentView(item: Item, nextIndex: inout Int, indexOffset: Int) -> Content {
        let index = nextIndex + indexOffset
        nextIndex += 1
        return self.view(items[index], index)
    }
    
    private func columns(row: Int, columnsPerRow: Int) -> some View {
        let columns = items.count - row * columnsPerRow < columnsPerRow ? (items.count % columnsPerRow) : columnsPerRow
        let rowStartIndex = row * columnsPerRow
        let itemsForRow = items[rowStartIndex..<Int(rowStartIndex + columns)]
        var index = 0
        return HStack(spacing: cellPadding.width) {
            return ForEach(itemsForRow) { item in
                return self.contentView(item: item, nextIndex: &index, indexOffset: rowStartIndex)
                    .frame(width: self.cellSize.width, height: self.cellSize.height)
            }
        }
    }
    
    var body: some View {
        self.rowStack()
    }
}

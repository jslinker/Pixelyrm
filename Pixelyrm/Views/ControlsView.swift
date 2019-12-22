//
//  ControlsView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/9/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import Foundation
import SwiftUI

struct ControlsView<Content: View> : View {
    
    let verticalPadding: CGFloat
    let horizontalPadding: CGFloat
    let cellSize: CGSize
    let count: Int
    let view: (_ index: Int) -> Content
    
    public init(verticalPadding: CGFloat = 4, horizontalPadding: CGFloat = 4, cellSize: CGSize = .init(width: 32, height: 32), count: Int, view: @escaping (_ index: Int) -> Content) {
        self.verticalPadding = verticalPadding
        self.horizontalPadding = horizontalPadding
        self.cellSize = cellSize
        self.count = count
        self.view = view
    }
    
    private func rows(sizeSettings: SizeToFitViewSizeSettings) -> some View {
        let columns = max(1, floor((sizeSettings.parentSize.width - self.horizontalPadding * 2) / (self.cellSize.width + self.horizontalPadding))) // Must be a non 0 value, size.width is set after initial layout
        let rows = Int(ceil(CGFloat(self.count) / columns))
            return VStack(alignment: .leading, spacing: self.verticalPadding) {
                ForEach(0..<rows, id: \.self) { row in
                    self.columns(row: row, columnsPerRow: Int(columns))
                }
            }
    }
    
    private func columns(row: Int, columnsPerRow: Int) -> some View {
        let columns = count - row * columnsPerRow < columnsPerRow ? (count % columnsPerRow) : columnsPerRow
        let rowStartIndex = row * columnsPerRow
        return HStack(spacing: self.horizontalPadding) {
            ForEach(0..<Int(columns), id: \.self) { column in
                return self.view(rowStartIndex + column)
                    .frame(width: self.cellSize.width, height: self.cellSize.height)
            }
            Spacer()
        }
    }
    
    var body: some View {
        SizeToFitView { sizeSettings in
            self.rows(sizeSettings: sizeSettings)
        }
    }
}

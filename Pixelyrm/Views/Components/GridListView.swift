//
//  GridListView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/24/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

struct GridListView<Item: Any & Identifiable, Content: View> : View {
    
    typealias CellClosure = (_ item: Item, _ index: Int) -> Content
    typealias DidSelectClosure = ((_ item: Item, _ index: Int) -> Void)?
    
    let items: [Item]
    let cellSize: CGSize
    let layout: GridViewLayout
    var cell: CellClosure
    var didSelect: DidSelectClosure

    public init(items: [Item], layout: GridViewLayout, cellSize: CGSize = .init(width: 32, height: 32), cellForItem: @escaping CellClosure, didSelect: DidSelectClosure) {
        self.items = items
        self.layout = layout
        self.cellSize = cellSize
        self.cell = cellForItem
        self.didSelect = didSelect
    }

    var body: some View {
        GridView(layout: layout,
                 cellSize: cellSize,
                 items: items) { item, index -> Button<Content> in
                    Button(action: {
                        self.didSelect?(item, index)
                    }) {
                        self.cell(item, index)
                    }
        }
    }

}

//
//  SizeToFitView.swift
//  Pixelyrm
//
//  Created by Michael Daniels on 12/21/19.
//  Copyright © 2019 Michael Daniels. All rights reserved.
//

import SwiftUI

class SizeToFitViewSizeSettings: ObservableObject {
    var safeAreaInsets: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
    var parentSize: CGSize = .init(width: 1, height: 1)
    var frame: CGRect = .init(x: 0, y: 0, width: 1, height: 1)
}

struct SizeToFitView<Content: View>: View {
    @State var sizeSettings: SizeToFitViewSizeSettings = .init()
    @State var height: CGFloat = 0
    public var content: (SizeToFitViewSizeSettings) -> Content
    
    var body: some View {
        content(sizeSettings)
        .background(PreferenceSizeSetterView())
        .onPreferenceChange(PreferenceSizeSetterRectKey.self) { preferences in
            for preference in preferences {
                self.height = preference.frame.height
                self.sizeSettings.frame = preference.frame
                self.sizeSettings.parentSize = preference.parentSize
                self.sizeSettings.safeAreaInsets = preference.safeAreaInsets
            }
        }
        .frame(height: height)
    }
}

struct PreferenceSizeSetterRectData: Equatable {
    let frame: CGRect
    let parentSize: CGSize
    let safeAreaInsets: EdgeInsets
}

struct PreferenceSizeSetterRectKey: PreferenceKey {
    typealias Value = [PreferenceSizeSetterRectData]
    static var defaultValue: [PreferenceSizeSetterRectData] = []
    static func reduce(value: inout [PreferenceSizeSetterRectData], nextValue: () -> [PreferenceSizeSetterRectData]) {
        value.append(contentsOf: nextValue())
    }
}

struct PreferenceSizeSetterView: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: PreferenceSizeSetterRectKey.self,
                            value: [PreferenceSizeSetterRectData(frame: geometry.frame(in: .global), parentSize: geometry.size, safeAreaInsets: geometry.safeAreaInsets)])
        }
    }
}

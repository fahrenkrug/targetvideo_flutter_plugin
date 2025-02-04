//
//  NativeVideoViewFactory 2.swift
//  Pods
//
//  Created by Ogi on 4.2.25..
//

import Flutter
import UIKit

public class NativeVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    private var views: [Int64: NativeVideoView] = [:]

    public override init() {
        super.init()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        let view = NativeVideoView(frame: frame)
        views[viewId] = view
        return view
    }

    public func getView(byId viewId: Int64) -> UIView? {
        return views[viewId]?.view()
    }
}

public class NativeVideoView: NSObject, FlutterPlatformView {
    private let containerView: UIView

    public init(frame: CGRect) {
        self.containerView = UIView(frame: frame)
        super.init()
        setupView()
    }

    private func setupView() { }

    public func view() -> UIView {
        return containerView
    }
}

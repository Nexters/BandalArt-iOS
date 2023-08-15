//
//  LoadingView.swift
//  Components
//
//  Created by Youngmin Kim on 2023/08/15.
//  Copyright © 2023 otani. All rights reserved.
//

import UIKit
import Lottie


public final class LoadingView: UIView {
    
    public static func startAnimatingOnWindow(alpha: CGFloat = 1.0) {
        guard !isAnimatingOnWindow,
              let keyWindow = UIApplication.shared.keyWindow,
              findLoadingView(from: keyWindow).isEmpty else { return }
        isAnimatingOnWindow = true
        attachLoadingIndicatorView(superview: keyWindow).show(alpha: alpha)
    }

    public static func stopAnimatingOnWindow() {
        guard isAnimatingOnWindow,
              let keyWindow = UIApplication.shared.keyWindow else { return }
        detachLoadingIndicatorViews(superview: keyWindow)
        isAnimatingOnWindow = false
    }
    
    public private(set) static var isAnimatingOnWindow: Bool = false
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = UI.backgroundViewWidth / 2
        if #available(iOS 13.0, *) {
            view.layer.cornerCurve = .continuous
        }
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let animationView: LottieAnimationView = {
        let view = LottieAnimationView()
        view.animation = LottieAnimation.named("Loading")
        view.animationSpeed = 1.0
        view.loopMode = .loop
        view.backgroundBehavior = .pauseAndRestore
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private enum UI {
        static let animationViewWidth: CGFloat = 50
        static let backgroundViewWidth: CGFloat = 58
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupConstraints()
    }
    
    func show(alpha: CGFloat) {
        if alpha < 1.0 {
            backgroundColor = UIColor.black.withAlphaComponent(alpha)
        } else {
            backgroundColor = UIColor.white.withAlphaComponent(alpha)
        }
        animationView.play()
    }

    func hide() {
        animationView.stop()
    }
}

private extension LoadingView {
    
    func setupUI() {
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backgroundView.addSubview(animationView)
        addSubview(backgroundView)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
            animationView.widthAnchor.constraint(equalToConstant: UI.animationViewWidth),
            animationView.heightAnchor.constraint(equalTo: animationView.widthAnchor),
            
            backgroundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundView.widthAnchor.constraint(equalToConstant: UI.backgroundViewWidth),
            backgroundView.heightAnchor.constraint(equalTo: backgroundView.widthAnchor),
        ])
    }
}

// MARK: - Private static methods

extension LoadingView {
    
    static func attachLoadingIndicatorView(
        superview window: UIWindow
    ) -> LoadingView {
        let loadingIndicatorView = LoadingView()
        setup(window: window, subview: loadingIndicatorView)
        setupConstraints(window: window, subview: loadingIndicatorView)
        return loadingIndicatorView
    }

    static func setup(window: UIWindow, subview: LoadingView) {
        window.addSubview(subview)
    }

    static func setupConstraints(window: UIWindow, subview: LoadingView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            subview.trailingAnchor.constraint(equalTo: window.trailingAnchor),
            subview.topAnchor.constraint(equalTo: window.topAnchor),
            subview.bottomAnchor.constraint(equalTo: window.bottomAnchor)
        ])
    }

    static func detachLoadingIndicatorViews(superview window: UIWindow) {
        let loadingViews = findLoadingView(from: window)
        loadingViews.forEach {
            $0.removeFromSuperview()
        }
    }

    static func findLoadingView(from superview: UIView) -> [LoadingView] {
        let loadingViews = superview.subviews.compactMap { $0 as? LoadingView }
        return loadingViews
    }
}

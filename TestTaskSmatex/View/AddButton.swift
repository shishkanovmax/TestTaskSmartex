//
//  AddButton.swift
//  TestTaskSmatex
//
//  Created by Максим Шишканов on 20.07.2023.
//

import UIKit

protocol AddButtonDelegate: AnyObject {
    func addButtonDidTapped()
}

final class AddButton: UIButton {
    // MARK: - Constants
    private let buttonSize: CGFloat = 48
    private let initialInset: CGFloat = 20

    private var dragMode = false {
        didSet {
            guard dragMode != oldValue else { return }
            dragMode ? increazeButton() : decreaseButton()
        }
    }

    private let keyWindow = UIApplication.shared.windows.first!

    private weak var delegate: AddButtonDelegate?
    private var timer: Timer?

    init(delegate: AddButtonDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupTarget()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupInitialFrame()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.1) { self.backgroundColor = .systemBlue.lighter }

        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false, block: { [weak self] _ in
            self?.dragMode = true
        })
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)

        timer?.invalidate()

        guard
            dragMode,
            let touch = touches.first,
            let superview = self.superview
        else { return }

        let positionInSuperview = touch.location(in: superview)

        guard isLocationInsideWindow(location: positionInSuperview) else { return }
        self.center = positionInSuperview
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        returnToDefaultState()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        returnToDefaultState()
    }


    private func increazeButton() {
        callHaptic()
        animateSizeChanging { self.transform = CGAffineTransform(scaleX: 1.3, y: 1.3) }
    }

    private func decreaseButton() {
        callHaptic()
        animateSizeChanging { self.transform = .identity }
    }

    private func callHaptic() {
        let notificationFeedbackGenerator = UINotificationFeedbackGenerator()
        notificationFeedbackGenerator.prepare()
        notificationFeedbackGenerator.notificationOccurred(.success)
    }

    private func animateSizeChanging(_ animations: @escaping () -> Void) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.3
        ) {
            animations()
        }
    }

    private func setupInitialFrame() {
        frame = .init(
            origin: .init(
                x: keyWindow.frame.width - initialInset - buttonSize,
                y: keyWindow.frame.height - buttonSize - keyWindow.safeAreaInsets.bottom
            ),
            size: .init(width: buttonSize, height: buttonSize)
        )
    }

    private func setupTarget() {
        addAction(
            UIAction { [weak self] _ in
                guard self?.dragMode != true else { return }
                self?.delegate?.addButtonDidTapped()
            },
            for: .touchUpInside
        )
    }

    private func setupLayout() {
        backgroundColor = .systemBlue
        layer.cornerRadius = buttonSize / 2

        let verticalStick = getPlusPart()
        let horizontalStick = getPlusPart()

        addSubview(verticalStick)
        addSubview(horizontalStick)

        verticalStick.translatesAutoresizingMaskIntoConstraints = false
        horizontalStick.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            verticalStick.widthAnchor.constraint(equalToConstant: 4),
            verticalStick.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            verticalStick.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            verticalStick.centerXAnchor.constraint(equalTo: centerXAnchor),

            horizontalStick.heightAnchor.constraint(equalToConstant: 4),
            horizontalStick.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            horizontalStick.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            horizontalStick.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func getPlusPart() -> UIView {
        let view = UIView()
        view.isUserInteractionEnabled = false
        view.backgroundColor = .white
        return view
    }

    private func isLocationInsideWindow(location: CGPoint) -> Bool {
        let limit = (buttonSize * 1.3) / 2

        return location.x + limit < keyWindow.frame.width &&
        location.x - limit > 0 &&
        location.y + limit < keyWindow.frame.height &&
        location.y - limit > keyWindow.safeAreaInsets.top
    }

    private func returnToDefaultState() {
        dragMode = false
        timer?.invalidate()

        UIView.animate(withDuration: 0.1) {
            self.backgroundColor = .systemBlue
        }
    }
}

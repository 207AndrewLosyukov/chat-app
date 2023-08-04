//
//  SettingsViewController.swift
//  Messenger
//
//  Created by Андрей Лосюков on 11.03.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    private var isLeftButtonTapped = true

    private var output: SettingsViewOutput

    private var tinkoffEmitter: TinkoffEmitter?

    private var rectangleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var dayImageView: UIImageView = {
        let dayImageView = UIImageView(image: UIImage(named: "day"))
        dayImageView.translatesAutoresizingMaskIntoConstraints = false
        return dayImageView
    }()

    private var nightImageView: UIImageView = {
        let nightImageView = UIImageView(image: UIImage(named: "night"))
        nightImageView.translatesAutoresizingMaskIntoConstraints = false
        return nightImageView
    }()

    private var dayLabel: UILabel = {
        let dayLabel = UILabel()
        dayLabel.text = "Day"
        dayLabel.font = UIFont.systemFont(ofSize: 17)
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.isUserInteractionEnabled = true
        return dayLabel
    }()

    private let nightLabel: UILabel = {
        let nightLabel = UILabel()
        nightLabel.text = "Night"
        nightLabel.font = UIFont.systemFont(ofSize: 17)
        nightLabel.translatesAutoresizingMaskIntoConstraints = false
        nightLabel.isUserInteractionEnabled = true
        return nightLabel
    }()

    private lazy var dayThemeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonsHandler), for: .touchUpInside)
        button.addTarget(self, action: #selector(dayButtonPressedHandler), for: .touchDown)
        button.setImage(UIImage(systemName: "checkmark.circle.fill",
        withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .selected)
        button.setImage(UIImage(systemName: "circle",
        withConfiguration: UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        button.contentMode = .scaleAspectFit
        return button
    }()

    private lazy var nightThemeButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonsHandler), for: .touchUpInside)
        button.addTarget(self, action: #selector(nightButtonPressedHandler), for: .touchDown)
        button.setImage(UIImage(systemName: "checkmark.circle.fill",
                                withConfiguration: UIImage.SymbolConfiguration(scale: .large)),
                        for: .selected)
        button.setImage(UIImage(systemName: "circle",
                                withConfiguration:
                                    UIImage.SymbolConfiguration(scale: .large)), for: .normal)
        button.tintColor = .systemGray
        button.contentVerticalAlignment = .center
        button.contentHorizontalAlignment = .center
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(output: SettingsViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        setupUI()
    }

    func setupUI() {
        dayLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self,
        action: #selector(dayLabelPressed)))
        nightLabel.addGestureRecognizer(UILongPressGestureRecognizer(target: self,
        action: #selector(nightLabelPressed)))
        dayLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dayLabelTapped)))
        nightLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nightLabelTapped)))
        navigationItem.largeTitleDisplayMode = .never
        title = "Settings"
        output.loadTheme()
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        view.addSubview(rectangleView)
        rectangleView.addSubview(dayImageView)
        rectangleView.addSubview(nightImageView)
        rectangleView.addSubview(dayLabel)
        rectangleView.addSubview(nightLabel)
        rectangleView.addSubview(dayThemeButton)
        rectangleView.addSubview(nightThemeButton)
        tinkoffEmitter = TinkoffEmitter(in: view)
        setupRectangleView()
        setupDayImageView()
        setupNightImageView()
        setupDayLabel()
        setupNightLabel()
        setupLeftRadioButton()
        setupRightRadioButton()
    }

    private func setupRectangleView() {
        NSLayoutConstraint.activate([
            rectangleView.widthAnchor.constraint(equalToConstant: 358),
            rectangleView.heightAnchor.constraint(equalToConstant: 170),
            rectangleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            rectangleView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func setupDayImageView() {
        NSLayoutConstraint.activate([
            dayImageView.topAnchor.constraint(equalTo: rectangleView.topAnchor, constant: 24),
            dayImageView.leadingAnchor.constraint(equalTo: rectangleView.leadingAnchor, constant: 50),
            dayImageView.widthAnchor.constraint(equalToConstant: 79),
            dayImageView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    private func setupNightImageView() {
        NSLayoutConstraint.activate([
            nightImageView.topAnchor.constraint(equalTo: rectangleView.topAnchor, constant: 24),
            nightImageView.trailingAnchor.constraint(equalTo: rectangleView.trailingAnchor, constant: -50),
            nightImageView.widthAnchor.constraint(equalToConstant: 79),
            nightImageView.heightAnchor.constraint(equalToConstant: 55)
        ])
    }

    private func setupDayLabel() {
        NSLayoutConstraint.activate([
            dayLabel.topAnchor.constraint(equalTo: dayImageView.bottomAnchor, constant: 24),
            dayLabel.centerXAnchor.constraint(equalTo: dayImageView.centerXAnchor)
        ])
    }

    private func setupNightLabel() {
        NSLayoutConstraint.activate([
            nightLabel.topAnchor.constraint(equalTo: nightImageView.bottomAnchor, constant: 24),
            nightLabel.centerXAnchor.constraint(equalTo: nightImageView.centerXAnchor)
        ])
    }

    private func setupLeftRadioButton() {
        NSLayoutConstraint.activate([
            dayThemeButton.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 10),
            dayThemeButton.centerXAnchor.constraint(equalTo: dayLabel.centerXAnchor),
            dayThemeButton.widthAnchor.constraint(equalToConstant: 20),
            dayThemeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        dayThemeButton.sizeToFit()
    }

    private func setupRightRadioButton() {
        NSLayoutConstraint.activate([
            nightThemeButton.topAnchor.constraint(equalTo: nightLabel.bottomAnchor, constant: 10),
            nightThemeButton.centerXAnchor.constraint(equalTo: nightLabel.centerXAnchor),
            nightThemeButton.widthAnchor.constraint(equalToConstant: 20),
            nightThemeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        nightThemeButton.sizeToFit()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            tinkoffEmitter?.start(at: location)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: view)
            tinkoffEmitter?.move(to: location)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tinkoffEmitter?.stop()
    }
}

extension SettingsViewController: SettingsViewInput {

    func setupTheme(theme: Theme) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.rectangleView.backgroundColor = theme.mainColors.themeView.rectangleViewColor
            self?.view.backgroundColor = theme.mainColors.themeView.secondaryBackgroundColor

            self?.dayLabel.textColor = theme.mainColors.themeView.textColor
            self?.nightLabel.textColor = theme.mainColors.themeView.textColor

            switch theme {

            case .day:
                self?.dayThemeButton.isSelected = true
                self?.nightThemeButton.tintColor = .systemGray
                self?.dayThemeButton.tintColor = .systemBlue
                self?.nightThemeButton.isSelected = false

            case .night:
                self?.nightThemeButton.isSelected = true
                self?.dayThemeButton.tintColor = .systemGray
                self?.nightThemeButton.tintColor = .systemBlue
                self?.dayThemeButton.isSelected = false
            }
        }
    }
}

extension SettingsViewController {

    @objc private func dayButtonPressedHandler(_ sender: UIButton) {
        dayImageView.alpha = 0.4
        dayLabel.alpha = 0.2
        UIView.animate(withDuration: 0.5) {
            self.dayImageView.alpha = 1
            self.dayLabel.alpha = 1
        }
    }

    @objc private func nightButtonPressedHandler(_ sender: UIButton) {
        nightImageView.alpha = 0.4
        nightLabel.alpha = 0.2
        UIView.animate(withDuration: 0.5) {
            self.nightImageView.alpha = 1
            self.nightLabel.alpha = 1
        }
    }

    @objc private func dayLabelPressed(_ sender: UILongPressGestureRecognizer) {
        dayThemeButton.sendActions(for: .touchDown)
    }

    @objc private func nightLabelPressed(_ sender: UILongPressGestureRecognizer) {
        nightThemeButton.sendActions(for: .touchDown)
    }

    @objc private func dayLabelTapped(_ sender: UITapGestureRecognizer) {
        dayThemeButton.sendActions(for: .touchUpInside)
    }

    @objc private func nightLabelTapped(_ sender: UITapGestureRecognizer) {
        nightThemeButton.sendActions(for: .touchUpInside)
    }

    @objc private func buttonsHandler(_ sender: UIButton) {
        if sender == dayThemeButton {
            output.didChangeTheme(theme: .day)
        } else {
            output.didChangeTheme(theme: .night)
        }
    }
}

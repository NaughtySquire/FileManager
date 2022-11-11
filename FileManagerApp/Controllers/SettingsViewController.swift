//
//  SettingsViewController.swift
//  FileManagerApp
//
//  Created by Роман Олегович on 10.11.2022.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController {

    // MARK: - properties

    let userDefaults = UserDefaults()
    var changePasswordButtonTapped: (() -> Void)?

    // MARK: - views

    private lazy var settingsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        [sortingStackView, photoSizeStackView].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.spacing = 10
        return stackView
    }()

    private lazy var sortingStackView: UIStackView = {
        let stackView = UIStackView()
        [sortingLabel, sortingSwitch].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.spacing = 10
        return stackView
    }()

    private lazy var photoSizeStackView: UIStackView = {
        let stackView = UIStackView()
        [photoSizeLabel, photoSizeSwitch].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.spacing = 10
        return stackView
    }()

    private lazy var sortingLabel: UILabel = {
        let label = UILabel()
        label.text = "Сортировать по алфавиту"
        return label
    }()

    private lazy var sortingSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = userDefaults.bool(forKey: "sortByNormalOrder")
        switchView.addTarget(self,
                             action: #selector(sortingSwitchChanged(_:)),
                             for: .valueChanged)
        return switchView
    }()

    private lazy var photoSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Показать размер фото"
        return label
    }()

    private lazy var photoSizeSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.isOn = userDefaults.bool(forKey: "showPhotoSize")
        switchView.addTarget(self,
                             action: #selector(photoSizeSwitchChanged(_:)),
                             for: .valueChanged)
        return switchView
    }()

    private lazy var changePasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Поменять пароль", for: .normal)
        button.addAction(UIAction(handler: { _ in self.changePasswordButtonTapped?() }),
                         for: .touchUpInside)
        button.backgroundColor = .systemBlue
        return button
    }()

    // MARK: - init

    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = UIImage(systemName: "gear")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        [settingsStackView, changePasswordButton].forEach {
            view.addSubview($0)
        }

        addConstraints()
    }

    // MARK: - functions

    @objc
    func sortingSwitchChanged(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "sortByNormalOrder")
    }

    @objc
    func photoSizeSwitchChanged(_ sender: UISwitch) {
        userDefaults.set(sender.isOn, forKey: "showPhotoSize")
    }

    // MARK: - constraints

    private func addConstraints() {

        settingsStackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()

        }

        changePasswordButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(settingsStackView.snp.bottom).offset(10)
        }
    }

}

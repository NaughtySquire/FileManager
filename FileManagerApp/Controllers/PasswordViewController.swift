//
//  PasswordViewController.swift
//  FileManagerApp
//
//  Created by Роман Олегович on 04.11.2022.
//

import UIKit

import KeychainAccess
import SnapKit

class PasswordViewController: UIViewController {

    // MARK: - properties

    var passwordChecked: (() -> Void)?
    private let keychainService = KeychainService()
    private var savedPassword: String
    private var passwordToConfirm = ""

    // MARK: - views

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTextField,
                                                       passwordButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.layer.cornerRadius = 10
        stackView.layer.masksToBounds = true
        return stackView
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var passwordButton = UIButton()

    private let errorLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .red
        return label
    }()

    // MARK: - init

    init(updatePassword: Bool = false) {
        if updatePassword {
            savedPassword = ""
        } else {
            savedPassword = keychainService.getData()  ?? ""
        }
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPasswordButton()
        addSubviews()
        addConstraints()
        view.backgroundColor = .white
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    // MARK: - functions

    private func setupPasswordButton() {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        if !passwordToConfirm.isEmpty {
            button.setTitle("Подтвердить пароль", for: .normal)
            button.addTarget(self,
                             action: #selector(confirmPassword),
                             for: .touchUpInside)
        } else if !savedPassword.isEmpty {
            button.setTitle("Ввести пароль", for: .normal)
            button.addTarget(self,
                             action: #selector(checkPassword),
                             for: .touchUpInside)
        } else {
            button.setTitle("Создать пароль", for: .normal)
            button.addTarget(self,
                             action: #selector(createPassword),
                             for: .touchUpInside)
        }
        passwordButton.removeFromSuperview()
        passwordButton = button
        stackView.addArrangedSubview(passwordButton)
    }

    private func addSubviews() {
        [stackView, errorLabel].forEach { view.addSubview($0) }
    }

    // MARK: - handlers

    @objc
    private func createPassword() {
        guard let password = passwordTextField.text, password.count >= 4 else {
            errorLabel.text = "Длина пароля должна быть больше или равна 4"
            errorLabel.isHidden = false
            return
        }
        passwordToConfirm = password
        passwordTextField.text = ""
        setupPasswordButton()
        errorLabel.isHidden = true
    }

    @objc
    private func confirmPassword() {
        if let password = passwordTextField.text,
                password == passwordToConfirm {
            keychainService.setData(data: password)
            passwordChecked?()
            return
        }
        errorLabel.text = "Пароли не совпадают"
        errorLabel.isHidden = false
        passwordToConfirm = ""
        passwordTextField.text = ""
        setupPasswordButton()
    }

    @objc
    private func checkPassword() {
        guard let password = passwordTextField.text,
              !savedPassword.isEmpty, password.count >= 4 else {
            return
        }
        if savedPassword == password {
            passwordChecked?()
            errorLabel.isHidden = true
        }
        errorLabel.text = "Неправильный пароль"
        errorLabel.isHidden = false
    }

    // MARK: - constraints

    private func addConstraints() {
        stackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.6)
            maker.height.equalTo(80)
        }
        errorLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.6)
            maker.top.equalTo(stackView.snp_bottomMargin).offset(10)
        }
    }

}

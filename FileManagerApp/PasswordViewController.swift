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

    let keychainService = KeychainService()
    let passwordToConfirm: String

    // MARK: - views

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [passwordTextField,
                                                       passwordButton])
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите пароль"
        return textField
    }()

    private lazy var passwordButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()

    // MARK: - init

    init(passwordToConfirm: String = "") {
        self.passwordToConfirm = passwordToConfirm
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
        setupPasswordButton()
        view.backgroundColor = .white

    }

    // MARK: - functions

    func setupPasswordButton() {

        if !passwordToConfirm.isEmpty {
            passwordButton.setTitle("Подтвердить пароль", for: .normal)
            passwordButton.addTarget(self,
                                          action: #selector(confirmPassword),
                                          for: .touchUpInside)
            return
        }

        if keychainService.getData() != nil {
            passwordButton.setTitle("Введите пароль", for: .normal)
            passwordButton.addTarget(self,
                                          action: #selector(checkPassword),
                                          for: .touchUpInside)

        } else {
            passwordButton.setTitle("Создать пароль", for: .normal)
            passwordButton.addTarget(self,
                                          action: #selector(createPassword),
                                          for: .touchUpInside)
        }

    }

    func addSubviews() {
        [stackView].forEach { view.addSubview($0) }
    }

    // MARK: - handlers

    @objc
    func createPassword() {
        guard let password = passwordTextField.text, password.count >= 4 else { return }
        keychainService.setData(data: password)
        navigationController?.pushViewController(PasswordViewController(passwordToConfirm: password), animated: true)
    }

    @objc
    func confirmPassword() {
        guard let password = passwordTextField.text, password == passwordToConfirm else {
            return
        }
        do {
            let documentsURL = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false)
            let fileManagerService = FileManagerService()
            navigationController?.pushViewController(DirectoryViewController(fileManagerService, documentsURL),
                                                     animated: true)
        } catch let error {
            print(error)
        }
    }

    @objc
    func checkPassword() {

    }

    func addConstraints() {
        stackView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
    }
}

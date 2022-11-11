//
//  KeychainService.swift
//  FileManagerApp
//
//  Created by Роман Олегович on 04.11.2022.
//

import Foundation
import KeychainAccess

protocol KeychainServiceProtocol {
    func getData() -> String?
    func setData(data: String)
}

final class KeychainService: KeychainServiceProtocol {

    // MARK: - properties

    private let keychain = Keychain(service: "FileManagerApp")
    private let key = "user"

    // MARK: - KeychainServiceProtocol implementation

    func getData() -> String? {
        return keychain[key]
    }

    func setData(data: String) {
        keychain[key] = data
    }

    func removeData() {
        try? keychain.remove(key)
    }

}

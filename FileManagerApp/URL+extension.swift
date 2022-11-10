//
//  URL+extension.swift
//  FileManagerApp
//
//  Created by Роман Олегович on 10.11.2022.
//

import Foundation

extension URL: Comparable {
    public static func < (lhs: URL, rhs: URL) -> Bool {
        lhs.lastPathComponent < rhs.lastPathComponent
    }
}

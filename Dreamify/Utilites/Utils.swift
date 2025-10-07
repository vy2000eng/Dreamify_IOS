//
//  Utils.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 7/13/25.
//

import Foundation
import UIKit

extension NSAttributedString {
    static func create(string: String, font: UIFont, color: UIColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [.font: font, .foregroundColor: color])
    }
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

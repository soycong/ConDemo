//
//  APIKey.swift
//  ConDemo
//
//  Created by 이명지 on 4/15/25.
//

import Foundation

struct APIKey {
    static let accessKey = Bundle.main.infoDictionary?["AWS_ACCESS_KEY_ID"] as! String
    static let secretKey = Bundle.main.infoDictionary?["AWS_SECRET_ACCESS_KEY"] as! String
}

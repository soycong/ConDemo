//
//  APIKey.swift
//  ConDemo
//
//  Created by 이명지 on 4/15/25.
//

import Foundation

enum APIKey {
    static let accessKey = Bundle.main.infoDictionary?["AWS_ACCESS_KEY_ID"] as! String
    static let secretKey = Bundle.main.infoDictionary?["AWS_SECRET_ACCESS_KEY"] as! String
    static let chatGPT = Bundle.main.infoDictionary?["CHATGPT_API_KEY"] as! String
    static let bucketName = Bundle.main.infoDictionary?["S3_BUCKET_NAME"] as! String
}

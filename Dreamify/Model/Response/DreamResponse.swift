//
//  DreamResponse.swift
//  Dreamify
//
//  Created by Vladyslav Yatsuta on 1/18/26.

 import Foundation
 import UIKit
 struct DreamUploadResponse: Codable {
     let dreamId: String
         let title: String
         let createdAt: Date
         let fileUrl: URL
 }

 struct DreamMetadata: Codable {
     let id: String
         let title: String
         let createdAt: Date
         let analyzedText: String?
         let transcribedText: String?
         let tag: String?
 }

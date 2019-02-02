///
//  ITVideos+CoreDataClass.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//
//
import CoreData

/// Configuration object for `CoreDataStack`
public struct CoreDataStackConfiguration: Equatable {
    /// The URL of the model to use
    public let modelURL: URL

    /// The app's bundle identifier. Defaults to Bundle.main.bundleIdentifier
    public let bundleIdentifier: String

    /// The app's bundle name.
    public let bundleName: String

    /// The persistent store type to use
    public let storeType: String

    /// Designated initializer to create an instance of the
    ///
    /// - Parameters:
    ///   - modelURL: The model's URL
    ///   - bundleIdentifier: The app's bundle identifier. Defaults to Bundle.main.bundleIdentifier
    ///   - bundleName: The app's bundle name. Defaults Bundle.main.bundleURL.lastPathComponent with the extension stripped
    ///   - storeType: The store type to use for the persistent store. Defaults to NSSQLiteStoreType
    public init(modelURL: URL, bundleIdentifier: String = Bundle.main.bundleIdentifier!, bundleName: String = Bundle.main.bundleURL.lastPathComponent.components(separatedBy: ".").first!, storeType: String = NSSQLiteStoreType) {
        self.modelURL = modelURL

        self.bundleIdentifier = bundleIdentifier

        self.bundleName = bundleName

        self.storeType = storeType
    }
}

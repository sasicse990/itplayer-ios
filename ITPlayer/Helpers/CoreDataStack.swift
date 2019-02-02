//
//  ITVideos+CoreDataClass.swift
//  ITPlayer
//
//  Created by Admin on 02/02/19.
//  Copyright © 2019 Test. All rights reserved.
//
//
import UIKit
import CoreData

/// Class representing the Core Data stack of the application. Relies on `NSPersistentContainer`
public final class CoreDataStack {
    /// Internal property representing the shared manager
    private static var _internalSharedManager: CoreDataStack?

    /// The internal stack's queue
    private let stackQueue: DispatchQueue

    /// The shared manager
    /// Will raise a fatal error if `shared(with:)` wasn't previously called
    public static var shared: CoreDataStack {
        guard let internalSharedManager = _internalSharedManager else {
            fatalError("please setup the core data stack with a configuration")
        }

        return internalSharedManager
    }

    #if TESTING
    /// A dispatch queue so that we can safely access our `__actualModelCache`
    private static let __internalCacheQueue = DispatchQueue(label: "ind.itplayer.internal-cache-queue")

    /// The backing-end of our model cache
    private static var __actualModelCache: [URL: NSManagedObjectModel] = [:]

    /// A cache of our loaded models
    private class var _modelCache: [URL: NSManagedObjectModel] {
        get {
            return __internalCacheQueue.sync { __actualModelCache }
        }
        set {
            __internalCacheQueue.sync {
                __actualModelCache = newValue
            }
        }
    }

    /// Internal testing method to reset the shared internal manager
    internal class func _resetSharedManager() {
        _internalSharedManager?._pruneStore()

        _internalSharedManager = nil
    }

    /// Internal method to prune the persistent store
    private func _pruneStore() {
        persistentContainer.persistentStoreCoordinator.performAndWait {
            let options = self.persistentContainer.persistentStoreDescriptions.first!.options

            try! self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: self.storeURL, ofType: configuration.storeType, options: options)
        }

        let storeURL: URL = {
            var baseURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

            baseURL.appendPathComponent("persistent_store", isDirectory: true)

            return baseURL
        }()

        try? FileManager.default.removeItem(at: storeURL)
    }
    #endif

    /// The configuration used to configure this object. See `DataStoreConfiguration`
    public private(set) var configuration: CoreDataStackConfiguration

    /// Private property. The store's URL
    private lazy var storeURL: URL = {
        var baseURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)

        baseURL.appendPathComponent("persistent_store", isDirectory: true)

        if !FileManager.default.fileExists(atPath: baseURL.path) {
            try! FileManager.default.createDirectory(at: baseURL, withIntermediateDirectories: true, attributes: nil)

            var resourceValues = URLResourceValues()

            resourceValues.isExcludedFromBackup = true

            try! baseURL.setResourceValues(resourceValues)
        }

        let bundleName = configuration.bundleName.lowercased()

        baseURL.appendPathComponent(bundleName)

        baseURL.appendPathExtension("sqlite")

        return baseURL
    }()

    /// Private property. The model to use
    private lazy var model: NSManagedObjectModel = {
        let modelURL = configuration.modelURL

        #if TESTING
        if let model = CoreDataStack._modelCache[modelURL] {
            return model
        }
        #endif

        let model = NSManagedObjectModel(contentsOf: modelURL)!

        #if TESTING
        CoreDataStack._modelCache[modelURL] = model
        #endif

        return model
    }()

    /// Private property. The internal peristent container.
    private lazy var persistentContainer: NSPersistentContainer = {
        let baseName = configuration.bundleIdentifier

        let container = NSPersistentContainer(name: baseName + ".persistent-container", managedObjectModel: model)

        let storeDescription = NSPersistentStoreDescription(url: storeURL)

        storeDescription.shouldInferMappingModelAutomatically = true

        storeDescription.shouldMigrateStoreAutomatically = true

        storeDescription.shouldAddStoreAsynchronously = false

        storeDescription.type = configuration.storeType

        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { (_, _) in }

        container.viewContext.name = baseName + ".view-context"

        return container
    }()

    /// The store's view context
    public lazy var viewContext: NSManagedObjectContext = {
        let viewContext = persistentContainer.viewContext

        let baseName = configuration.bundleIdentifier

        viewContext.name = baseName + ".view-context"

        return viewContext
    }()

    /// The store's import context
    public lazy var importContext: NSManagedObjectContext = {
        let importContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)

        importContext.parent = viewContext

        let baseName = configuration.bundleIdentifier

        importContext.name = baseName + ".import-context"

        return importContext
    }()

    /// Creates a shared DataStore manager
    ///
    /// - Parameter configuration: The data store's configuration
    /// - Returns: The initialized data store
    @discardableResult
    public class func shared(with configuration: CoreDataStackConfiguration) -> CoreDataStack {
        if let networkManager = _internalSharedManager {
            return networkManager
        }

        let coreDataManager = CoreDataStack(configuration: configuration)

        _internalSharedManager = coreDataManager

        return coreDataManager
    }

    /// Internal designated initializer
    ///
    /// - Parameter configuration: The configuration
    private init(configuration: CoreDataStackConfiguration) {
        self.configuration = configuration

        let baseName = configuration.bundleIdentifier

        stackQueue = DispatchQueue(label: baseName + ".stack-queue", qos: .default, attributes: [], autoreleaseFrequency: .workItem, target: nil)

        _ = persistentContainer //load the psc

        registerSaveListeners()
    }

    /// Internal method that will register the appropriate methods (based on host-target) to listen in to when the app/windows will resign being active
    private func registerSaveListeners() {
        #if canImport(UIKit)
        registerSaveListeners_UIKit()
        #else
        #error("Unhandled save platform")
        #endif
    }

    #if canImport(UIKit)
    /// Registers and handles saving when the app resigns being active, for UIKit-based platforms
    private func registerSaveListeners_UIKit() {
        NotificationCenter.default.addObserver(self, selector: #selector(hostWillResignBeingActive(notification:)), name: UIApplication.willResignActiveNotification, object: nil)
    }

    /// Concrete implementation of saving when the app resigns being active on UIKit
    ///
    /// - Parameter notification: The notification object
    @objc
    internal func hostWillResignBeingActive(notification: Notification) {

        let activity = ProcessInfo.processInfo.beginActivity(options: [.background], reason: "ind.itplayerCoreDataStack.background-save-task")

        asynchronouslySaveContexts {
            ProcessInfo.processInfo.endActivity(activity)
        }
    }
    #endif

    /// Method to *synchronously* save the contexts
    public func saveContexts() {
        let contextsToSave = [importContext, viewContext, viewContext.parent]

        for aContext in contextsToSave {
            guard let aContext = aContext else {
                continue
            }

            aContext.performAndWait {
                #if TESTING
                guard (aContext.parent != nil || aContext.persistentStoreCoordinator != nil) && persistentContainer.persistentStoreCoordinator.persistentStores.first != nil else { //there's a race issue with a test ending and thus resetting the stack. an error is raised below since the context's PSC doesn't have any stores
                    return
                }
                #endif

                try! aContext.save()
            }
        }
    }

    /// Method to asynchronously save the contexts
    ///
    /// - Parameter completion: An optional completion handler
    public func asynchronouslySaveContexts(completion: (() -> Void)? = nil) {
        stackQueue.async {
            self.saveContexts()

            completion?()
        }
    }
}

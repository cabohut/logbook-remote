//
//  LogbookModel.swift
//  Logbook
//
//  Created by sam on 3/7/22.
//  Code from Scrumdinger sample app
//  https://developer.apple.com/tutorials/app-dev-training/persisting-data

import Foundation

private let FILE_NAME = "Logbook.data"
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let archiveURL = documentsDirectory.appendingPathComponent("Logbook").appendingPathExtension("plist")

class AppState : ObservableObject {
    var c_car_idx = 0
    @Published var overdueCount = 0
    @Published var upcomingCount = 0
    
    static func resetState(state: AppState) {
        state.c_car_idx = 0
        state.overdueCount = 0
        state.upcomingCount = 0
    }
}

class LogbookModel: ObservableObject {
    @Published var cars: [Car] = []
    
    // MARK: - Save/Load data
    // Scrumdinger methods below
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                       in: .userDomainMask,
                                       appropriateFor: nil,
                                       create: false)
            .appendingPathComponent(FILE_NAME)
    }
    
    static func load() async throws -> [Car] {
        try await withCheckedThrowingContinuation { continuation in
            load { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let cars):
                    continuation.resume(returning: cars)
                }
            }
        }
    }
    
    static func load(completion: @escaping (Result<[Car], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                var cars = try JSONDecoder().decode([Car].self, from: file.availableData)
                DispatchQueue.main.async {
                    cars = cars.sorted { $0.make < $1.make }
                    for var c in cars {
                        c.logs = c.logs.sorted {  $0.date > $1.date }
                    }
                    completion(.success(cars))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    static func save(cars: [Car]) async throws -> Int {
        try await withCheckedThrowingContinuation { continuation in
            save(cars: cars) { result in
                switch result {
                case .failure(let error):
                    continuation.resume(throwing: error)
                case .success(let carsSaved):
                    continuation.resume(returning: carsSaved)
                }
            }
        }
    }
    
    static func save(cars: [Car], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(cars)
                let outfile = try fileURL()
                try data.write(to: outfile)
                DispatchQueue.main.async {
                    completion(.success(cars.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}

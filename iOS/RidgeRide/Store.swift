import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 10

    @Published var items: [Ride] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("ridgeride_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Ride) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Ride) {
        if let idx = items.firstIndex(where: { $0.id == item.id }) {
            items[idx] = item
            save()
        }
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Ride) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([Ride].self, from: data) else {
            items = Store.seedData()
            save()
            return
        }
        items = decoded
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }

    static func seedData() -> [Ride] {
        [
        Ride(date: Date().addingTimeInterval(-86400), trail: "Blue Loop", distance: "6.2", duration: "38"),
        Ride(date: Date().addingTimeInterval(-172800), trail: "Rockslide Trail", distance: "4.8", duration: "31"),
        Ride(date: Date().addingTimeInterval(-259200), trail: "Ridge Overlook", distance: "9.1", duration: "55")
        ]
    }
}

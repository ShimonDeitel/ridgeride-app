import Foundation

struct Ride: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var date: Date = Date()
    var trail: String
    var distance: String
    var duration: String
}

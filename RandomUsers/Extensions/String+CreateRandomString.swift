import Foundation

extension String {
    static func createRandomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0..<5).map{ _ in letters.randomElement()! })
    }
}

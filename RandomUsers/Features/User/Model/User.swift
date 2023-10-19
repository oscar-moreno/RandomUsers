import Foundation

// MARK: - User
struct Users: Decodable {
    let results: [User]
    let info: Info
}

// MARK: - Info
struct Info: Codable {
    let seed: String
    let results, page: Int
    let version: String
}

// MARK: - Result
struct User: Decodable {
    let name: Name
    let email: String
    let phone: String
    let picture: Picture
    let dob: Dob
    let location: Location
    
    static func exampleToPreview() -> User {
        User(name: Name(first: "John", last: "Doe"),
             email: "john@adevinta.com",
             phone: "(555) 123-456",
             picture: Picture(thumbnail: "", large: ""),
             dob: Dob(age: Int.random(in: 25...45)),
             location: Location(city: "Barcelona", state: "Catalunya", country: "Spain"))
    }
}

// MARK: - Name
struct Name: Decodable {
    let first: String
    let last: String
}

// MARK: - Picture
struct Picture: Decodable {
    let thumbnail: String
    let large: String
}

// MARK: - Dob
struct Dob: Decodable {
    let age: Int
}

// MARK: - Location
struct Location: Decodable {
    let city: String
    let state: String
    let country: String
}

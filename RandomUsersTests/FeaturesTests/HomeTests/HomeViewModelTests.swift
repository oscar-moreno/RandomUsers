import XCTest
@testable import RandomUsers

final class HomeViewModelTests: XCTestCase {

    private var sut: HomeVM!
    private var networkServiceMock: NetworkService!
    private var expectation: XCTestExpectation!
    private let expectationDescription = "Fetch characters from GetDataNetworkMock"
    private var fakeResults: [User]!
    private var fakeInfo: Info!
    private let numberOfFakePages = 2
    private let numberOfFakeUsers = 10
    private let expectationTimeOut = 3.0

    override func setUpWithError() throws {
        super.setUp()
        fakeResults = buildFakeResults(usersNumber: numberOfFakeUsers)
        fakeInfo = Info(seed: "foobar", results: numberOfFakeUsers, page: numberOfFakePages, version: "1.4")
        networkServiceMock = RandomUsersNetworkServiceMock(fakeResults: fakeResults, fakeInfo: fakeInfo)
        sut = HomeVM(networkService: networkServiceMock)
        expectation = expectation(description: expectationDescription)
    }
    
    func buildFakeResults(usersNumber: Int) -> [User] {
            var fakeResults = [User]()
            for position in 1...usersNumber {
                fakeResults.append(User(name: Name(first: "FakeFirstName \(position)", last: "FakeLastName \(position)"),
                                        email: "FakeEmail \(position)",
                                        phone:"FakePhone \(position)",
                                        picture: Picture(large: "FakePicLarge \(position)"),
                                        dob:Dob(age: 99),
                                        location: Location(city: "FakeCity \(position)",
                                                           state: "FakeState \(position)",
                                                           country: "FakeCountry \(position)")))
            }
            return fakeResults
        }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    func testloadUsersShouldFetchNextPageUsers() async {
        // Given a number of page
        let currentPage = sut.currentPage

        // When loadUsers is called
        await sut.loadUsers()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)

        // Then page must be incremented and viewModel get the expected number of characters
        XCTAssertEqual(currentPage + 1, sut.currentPage)
        XCTAssertEqual(numberOfFakeUsers, sut.users.count)
    }
    
    func testFetchUsersShouldSaveUsersInViewModel() async {
        // When fetchUsers is called
        await sut.fetchUsers(with: NetworkParams(results: "", page: ""))
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)
        
        // Then expected date must be saved in viewModel
        XCTAssertEqual(numberOfFakeUsers, sut.users.count)
    }
    
    func testLoadMoreUsersShouldLoadWhenLowerThanFourToEnd() async {
        // Given an index is 4 to the end
        let fakeIndex = numberOfFakeUsers - 4
        await sut.loadUsers()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)
        
        // When mustLoadMoreUsers is called with an user in that index
        let actualResult = sut.mustLoadMoreUsers(from: sut.users[fakeIndex])
        
        // Then should return true
        XCTAssert(actualResult)
    }
    
    func testLoadMoreUsersShouldNotLoadWhenHigherThanFourToEnd() async {
        // Given an index differente 4 to the end
        let fakeIndex = numberOfFakeUsers - 7
        await sut.loadUsers()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)
        
        
        // When mustLoadMoreUsers is called with an user in that index
        let actualResult = sut.mustLoadMoreUsers(from: sut.users[fakeIndex])
        
        // Then should return true
        XCTAssertFalse(actualResult)
    }
    
    func testDeleteShouldRemoveUserAtGivenIndexSet() async {
        // Given the user at position 2
        let fakeUser = User(name: Name(first: "FakeFirstName 2",
                                       last: ""),
                            email: "FakeEmail 2",
                            phone: "",
                            picture: Picture(large: ""),
                            dob: Dob(age: 99),
                            location: Location(city: "",
                                               state: "",
                                               country: ""))
        await sut.loadUsers()
        
        // When delete is called
        sut.delete(fakeUser)
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)
        
        // Then user is removed of users array and added to removedUsers array
        XCTAssertEqual("FakeFirstName 1", sut.users[0].name.first)
        XCTAssertEqual("FakeFirstName 3", sut.users[1].name.first)
        XCTAssertEqual("FakeFirstName 2", sut.removedUsers[0].name.first)
    }
    
    func testResetUsersShouldEmptyUsersAndResetPage() async {
        // Given a users loaded
        await sut.loadUsers()
        expectation.fulfill()
        
        // When resetUsers is called
        sut.resetUsers()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)
        
        // Then users array is empty and current page is equal to zero.
        XCTAssert(sut.users.isEmpty)
        XCTAssertEqual(0, sut.currentPage)
    }
    
    func testSetBlackListedShouldAddUserToBlackListWhenItWasNotPreviously() async {
        // Given a random user not in blacklist
        let fakeUser = User(name: Name(first: "FakeFirstName 1",
                                       last: ""),
                            email: "FakeEmail 1",
                            phone: "",
                            picture: Picture(large: ""),
                            dob: Dob(age: 99),
                            location: Location(city: "",
                                               state: "",
                                               country: ""),
                            isBlackListed: false)
        await sut.loadUsers()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)
        
        // When setBlackListed is called
        sut.setBlackListed(fakeUser)
        
        // Then user is added to blacklist
        XCTAssert((fakeUser.isBlackListed != nil))
        XCTAssertEqual("FakeFirstName 1", sut.usersBlacklist[0].name.first)
    }
    
    func testSetBlackListedShouldRemoveUserToBlackListWhenItWasPreviously() async {
        // Given a random user not in blacklist
        let fakeUser = User(name: Name(first: "FakeFirstName 1",
                                       last: ""),
                            email: "FakeEmail 1",
                            phone: "",
                            picture: Picture(large: ""),
                            dob: Dob(age: 99),
                            location: Location(city: "",
                                               state: "",
                                               country: ""),
                            isBlackListed: true)
        await sut.loadUsers()
        expectation.fulfill()
        await fulfillment(of: [expectation], timeout: expectationTimeOut)
        
        // When setBlackListed is called
        sut.setBlackListed(fakeUser)
        
        // Then user is added to blacklist
        XCTAssert((fakeUser.isBlackListed != nil))
        XCTAssert(sut.usersBlacklist.isEmpty)
    }
}

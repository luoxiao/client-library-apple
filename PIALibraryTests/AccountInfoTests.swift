//
//  AccountInfoTests.swift
//  PIALibraryTests-iOS
//
//  Created by Jose Antonio Blaya Garcia on 14/8/18.
//  Copyright © 2018 London Trust Media. All rights reserved.
//

import XCTest
@testable import PIALibrary

class AccountInfoTests: XCTestCase {
    
    private let mock = MockProviders()
    private var theDate: Date!
    private var accountInfo: AccountInfo!

    override func setUp() {
        super.setUp()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        self.theDate = dateFormatter.date(from: "14-08-2018")
        self.accountInfo = AccountInfo(email: "email@email.com",
                                       plan: Plan.monthly,
                                       productId: "identifier",
                                       isRenewable: false,
                                       isRecurring: false,
                                       expirationDate: self.theDate,
                                       shouldPresentExpirationAlert: false,
                                       renewUrl: nil)
    }
    
    override func tearDown() {
        self.theDate = nil
        self.accountInfo = nil
        super.tearDown()
    }
    
    public func testExpirationDateDefaultLocale() {
        
        //We are going to asume for the test the default Locale is en_US
        XCTAssertEqual(accountInfo.humanReadableExpirationDate(usingLocale: Locale(identifier: "en_US")),
                       "August 14, 2018",
                       "The human readable format is not correct")
        
    }
    
    public func testExpirationDateUsingSpanishLocale() {
        
        XCTAssertEqual(accountInfo.humanReadableExpirationDate(usingLocale: Locale(identifier: "es_ES")),
                       "14 de agosto de 2018",
                       "The human readable format is not correct")
        
    }

    public func testRenewableProduct() {
        
        let factory = MockProviders()
        let expLogin = expectation(description: "login")
        let credentials = Credentials(username: "p0000000", password: "foobarbogus")
        
        Client.providers.accountProvider.login(with: LoginRequest(credentials: credentials)) { (user, error) in
            guard let _ = user else {
                print("Login error: \(error!)")
                expLogin.fulfill()
                XCTAssert(false)
                return
            }
            XCTAssert(factory.accountProvider.isLoggedIn)
            XCTAssertEqual(user?.isRenewable, false)
            XCTAssertEqual(user?.info?.isRecurring, true)
            expLogin.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
        
    }
    
}

//
//  DateTests.swift
//  MoodAppTests
//
//  Created by 簡莉芯 on 2023/7/21.
//

import XCTest
@testable import MoodApp


final class DateTests: XCTestCase {
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testDateToString() {
        // Arrange
        let date = Date()
        let format = "yyyy-MM-dd"
        let ans = "2023-07-21"
        
        // Act
        let result = date.formatDateString(format: format)
        
        // Assert
        XCTAssertEqual(result, ans, "Cannot convert Date to String.")
    }
    
    
    func testDifferentDateFormats() {
        // Arrange
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from: "2023-07-21 12:30:00")
        
        // Act
        let formattedDate1 = date?.formatDateString(format: "yyyy/MM/dd")
        let formattedDate2 = date?.formatDateString(format: "MM/dd/yyyy")
        let formattedDate3 = date?.formatDateString(format: "HH:mm:ss")
        
        // Assert
        XCTAssertEqual(formattedDate1, "2023/07/21", "Incorrect date format.")
        XCTAssertEqual(formattedDate2, "07/21/2023", "Incorrect date format.")
        XCTAssertEqual(formattedDate3, "12:30:00", "Incorrect date format.")
    }
    
    
    func testEmptyFormat() {
        // Arrange
        let date = Date()
        let format = ""
        let ans = ""
        
        // Act
        let result = date.formatDateString(format: format)
        
        // Assert
        XCTAssertEqual(result, ans, "Empty date format should return empty string.")
    }
    
    func testEndOfMonth() {
        
    }
    
    
    
}

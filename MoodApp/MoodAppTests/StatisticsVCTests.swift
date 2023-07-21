//
//  StatisticsVCTests.swift
//  MoodAppTests
//
//  Created by 簡莉芯 on 2023/7/20.
//

import XCTest
@testable import MoodApp

final class StatisticsVCTests: XCTestCase {
    
    let statisticVC = StatisticsViewController()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
   
//MARK: calculate Bed & Wake AverageTime
    func testCalculateAverageTime() { //包含"跨天"狀況
        // Arrange
        let test1Array = ["00:00", "00:00", "00:00"]
        let ans1 = "00:00"
        
        let test2Array = ["00:00", "00:00", "06:00", "06:00"]
        let ans2 = "03:00"
        
        let test3Array = ["22:00", "22:00", "02:00", "02:00"]
        let ans3 = "00:00"
        
        // Act
        let result1 = statisticVC.calculateAverageTime(timeStrings: test1Array)
        let result2 = statisticVC.calculateAverageTime(timeStrings: test2Array)
        let result3 = statisticVC.calculateAverageTime(timeStrings: test3Array)
        
        // Assert
        XCTAssertEqual(ans1, result1, "Result1 is wrong.")
        XCTAssertEqual(ans2, result2, "Result2 is wrong.")
        XCTAssertEqual(ans3, result3, "Result3 is wrong.")
    }
    
    func testEmptyStrings() { // 空的狀況直接變成“00:00“，但是會因為是“空”的 --> 被分到noRecord那條路
        // Arrange
        let timeStrings: [String] = []
        
        // Act
        let result = statisticVC.calculateAverageTime(timeStrings: timeStrings)
        
        // Assert
        XCTAssertEqual(result, "00:00", "Incorrect average time calculation for empty array.")
    }
    
    func testInvalidTimeFormat() { //?為什麼會變17:25
        // Arrange
        let timeStrings = ["22:30", "invalidTime", "21:45"]
                           
        // Act
        let result = statisticVC.calculateAverageTime(timeStrings: timeStrings)
        
        // Assert
        XCTAssertEqual(result, "00:00", "Incorrect average time calculation for empty array.")
    }
    
    
//MARK: calculateSleepTime
    func testCalculateSleepTime() { //包含"跨天"狀況
        // Arrange
        let startArray = ["00:00", "22:00", "23:00", "01:00"]
        let endArray = ["06:00", "07:00", "08:00", "05:00"]
        let ansHrs = ["06:00", "09:00", "09:00", "04:00"] // Failed --> 應為秒數
        let ansSec = ["21600.0", "32400.0", "32400.0", "14400.0"]
        
        // Act
        let result = statisticVC.calculateSleepTime(startArray: startArray, endArray: endArray)
        
        // Assert
        XCTAssertEqual(ansSec, result, "Result is wrong.")
    }
    
    func testUnequalArrayCount() {
        // Arrange
        let startArray = ["00:00", "02:00", "01:30"]
        let endArray = ["06:20", "08:30"]
        
        // Act
        let result = statisticVC.calculateSleepTime(startArray: startArray, endArray: endArray)
        
        // Assert
        XCTAssertTrue(result.isEmpty, "Result should be empty since arrays have different counts.")
    }
    
    

//MARK: sleepTimeAverage
    func testSleepTimeAverage() { //Fractional
        // Arrange
        let timeStrings = ["21600.0", "32400.0", "32400.0", "14400.0"]
        let ans = "07:00"
        
        // Act
        let result = statisticVC.sleepTimeAverage(timeStrings: timeStrings)
        
        // Assert
        XCTAssertEqual(ans, result, "Result is wrong.")
    }
    
    func testEmptyTimeString() { // Failed //如果timeString為空，則不能計算，會往noRecord那條路走
        // Arrange
        let timeStrings: [String] = []
        let ans = "Result is wrong"
        
        // Act
        let result = statisticVC.sleepTimeAverage(timeStrings: timeStrings)
        
        // Assert
        XCTAssertEqual(ans, result, "Result is wrong")
    }
    
    func testSingleTestString() {
        // Arrange
        let timeStrings = ["08:20"] // Failed(因為設定為放入“秒”）-> 會變成"00:00"
        let timeStrings1 = ["30000"] // Success (放入Int測試也可以）
        let timeStrings2 = ["30000.0"] // Success
        let ans = "08:20"
        
        // Act
        let result = statisticVC.sleepTimeAverage(timeStrings: timeStrings1)
        
        // Assert
        XCTAssertEqual(ans, result, "Result is wrong")
    }
    
    func testMixedString() { //Int, Fractional也可以
        // Arrange
        let timeStrings = ["21600.0", "32400.0", "32400", "14400"]
        let ans = "07:00"
        
        // Act
        let result = statisticVC.sleepTimeAverage(timeStrings: timeStrings)
        
        // Assert
        XCTAssertEqual(ans, result, "Result is wrong")
    }
    
    
    
    
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//        // Any test you write for XCTest can be annotated as throws and async.
//        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
//        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}

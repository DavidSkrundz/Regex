//
//  OptimizerTests.swift
//  Regex
//

@testable import Regex
import XCTest

class OptimizerTests: XCTestCase {
	func testNOOP() {
		let input = Automaton()
		let output = Optimizer.optimize(input)
		XCTAssertEqual(output.initialStates, [])
		XCTAssertEqual(output.acceptingStates, [])
		XCTAssertEqual(output.transitions, [:])
	}
	
	static var allTests = [
		("testNOOP", testNOOP),
	]
}

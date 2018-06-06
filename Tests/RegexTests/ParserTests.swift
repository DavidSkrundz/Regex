//
//  ParserTests.swift
//  RegexTests
//

@testable import Regex
import XCTest

class ParserTests: XCTestCase {
	func testCharacters() {
		let tokens: [Token] = [
			.Character("a"),
			.Character("b"),
			.Character("c"),
			.Character("d"),
		]
		let automata = try! Parser.parse(tokens)
		
		XCTAssertEqual(automata.initialStates, [1])
		XCTAssertEqual(automata.acceptingStates, [5])
		
		XCTAssertEqual(automata.transitions, [
			1 : [.Character("a") : [2]],
			2 : [.Character("b") : [3]],
			3 : [.Character("c") : [4]],
			4 : [.Character("d") : [5]],
		])
	}
	
	static var allTests = [
		("testCharacters", testCharacters),
	]
}

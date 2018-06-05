//
//  LexerTests.swift
//  RegexTests
//

@testable import Regex
import XCTest

class LexerTests: XCTestCase {
	func testCharacters() {
		let tokens = try! Lexer.lex("abcd")
		XCTAssertEqual(tokens, [
			.Character("a"),
			.Character("b"),
			.Character("c"),
			.Character("d"),
		])
	}
	
	static var allTests = [
		("testCharacters", testCharacters),
	]
}

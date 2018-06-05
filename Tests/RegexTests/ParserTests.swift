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
		let graph = try! Parser.parse(tokens)
		
		XCTAssertEqual(graph.vertices.map{$0.data}, [0,1,2,3,4])
		XCTAssertEqual(graph.edges.map{$0.data}, [.Character("a"),.Character("b"),.Character("c"),.Character("d"),])
		XCTAssertEqual(graph.edges.map{$0.from.data}, [0,1,2,3])
		XCTAssertEqual(graph.edges.map{$0.to.data}, [1,2,3,4])
	}
	
	static var allTests = [
		("testCharacters", testCharacters),
	]
}

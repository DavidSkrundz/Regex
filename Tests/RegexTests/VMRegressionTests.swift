//
//  VMRegressionTests.swift
//  Regex
//

@testable import Regex
import XCTest

class VMRegressionTests: XCTestCase {
	func testWordBoundaryWorksWithNumbers() {
		let regex = try! Regex("\\b\\d{3}[-.]?\\d{3}[-.]?\\d{4}\\b")
		let matches = regex.match("p:444-555-1234 f:246.555.8888 m:1235554567")
		XCTAssertEqual(matches, [
			RegexMatch(match: "444-555-1234", range: 2..<14, groups: [], groupRanges: []),
			RegexMatch(match: "246.555.8888", range: 17..<29, groups: [], groupRanges: []),
			RegexMatch(match: "1235554567", range: 32..<42, groups: [], groupRanges: []),
		])
	}
	
	func testSplitResultChoosingSecondaryThreadIfPrimaryOneFails() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Split(0, 2),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match(" aa ")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<3, groups: []),
		])
	}
	
	func testOneOrMoreNotNewlineMatchesAll() {
		let regex = try! Regex("\\S.+\\S")
		let matches = regex.match("a b c")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a b c", range: 0..<5, groups: [], groupRanges: []),
		])
	}
	
	func testOptionalMatchesAll() {
		let regex = try! Regex("\\S+(?:.+\\S+)?")
		let matches = regex.match("ab 1")
		XCTAssertEqual(matches, [
			RegexMatch(match: "ab 1", range: 0..<4, groups: [], groupRanges: []),
		])
	}
	
	func testGroupsHavingTheProperIndex() {
		let tokens = try! Lexer.lex("(a)(b)")
		let symbols = try! Parser.parse(tokens)
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.GroupSave(1, .Start),
			.Character("a"),
			.GroupSave(1, .End),
			.GroupSave(2, .Start),
			.Character("b"),
			.GroupSave(2, .End),
		])
	}
	
	func testEmptyGroupMatches() {
		let regex = try! Regex("a(a)?b")
		let matches = regex.match("ab")
		XCTAssertEqual(matches, [
			RegexMatch(match: "ab", range: 0..<2, groups: [""], groupRanges: [0..<0]),
		])
	}
	
	static var allTests = [
		("testWordBoundaryWorksWithNumbers", testWordBoundaryWorksWithNumbers),
		("testSplitResultChoosingSecondaryThreadIfPrimaryOneFails", testSplitResultChoosingSecondaryThreadIfPrimaryOneFails),
		("testOneOrMoreNotNewlineMatchesAll", testOneOrMoreNotNewlineMatchesAll),
		("testOptionalMatchesAll", testOptionalMatchesAll),
		("testGroupsHavingTheProperIndex", testGroupsHavingTheProperIndex),
	]
}

//
//  VMTests.swift
//  Regex
//

@testable import Regex
import XCTest

class VMTests: XCTestCase {
	func testAllCharactersButLines() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("\n\r\r\n".characters)),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("ab\nc")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 3..<4, groups: []),
		])
	}
	
	func testAllCharacters() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set()),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("a_")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testWordCharacters() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters), exclude: Set()),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aA 90")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 3..<4, groups: []),
			Match(id: ThreadID(), range: 4..<5, groups: []),
		])
	}
	
	func testNonWordCharacters() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters)),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aA 90")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testDigits() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("0123456789".characters), exclude: Set()),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("1_7")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testNotDigits() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("0123456789".characters)),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("1_9")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<2, groups: []),
		])
	}
	
	func testWhitespace() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(" \n\r\t\u{000B}\u{000C}".characters), exclude: Set()),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("a\t\n")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testNotWhitespace() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set(" \n\r\t\u{000B}\u{000C}".characters)),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("a\t\n")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
		])
	}
	
	func testSet() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABC".characters), exclude: Set()),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("zABCz")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
			Match(id: ThreadID(), range: 3..<4, groups: []),
		])
	}
	
	func testNotSet() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("ABC".characters)),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("zAbCz")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
			Match(id: ThreadID(), range: 4..<5, groups: []),
		])
	}
	
	func testSetRange() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters), exclude: Set()),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("Aa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
		])
	}
	
	func testBeginningOfString() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Start,
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
		])
	}
	
	func testEndOfString() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.End,
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testWordBoundary() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.WordBoundary,
			.Character("a"),
			.WordBoundary,
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("a-a")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testNotWordBoundary() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.NotWordBoundary,
			.Character("a"),
			.NotWordBoundary,
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<2, groups: []),
		])
	}
	
	func testOctalEscape() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("©c")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
		])
	}
	
	func testOctalEscapeTooLarge() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("\u{1F}"), // oct 37 == hex 1F
			.Character("8"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("\u{1F}8")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<2, groups: []),
		])
	}
	
	func testHexEscape() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("z©")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<2, groups: []),
		])
	}
	
	func testHexEscapeTooSmall() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("x"),
			.Character("A"),
			.Character("p"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("xAp xAAp")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: []),
		])
	}
	
	func testUnicodeEscape() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("c©c")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<2, groups: []),
		])
	}
	
	func testUnicodeEscapeTooSmall() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("u"),
			.Character("0"),
			.Character("0"),
			.Character(" "),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match(" u00 ")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 1..<5, groups: []),
		])
	}
	
	func testControlEscape() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("\t"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("\t")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
		])
	}
	
	func testControlEscapeTooSmall() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("c"),
			.Character(","),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("c,")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<2, groups: []),
		])
	}
	
	func testEscapeCharactersInSets() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("@©Ç\t".characters), exclude: Set()),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("@©Ç")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testUnprintableEscapeCharacters() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("\t"),
			.Character("\n"),
			.Character("\u{000B}"),
			.Character("\u{000C}"),
			.Character("\r"),
			.Character("\0"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("\t\n\u{0B}\u{0C}\r\0")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<6, groups: []),
		])
	}
	
	func testEscapeSpecialCharacters() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("."),
			.Character("\\"),
			.Character("+"),
			.Character("*"),
			.Character("?"),
			.Character("^"),
			.Character("$"),
			.Character("["),
			.Character("]"),
			.Character("{"),
			.Character("}"),
			.Character("("),
			.Character(")"),
			.Character("|"),
			.Character("/"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match(".\\+*?^$[]{}()|/")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<15, groups: []),
		])
	}
	
	func testCaptureGroup() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.GroupSave(1, .Start),
			.Character("A"),
			.Character("B"),
			.GroupSave(1, .End),
			.Character("C"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("ABC")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: [0..<2]),
		])
	}
	
//	func testBackReference() {
//		let instructions: [Instruction] = [
//			.GlobalSearchFlag,
//			.GroupSave(1, .Start),
//			.Character("A"),
//			.GroupSave(1, .End),
//			.BackReference(0),
//			.Character("\0"),
//		]
//		let engine = Engine(program: instructions)
//		let matches = engine.match("AA\0")
//		XCTAssertEqual(matches, [
//			Match(id: ThreadID(), range: 0..<3, groups: [0..<1]),
//		])
//	}
	
	func testNonCaptureGroup() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("A"),
			.Character("B"),
			.Character("C"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("ABC")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: []),
		])
	}
	
//	func testLookAhead() {
//		let instructions: [Instruction] = [
//			.GlobalSearchFlag,
//			.StartLookAhead,
//			.Character("A"),
//			.Character("B"),
//			.Character("C"),
//			.EndLook,
//		]
//		let engine = Engine(program: instructions)
//		let matches = engine.match("")
//		XCTAssertEqual(matches, [
//			// Unimplemented
//		])
//		XCTFail("Unimplemented")
//	}
	
//	func testNegativeLookAhead() {
//		let instructions: [Instruction] = [
//			.GlobalSearchFlag,
//			.StartNegativeLookAhead,
//			.Character("A"),
//			.Character("B"),
//			.Character("C"),
//			.EndLook,
//		]
//		let engine = Engine(program: instructions)
//		let matches = engine.match("")
//		XCTAssertEqual(matches, [
//			// Unimplemented
//		])
//		XCTFail("Unimplemented")
//	}
	
//	func testLookBehind() {
//		let instructions: [Instruction] = [
//			.GlobalSearchFlag,
//			.StartLookBehind,
//			.Character("A"),
//			.Character("B"),
//			.Character("C"),
//			.EndLook,
//		]
//		let engine = Engine(program: instructions)
//		let matches = engine.match("")
//		XCTAssertEqual(matches, [
//			// Unimplemented
//		])
//		XCTFail("Unimplemented")
//	}
	
//	func testNegativeLookbehind() {
//		let instructions: [Instruction] = [
//			.GlobalSearchFlag,
//			.StartNegativeLookBehind,
//			.Character("A"),
//			.Character("B"),
//			.Character("C"),
//			.EndLook,
//		]
//		let engine = Engine(program: instructions)
//		let matches = engine.match("")
//		XCTAssertEqual(matches, [
//			// Unimplemented
//		])
//		XCTFail("Unimplemented")
//	}
	
	func testOptional() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Split(1, 2),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match(" a")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<0, groups: []),
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 2..<2, groups: []),
		])
	}
	
	func testOneOrMore() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Split(0, 2),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaaaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<5, groups: []),
		])
	}
	
	func testZeroOrMore() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Split(1, 3),
			.Character("a"),
			.Jump(0),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: []),
			Match(id: ThreadID(), range: 3..<3, groups: []),
		])
	}
	
	func testAmount() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<4, groups: []),
		])
	}
	
	func testAmountOrLess() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Split(1, 2),
			.Character("a"),
			.Split(3, 4),
			.Character("a"),
			.Split(5, 6),
			.Character("a"),
			.Split(7, 8),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<2, groups: []),
			Match(id: ThreadID(), range: 2..<2, groups: []),
		])
	}
	
	func testAmountOrMore() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Split(3, 5),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaa aaaaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 4..<9, groups: []),
		])
	}
	
	func testAmountRange() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Split(5, 6),
			.Character("a"),
			.Split(7, 8),
			.Character("a"),
			.Split(9, 10),
			.Character("a"),
			.Split(11, 12),
			.Character("a"),
			.Split(13, 14),
			.Character("a"),
			.Split(15, 16),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaaaaaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<7, groups: []),
		])
	}
	
	func testLazyOptional() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Split(2, 1),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("a")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<0, groups: []),
			Match(id: ThreadID(), range: 1..<1, groups: []),
		])
	}
	
	func testLazyOneOrMore() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Split(2, 0),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
			Match(id: ThreadID(), range: 1..<2, groups: []),
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testLazyZeroOrMore() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Split(3, 1),
			.Character("a"),
			.Jump(1),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("a")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<0, groups: []),
			Match(id: ThreadID(), range: 1..<1, groups: []),
		])
	}
	
	func testLazyAmount() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaaaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<5, groups: []),
		])
	}
	
	func testLazyAmountOrLess() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Split(2, 1),
			.Character("a"),
			.Split(4, 3),
			.Character("a"),
			.Split(6, 5),
			.Character("a"),
			.Split(8, 7),
			.Character("a"),
			.Split(10, 9),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<0, groups: []),
			Match(id: ThreadID(), range: 1..<1, groups: []),
			Match(id: ThreadID(), range: 2..<2, groups: []),
		])
	}
	
	func testLazyAmountOrMore() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Split(6, 4),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaaaaaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<5, groups: []),
		])
	}
	
	func testLazyAmountRange() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Split(7, 6),
			.Character("a"),
			.Split(9, 8),
			.Character("a"),
			.Split(11, 10),
			.Character("a"),
			.Split(13, 12),
			.Character("a"),
			.Split(15, 14),
			.Character("a"),
			.Split(17, 16),
			.Character("a"),
			.Split(19, 18),
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaaaaaaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<5, groups: []),
		])
	}
	
	func testAlternation() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Split(1, 4),
			.Character("a"),
			.Character("b"),
			.Jump(6),
			.Character("1"),
			.Character("2"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("ab12")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<2, groups: []),
			Match(id: ThreadID(), range: 2..<4, groups: []),
		])
	}
	
	func testAlternationInGroup() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("1"),
			.Split(2, 4),
			.Character("a"),
			.Jump(8),
			.Split(5, 7),
			.Character("b"),
			.Jump(8),
			.Character("c"),
			.Character("2"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("1a2 1b2 1c2 1ac2")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: []),
			Match(id: ThreadID(), range: 4..<7, groups: []),
			Match(id: ThreadID(), range: 8..<11, groups: []),
		])
	}
	
	func testiFlag() {
		let instructions: [Instruction] = [
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.CharacterSet(include: Set("cd".characters), exclude: Set("abcdefghijklmnopqrstuvwxyz0123456789_".characters)),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("AbC")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: []),
		])
	}
	
	func testgFlag() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("abcabc")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: []),
			Match(id: ThreadID(), range: 3..<6, groups: []),
		])
	}
	
	func testmFlag() {
		let instructions: [Instruction] = [
			.MultilineFlag,
			.Start,
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("b\na")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 2..<3, groups: []),
		])
	}
	
	func testMultipleFlags() {
		let instructions: [Instruction] = [
			.MultilineFlag,
			.CaseInsensitiveFlag,
			.Start,
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("A\na")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
		])
	}
	
	func testNoFlags() {
		let instructions: [Instruction] = [
			.Character("a"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("aaa")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<1, groups: []),
		])
	}
	
	func testMultiCharacter() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("1"),
			.Character("2"),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("ab12")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<4, groups: []),
		])
	}
	
	func testNestedGroups() {
		let instructions: [Instruction] = [
			.GlobalSearchFlag,
			.GroupSave(1, .Start),
			.Character("a"),
			.GroupSave(2, .Start),
			.Character("b"),
			.GroupSave(3, .Start),
			.Character("c"),
			.GroupSave(3, .End),
			.GroupSave(2, .End),
			.GroupSave(1, .End),
		]
		let engine = Engine(program: instructions)
		let matches = engine.match("abc")
		XCTAssertEqual(matches, [
			Match(id: ThreadID(), range: 0..<3, groups: [0..<3, 1..<3, 2..<3]),
		])
	}
	
	func testVMSpeedWith_AN_A_Expression_1() {
		let n = 10
		let expression1 = [String](repeating: "a?", count: n).reduce("", +)
		let expression2 = String(repeating: "a", count: n)
		let tokens = try! Lexer.lex(expression1 + expression2)
		let symbols = try! Parser.parse(tokens)
		let instructions = Compiler.compile(symbols)
		let engine = Engine(program: instructions)
		
		var passes = 0
		measure {
			passes += 1
			print("Matching \(passes)/10")
			let _ = engine.match(expression2)
		}
	}
	
//	func testVMSpeedWith_AN_A_Expression_2() {
//		let n = 1_000
//		print("Creating expression")
//		let expression1 = [String](repeating: "a?", count: n).reduce("", combine: +)
//		let expression2 = String(repeating: Character("a"), count: n)
//		print("Tokenizing")
//		let tokens = try! Tokenizer.tokenize(expression1 + expression2)
//		print("Parsing")
//		let symbols = try! Parser.parse(tokens)
//		print("")
//		let instructions = Compiler.compile(symbols)
//		let engine = Engine(program: instructions)
//		
//		var passes = 0
//		measure {
//			passes += 1
//			print("Matching \(passes)/10")
//			let _ = engine.match(expression2)
//		}
//	}
//	
//	func testVMSpeedWith_AN_A_Expression_3() {
//		let n = 10_000
//		print("Creating exression")
//		let expression1 = [String](repeating: "a?", count: n).reduce("", combine: +)
//		let expression2 = String(repeating: Character("a"), count: n)
//		print("Tokenizing")
//		let tokens = try! Tokenizer.tokenize(expression1 + expression2)
//		print("Parsing")
//		let symbols = try! Parser.parse(tokens)
//		let instructions = Compiler.compile(symbols)
//		let engine = Engine(program: instructions)
//		
//		var passes = 0
//		measure {
//			passes += 1
//			print("Compiling \(passes)/10")
//			let _ = engine.match(expression2)
//		}
//	}
}

extension VMTests {
	static var allTests: [(String, (VMTests) -> () throws -> Void)] {
		return [
			("testAllCharactersButLines", testAllCharactersButLines),
			("testAllCharacters", testAllCharacters),
			("testWordCharacters", testWordCharacters),
			("testNonWordCharacters", testNonWordCharacters),
			("testDigits", testDigits),
			("testNotDigits", testNotDigits),
			("testWhitespace", testWhitespace),
			("testNotWhitespace", testNotWhitespace),
			("testSet", testSet),
			("testNotSet", testNotSet),
			("testSetRange", testSetRange),
			
			("testBeginningOfString", testBeginningOfString),
			("testEndOfString", testEndOfString),
			("testWordBoundary", testWordBoundary),
			("testNotWordBoundary", testNotWordBoundary),
			
			("testOctalEscape", testOctalEscape),
			("testOctalEscapeTooLarge", testOctalEscapeTooLarge),
			("testHexEscape", testHexEscape),
			("testHexEscapeTooSmall", testHexEscapeTooSmall),
			("testUnicodeEscape", testUnicodeEscape),
			("testUnicodeEscapeTooSmall", testUnicodeEscapeTooSmall),
			("testControlEscape", testControlEscape),
			("testControlEscapeTooSmall", testControlEscapeTooSmall),
			("testEscapeCharactersInSets", testEscapeCharactersInSets),
			("testUnprintableEscapeCharacters", testUnprintableEscapeCharacters),
			("testEscapeSpecialCharacters", testEscapeSpecialCharacters),
			
			("testCaptureGroup", testCaptureGroup),
//			("testBackReference", testBackReference),
			("testNonCaptureGroup", testNonCaptureGroup),
//			("testLookAhead", testLookAhead),
//			("testNegativeLookAhead", testNegativeLookAhead),
//			("testLookBehind", testLookBehind),
//			("testNegativeLookbehind", testNegativeLookbehind),
			
			("testOptional", testOptional),
			("testOneOrMore", testOneOrMore),
			("testZeroOrMore", testZeroOrMore),
			("testAmount", testAmount),
			("testAmountOrLess", testAmountOrLess),
			("testAmountOrMore", testAmountOrMore),
			("testAmountRange", testAmountRange),
			
			("testLazyOptional", testLazyOptional),
			("testLazyAmount", testLazyAmount),
			("testLazyOneOrMore", testLazyOneOrMore),
			("testLazyZeroOrMore", testLazyZeroOrMore),
			("testLazyAmountOrLess", testLazyAmountOrLess),
			("testLazyAmountOrMore", testLazyAmountOrMore),
			("testLazyAmountRange", testLazyAmountRange),
			
			("testAlternation", testAlternation),
			("testAlternationInGroup", testAlternationInGroup),
			
			("testiFlag", testiFlag),
			("testgFlag", testgFlag),
			("testmFlag", testmFlag),
			("testMultipleFlags", testMultipleFlags),
			("testNoFlags", testNoFlags),
			
			("testMultiCharacter", testMultiCharacter),
			("testNestedGroups", testNestedGroups),
			
//			("testVMSpeedWith_AN_A_Expression_1", testVMSpeedWith_AN_A_Expression_1),
//			("testVMSpeedWith_AN_A_Expression_2", testVMSpeedWith_AN_A_Expression_2),
//			("testVMSpeedWith_AN_A_Expression_3", testVMSpeedWith_AN_A_Expression_3),
		]
	}
}

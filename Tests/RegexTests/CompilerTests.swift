//
//  CompilerTests.swift
//  Regex
//

@testable import Regex
import XCTest

class CompilerTests: XCTestCase {
	func testAllCharactersButLines() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("\n\r\r\n".characters)),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("\n\r\r\n".characters)),
		])
	}
	
	func testAllCharacters() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set()),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set()),
		])
	}
	
	func testWordCharacters() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters), exclude: Set()),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters), exclude: Set()),
		])
	}
	
	func testNonWordCharacters() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters)),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters)),
		])
	}
	
	func testDigits() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("0123456789".characters), exclude: Set()),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("0123456789".characters), exclude: Set()),
		])
	}
	
	func testNotDigits() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("0123456789".characters)),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("0123456789".characters)),
		])
	}
	
	func testWhitespace() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters), exclude: Set()),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters), exclude: Set()),
		])
	}
	
	func testNotWhitespace() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters)),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters)),
		])
	}
	
	func testSet() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABC".characters), exclude: Set()),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABC".characters), exclude: Set()),
		])
	}
	
	func testNotSet() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("ABC".characters)),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("ABC".characters)),
		])
	}
	
	func testSetRange() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters), exclude: Set()),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters), exclude: Set()),
		])
	}
	
	func testBeginningOfString() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Start,
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Start,
		])
	}
	
	func testEndOfString() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.End,
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.End,
		])
	}
	
	func testWordBoundary() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.WordBoundary,
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.WordBoundary,
		])
	}
	
	func testNotWordBoundary() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.NotWordBoundary,
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.NotWordBoundary,
		])
	}
	
	func testOctalEscape() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testOctalEscapeTooLarge() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("\u{1F}"), // oct 37 == hex 1F
			.Character("8"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("\u{1F}"), // oct 37 == hex 1F
			.Character("8"),
		])
	}
	
	func testHexEscape() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testHexEscapeTooSmall() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("x"),
			.Character("A"),
			.Character("p"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("x"),
			.Character("A"),
			.Character("p"),
		])
	}
	
	func testUnicodeEscape() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testUnicodeEscapeTooSmall() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("u"),
			.Character("0"),
			.Character("0"),
			.Character(" "),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("u"),
			.Character("0"),
			.Character("0"),
			.Character(" "),
		])
	}
	
	func testControlEscape() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("\t"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("\t"),
		])
	}
	
	func testControlEscapeTooSmall() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("c"),
			.Character(","),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("c"),
			.Character(","),
		])
	}
	
	func testEscapeCharactersInSets() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("@©Ç\t".characters), exclude: Set()),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("@©Ç\t".characters), exclude: Set()),
		])
	}
	
	func testUnprintableEscapeCharacters() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("\t"),
			.Character("\n"),
			.Character("\u{000B}"),
			.Character("\u{000C}"),
			.Character("\r"),
			.Character("\0"),
			.Character("\r\n"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("\t"),
			.Character("\n"),
			.Character("\u{000B}"),
			.Character("\u{000C}"),
			.Character("\r"),
			.Character("\0"),
			.Character("\r\n"),
		])
	}
	
	func testEscapeSpecialCharacters() {
		let symbols: [Symbol] = [
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
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
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
		])
	}
	
	func testCaptureGroup() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CaptureGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.GroupSave(1, .Start),
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.GroupSave(1, .End),
		])
	}
	
	func testBackReference() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CaptureGroup([
				.Character("A"),
			]),
			.BackReference(0),
			.Character("\0"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.GroupSave(1, .Start),
			.Character("A"),
			.GroupSave(1, .End),
			.BackReference(0),
			.Character("\0"),
		])
	}
	
	func testNonCaptureGroup() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Group([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("A"),
			.Character("B"),
			.Character("C"),
		])
	}
	
	func testLookAhead() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LookAheadGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.StartLookAhead,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndLook,
		])
	}
	
	func testNegativeLookAhead() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.NegativeLookAheadGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.StartNegativeLookAhead,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndLook,
		])
	}
	
	func testLookBehind() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LookBehindGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.StartLookBehind,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndLook,
		])
	}
	
	func testNegativeLookbehind() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.NegativeLookBehindGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.StartNegativeLookBehind,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndLook,
		])
	}
	
	func testOptional() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Optional(.Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Split(1, 2),
			.Character("a"),
		])
	}
	
	func testOneOrMore() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.OneOrMore(.Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Split(0, 2),
		])
	}
	
	func testZeroOrMore() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.ZeroOrMore(.Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Split(1, 3),
			.Character("a"),
			.Jump(0),
		])
	}
	
	func testAmount() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Amount(4, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
		])
	}
	
	func testAmountOrLess() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.AmountOrLess(4, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Split(1, 2),
			.Character("a"),
			.Split(3, 4),
			.Character("a"),
			.Split(5, 6),
			.Character("a"),
			.Split(7, 8),
			.Character("a"),
		])
	}
	
	func testAmountOrMore() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.AmountOrMore(4, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Split(3, 5),
		])
	}
	
	func testAmountRange() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.AmountRange(4, 10, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
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
		])
	}
	
	func testLazyOptional() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LazyOptional(.Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Split(2, 1),
			.Character("a"),
		])
	}
	
	func testLazyOneOrMore() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LazyOneOrMore(.Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Split(2, 0),
		])
	}
	
	func testLazyZeroOrMore() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LazyZeroOrMore(.Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Split(3, 1),
			.Character("a"),
			.Jump(0),
		])
	}
	
	func testLazyAmount() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LazyAmount(5, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
		])
	}
	
	func testLazyAmountOrLess() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LazyAmountOrLess(5, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
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
		])
	}
	
	func testLazyAmountOrMore() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LazyAmountOrMore(5, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Character("a"),
			.Split(6, 4),
		])
	}
	
	func testLazyAmountRange() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.LazyAmountRange(5, 12, .Character("a")),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
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
		])
	}
	
	func testAlternation() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Alternation([
				.Character("a"),
				.Character("b"),
			],
			[
				.Character("1"),
				.Character("2"),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Split(1, 4),
			.Character("a"),
			.Character("b"),
			.Jump(6),
			.Character("1"),
			.Character("2"),
		])
	}
	
	func testAlternationInGroup() {
		let symbols: [Symbol] = [
			.Character("1"),
			.Group([
				.Alternation([
					.Character("a"),
				],
				[
					.Alternation([
						.Character("b"),
					],
					[
						.Character("c"),
					]),
				]),
			]),
			.Character("2"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.Character("1"),
			.Split(2, 4),
			.Character("a"),
			.Jump(8),
			.Split(5, 7),
			.Character("b"),
			.Jump(8),
			.Character("c"),
			.Character("2"),
		])
	}
	
	func testiFlag() {
		let symbols: [Symbol] = [
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.CharacterSet(include: Set("cd".characters), exclude: Set("abcdefghijklmnopqrstuvwxyz0123456789_".characters)),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.CharacterSet(include: Set("cd".characters), exclude: Set("abcdefghijklmnopqrstuvwxyz0123456789_".characters)),
		])
	}
	
	func testgFlag() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testmFlag() {
		let symbols: [Symbol] = [
			.MultilineFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.MultilineFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testMultipleFlags() {
		let symbols: [Symbol] = [
			.MultilineFlag,
			.GlobalSearchFlag,
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.MultilineFlag,
			.GlobalSearchFlag,
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testMultiCharacter() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("1"),
			.Character("2"),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("1"),
			.Character("2"),
		])
	}
	
	func testNestedGroups() {
		let symbols: [Symbol] = [
			.GlobalSearchFlag,
			.CaptureGroup([
				.Character("a"),
				.CaptureGroup([
					.Character("b"),
					.CaptureGroup([
						.Character("c"),
					]),
				]),
			]),
		]
		let instructions = Compiler.compile(symbols)
		XCTAssertEqual(instructions, [
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
		])
	}
	
//	func testCompilerSpeedWith_AN_A_Expression_1() {
//		let n = 1_000
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		let tokens = try! Tokenizer.tokenize(expression)
//		let symbols = try! Parser.parse(tokens)
//		
//		measure {
//			let _ = Compiler.compile(symbols)
//		}
//	}
//	
//	func testCompilerSpeedWith_AN_A_Expression_2() {
//		let n = 10_000
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		let tokens = try! Tokenizer.tokenize(expression)
//		let symbols = try! Parser.parse(tokens)
//		
//		measure {
//			let _ = Compiler.compile(symbols)
//		}
//	}
//	
//	func testCompilerSpeedWith_AN_A_Expression_3() {
//		let n = 100_000
//		print("Creating exression")
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		print("Tokenizing")
//		let tokens = try! Tokenizer.tokenize(expression)
//		print("Parsing")
//		let symbols = try! Parser.parse(tokens)
//		
//		var passes = 0
//		measure {
//			passes += 1
//			print("Compiling \(passes)/10")
//			let _ = Compiler.compile(symbols)
//		}
//	}
	
	static var allTests = [
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
		("testBackReference", testBackReference),
		("testNonCaptureGroup", testNonCaptureGroup),
		("testLookAhead", testLookAhead),
		("testNegativeLookAhead", testNegativeLookAhead),
		("testLookBehind", testLookBehind),
		("testNegativeLookbehind", testNegativeLookbehind),
		
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
		
		("testMultiCharacter", testMultiCharacter),
		("testNestedGroups", testNestedGroups),
		
//		("testCompilerSpeedWith_AN_A_Expression_1", testCompilerSpeedWith_AN_A_Expression_1),
//		("testCompilerSpeedWith_AN_A_Expression_2", testCompilerSpeedWith_AN_A_Expression_2),
//		("testCompilerSpeedWith_AN_A_Expression_3", testCompilerSpeedWith_AN_A_Expression_3),
	]
}
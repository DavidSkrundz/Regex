//
//  ParserTests.swift
//  Regex
//

@testable import Regex
import XCTest

class ParserTests: XCTestCase {
	func testAllCharactersButLines() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("\n\r\r\n".characters)),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("\n\r\r\n".characters)),
		])
	}
	
	func testAllCharacters() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set()),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set()),
		])
	}
	
	func testWordCharacters() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters), exclude: Set()),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters), exclude: Set()),
		])
	}
	
	func testNonWordCharacters() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters)),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters)),
		])
	}
	
	func testDigits() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("0123456789".characters), exclude: Set()),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("0123456789".characters), exclude: Set()),
		])
	}
	
	func testNotDigits() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("0123456789".characters)),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("0123456789".characters)),
		])
	}
	
	func testWhitespace() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters), exclude: Set()),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters), exclude: Set()),
		])
	}
	
	func testNotWhitespace() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters)),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters)),
		])
	}
	
	func testSet() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABC".characters), exclude: Set()),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABC".characters), exclude: Set()),
		])
	}
	
	func testNotSet() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("ABC".characters)),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("ABC".characters)),
		])
	}
	
	func testSetRange() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters), exclude: Set()),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters), exclude: Set()),
		])
	}
	
	func testBeginningOfString() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Start,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Start,
		])
	}
	
	func testEndOfString() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.End,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.End,
		])
	}
	
	func testWordBoundary() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.WordBoundary,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.WordBoundary,
		])
	}
	
	func testNotWordBoundary() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.NotWordBoundary,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.NotWordBoundary,
		])
	}
	
	func testOctalEscape() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testOctalEscapeTooLarge() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("\u{1F}"), // oct 37 == hex 1F
			.Character("8"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("\u{1F}"), // oct 37 == hex 1F
			.Character("8"),
		])
	}
	
	func testHexEscape() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testHexEscapeTooSmall() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("x"),
			.Character("A"),
			.Character("p"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("x"),
			.Character("A"),
			.Character("p"),
		])
	}
	
	func testUnicodeEscape() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("©"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testUnicodeEscapeTooSmall() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("u"),
			.Character("0"),
			.Character("0"),
			.Character(" "),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("u"),
			.Character("0"),
			.Character("0"),
			.Character(" "),
		])
	}
	
	func testControlEscape() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("\t"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("\t"),
		])
	}
	
	func testControlEscapeTooSmall() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("c"),
			.Character(","),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("c"),
			.Character(","),
		])
	}
	
	func testEscapeCharactersInSets() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("@©Ç\t".characters), exclude: Set()),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("@©Ç\t".characters), exclude: Set()),
		])
	}
	
	func testUnprintableEscapeCharacters() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("\t"),
			.Character("\n"),
			.Character("\u{000B}"),
			.Character("\u{000C}"),
			.Character("\r"),
			.Character("\0"),
			.Character("\r\n"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
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
		let tokens: [Token] = [
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
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
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
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartCaptureGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CaptureGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		])
	}
	
	func testBackReference() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartCaptureGroup,
			.Character("A"),
			.EndGroup,
			.OctalCharacter("\u{1}"),
			.OctalCharacter("\0"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.CaptureGroup([
				.Character("A"),
			]),
			.BackReference(0),
			.Character("\0"),
		])
	}
	
	func testNonCaptureGroup() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Group([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		])
	}
	
	func testLookAhead() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartLookAheadGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LookAheadGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		])
	}
	
	func testNegativeLookAhead() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartNegativeLookAheadGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.NegativeLookAheadGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		])
	}
	
	func testLookBehind() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartLookBehindGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LookBehindGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		])
	}
	
	func testNegativeLookbehind() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartNegativeLookBehindGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.NegativeLookBehindGroup([
				.Character("A"),
				.Character("B"),
				.Character("C"),
			]),
		])
	}
	
	func testOptional() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Optional,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Optional(.Character("a")),
		])
	}
	
	func testOneOrMore() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.OneOrMore,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.OneOrMore(.Character("a")),
		])
	}
	
	func testZeroOrMore() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.ZeroOrMore,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.ZeroOrMore(.Character("a")),
		])
	}
	
	func testAmount() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Amount(4),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Amount(4, .Character("a")),
		])
	}
	
	func testAmountOrLess() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.AmountOrLess(4),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.AmountOrLess(4, .Character("a")),
		])
	}
	
	func testAmountOrMore() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.AmountOrMore(4),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.AmountOrMore(4, .Character("a")),
		])
	}
	
	func testAmountRange() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.AmountRange(4, 10),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.AmountRange(4, 10, .Character("a")),
		])
	}
	
	func testLazyOptional() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyOptional,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LazyOptional(.Character("a")),
		])
	}
	
	func testLazyOneOrMore() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyOneOrMore,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LazyOneOrMore(.Character("a")),
		])
	}
	
	func testLazyZeroOrMore() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyZeroOrMore,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LazyZeroOrMore(.Character("a")),
		])
	}
	
	func testLazyAmount() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmount(5),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LazyAmount(5, .Character("a")),
		])
	}
	
	func testLazyAmountOrLess() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmountOrLess(5),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LazyAmountOrLess(5, .Character("a")),
		])
	}
	
	func testLazyAmountOrMore() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmountOrMore(5),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LazyAmountOrMore(5, .Character("a")),
		])
	}
	
	func testLazyAmountRange() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmountRange(5, 12),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.LazyAmountRange(5, 12, .Character("a")),
		])
	}
	
	func testAlternation() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Alternation,
			.Character("1"),
			.Character("2"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Alternation([
				.Character("a"),
				.Character("b"),
			],
			[
				.Character("1"),
				.Character("2"),
			]),
		])
	}
	
	func testAlternationInGroup() {
		let tokens: [Token] = [
			.Character("1"),
			.StartGroup,
			.Character("a"),
			.Alternation,
			.Character("b"),
			.Alternation,
			.Character("c"),
			.EndGroup,
			.Character("2"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
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
		])
	}
	
	func testiFlag() {
		let tokens: [Token] = [
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.CharacterSet(include: Set("cd".characters), exclude: Set("abcdefghijklmnopqrstuvwxyz0123456789_".characters)),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.CharacterSet(include: Set("cd".characters), exclude: Set("abcdefghijklmnopqrstuvwxyz0123456789_".characters)),
		])
	}
	
	func testgFlag() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testmFlag() {
		let tokens: [Token] = [
			.MultilineFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.MultilineFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testMultipleFlags() {
		let tokens: [Token] = [
			.MultilineFlag,
			.GlobalSearchFlag,
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.MultilineFlag,
			.GlobalSearchFlag,
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testMultiCharacter() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("1"),
			.Character("2"),
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("1"),
			.Character("2"),
		])
	}
	
	func testNestedGroups() {
		let tokens: [Token] = [
			.GlobalSearchFlag,
			.StartCaptureGroup,
			.Character("a"),
			.StartCaptureGroup,
			.Character("b"),
			.StartCaptureGroup,
			.Character("c"),
			.EndGroup,
			.EndGroup,
			.EndGroup,
		]
		let symbols = try! Parser.parse(tokens)
		XCTAssertEqual(symbols, [
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
		])
	}
	
	func testUnmatchesStartGroup() {
		do {
			let _ = try Parser.parse([.StartGroup])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedOpeningParenthesis)
		} catch let err {
			XCTFail("Wrong error \(err) was thrown")
		}
	}
	
	func testUnmatchedStartCaptureGroup() {
		do {
			let _ = try Parser.parse([.StartCaptureGroup])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedOpeningParenthesis)
		} catch let err {
			XCTFail("Wrong error \(err) was thrown")
		}
	}
	
	func testUnmatchedLookAheadGroup() {
		do {
			let _ = try Parser.parse([.StartLookAheadGroup])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedOpeningParenthesis)
		} catch let err {
			XCTFail("Wrong error \(err) was thrown")
		}
	}
	
	func testUnmatchedNegativeLookAheadGroup() {
		do {
			let _ = try Parser.parse([.StartNegativeLookAheadGroup])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedOpeningParenthesis)
		} catch let err {
			XCTFail("Wrong error \(err) was thrown")
		}
	}
	
	func testUnmatchedLookBehindGroup() {
		do {
			let _ = try Parser.parse([.StartLookBehindGroup])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedOpeningParenthesis)
		} catch let err {
			XCTFail("Wrong error \(err) was thrown")
		}
	}
	
	func testUnmatchedNegativeLookBehindGroup() {
		do {
			let _ = try Parser.parse([.StartNegativeLookBehindGroup])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedOpeningParenthesis)
		} catch let err {
			XCTFail("Wrong error \(err) was thrown")
		}
	}
	
	func testInvalidOptionalTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .Optional, .Optional])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidOneOrMoreTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .OneOrMore, .OneOrMore])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidZeroOrMoreTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .ZeroOrMore, .ZeroOrMore])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidAmountTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .Amount(1), .Amount(1)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidAmountOrLessTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .AmountOrLess(1), .AmountOrLess(1)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidAmountOrMoreTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .AmountOrMore(1), .AmountOrMore(1)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidAmountRangeTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyAmountRange(1, 2), .LazyAmountRange(1, 2)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidLazyOptionalTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyOptional, .LazyOptional])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidLazyOneOrMoreTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyOneOrMore, .LazyOneOrMore])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidLazyZeroOrOneTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyZeroOrMore, .LazyZeroOrMore])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidLazyAmountTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyAmount(1), .LazyAmount(1)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidLazyAmountOrLessTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyAmountOrLess(1), .LazyAmountOrLess(1)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidLazyAmountOrMoreTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyAmountOrMore(1), .LazyAmountOrMore(1)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
	func testInvalidLazyAmountRangeTarget() {
		do {
			let _ = try Parser.parse([.Character("a"), .LazyAmountRange(1, 2), .LazyAmountRange(1, 2)])
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidTargetForQuantifier)
		} catch let err {
			XCTFail("Wrong error was thrown: \(err)")
		}
	}
	
//	func testParserSpeedWith_AN_A_Expression_1() {
//		let n = 100
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		let tokens = try! Tokenizer.tokenize(expression)
//		
//		measure {
//			let _ = try! Parser.parse(tokens)
//		}
//	}
//	
//	func testParserSpeedWith_AN_A_Expression_2() {
//		let n = 1_000
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		let tokens = try! Tokenizer.tokenize(expression)
//		
//		measure {
//			let _ = try! Parser.parse(tokens)
//		}
//	}
//	
//	func testParserSpeedWith_AN_A_Expression_3() {
//		let n = 10_000
//		print("Creating exression")
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		print("Tokenizing")
//		let tokens = try! Tokenizer.tokenize(expression)
//		
//		var passes = 0
//		measure {
//			passes += 1
//			print("Parsing \(passes)/10")
//			let _ = try! Parser.parse(tokens)
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
		
		("testUnmatchesStartGroup", testUnmatchesStartGroup),
		("testUnmatchedStartCaptureGroup", testUnmatchedStartCaptureGroup),
		("testUnmatchedLookAheadGroup", testUnmatchedLookAheadGroup),
		("testUnmatchedNegativeLookAheadGroup", testUnmatchedNegativeLookAheadGroup),
		("testUnmatchedLookBehindGroup", testUnmatchedLookBehindGroup),
		("testUnmatchedNegativeLookBehindGroup", testUnmatchedNegativeLookBehindGroup),
		
		("testInvalidOptionalTarget", testInvalidOptionalTarget),
		("testInvalidOneOrMoreTarget", testInvalidOneOrMoreTarget),
		("testInvalidZeroOrMoreTarget", testInvalidZeroOrMoreTarget),
		("testInvalidAmountTarget", testInvalidAmountTarget),
		("testInvalidAmountOrLessTarget", testInvalidAmountOrLessTarget),
		("testInvalidAmountOrMoreTarget", testInvalidAmountOrMoreTarget),
		("testInvalidAmountRangeTarget", testInvalidAmountRangeTarget),
		("testInvalidLazyOptionalTarget", testInvalidLazyOptionalTarget),
		("testInvalidLazyOneOrMoreTarget", testInvalidLazyOneOrMoreTarget),
		("testInvalidLazyZeroOrOneTarget", testInvalidLazyZeroOrOneTarget),
		("testInvalidLazyAmountTarget", testInvalidLazyAmountTarget),
		("testInvalidLazyAmountOrLessTarget", testInvalidLazyAmountOrLessTarget),
		("testInvalidLazyAmountOrMoreTarget", testInvalidLazyAmountOrMoreTarget),
		("testInvalidLazyAmountRangeTarget", testInvalidLazyAmountRangeTarget),
		
//		("testParserSpeedWith_AN_A_Expression_1", testParserSpeedWith_AN_A_Expression_1),
//		("testParserSpeedWith_AN_A_Expression_2", testParserSpeedWith_AN_A_Expression_2),
//		("testParserSpeedWith_AN_A_Expression_3", testParserSpeedWith_AN_A_Expression_3),
	]
}

//
//  LexerTests
//  Regex
//

@testable import Regex
import XCTest

class LexerTests: XCTestCase {
	func testAllCharactersButLines() {
		let tokens = try! Lexer.lex(".")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("\n\r\r\n".characters)),
		])
	}
	
	func testAllCharacters() {
		let tokens = try! Lexer.lex("[^]")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set()),
		])
	}
	
	func testWordCharacters() {
		let tokens = try! Lexer.lex("\\w")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters), exclude: Set()),
		])
	}
	
	func testNonWordCharacters() {
		let tokens = try! Lexer.lex("\\W")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters)),
		])
	}
	
	func testDigits() {
		let tokens = try! Lexer.lex("\\d")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("0123456789".characters), exclude: Set()),
		])
	}
	
	func testNotDigits() {
		let tokens = try! Lexer.lex("\\D")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("0123456789".characters)),
		])
	}
	
	func testWhitespace() {
		let tokens = try! Lexer.lex("\\s")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters), exclude: Set()),
		])
	}
	
	func testNotWhitespace() {
		let tokens = try! Lexer.lex("\\S")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set(" \n\r\r\n\t\u{000B}\u{000C}".characters)),
		])
	}
	
	func testSet() {
		let tokens = try! Lexer.lex("[ABC]")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABC".characters), exclude: Set()),
		])
	}
	
	func testNotSet() {
		let tokens = try! Lexer.lex("[^ABC]")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set(), exclude: Set("ABC".characters)),
		])
	}
	
	func testSetRange() {
		let tokens = try! Lexer.lex("[A-Z]")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters), exclude: Set()),
		])
	}
	
	func testBeginningOfString() {
		let tokens = try! Lexer.lex("^")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Start,
		])
	}
	
	func testEndOfString() {
		let tokens = try! Lexer.lex("$")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.End,
		])
	}
	
	func testWordBoundary() {
		let tokens = try! Lexer.lex("\\b")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.WordBoundary,
		])
	}
	
	func testNotWordBoundary() {
		let tokens = try! Lexer.lex("\\B")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.NotWordBoundary,
		])
	}
	
	func testOctalEscape() {
		let tokens = try! Lexer.lex("\\251")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.OctalCharacter("©"),
		])
	}
	
	func testOctalEscapeTooLarge() {
		let tokens = try! Lexer.lex("\\378")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.OctalCharacter("\u{1F}"), // oct 37 == hex 1F
			.Character("8"),
		])
	}
	
	func testInvalidOctEscape() {
		let tokens = try! Lexer.lex("\\555")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.OctalCharacter("\u{2D}"), // oct 5 == hex 2D
			.Character("5"),
		])
	}
	
	func testHexEscape() {
		let tokens = try! Lexer.lex("\\xA9")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testHexEscapeTooSmall() {
		let tokens = try! Lexer.lex("\\xAp")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("x"),
			.Character("A"),
			.Character("p"),
		])
	}
	
	func testUnicodeEscape() {
		let tokens = try! Lexer.lex("\\u00A9")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("©"),
		])
	}
	
	func testUnicodeEscapeTooSmall() {
		let tokens = try! Lexer.lex("\\u00 ")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("u"),
			.Character("0"),
			.Character("0"),
			.Character(" "),
		])
	}
	
	func testControlEscape() {
		let tokens = try! Lexer.lex("\\cI")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("\t"),
		])
	}
	
	func testControlEscapeTooSmall() {
		let tokens = try! Lexer.lex("\\c,")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("c"),
			.Character(","),
		])
	}
	
	func testEscapeCharactersInSets() {
		let tokens = try! Lexer.lex("[\\100\\xA9\\u00C7\\cI]")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.CharacterSet(include: Set("@©Ç\t".characters), exclude: Set())
		])
	}
	
	func testUnprintableEscapeCharacters() {
		let tokens = try! Lexer.lex("\\t\\n\\v\\f\\r\\0\r\n")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("\t"),
			.Character("\n"),
			.Character("\u{000B}"),
			.Character("\u{000C}"),
			.Character("\r"),
			.OctalCharacter("\0"),
			.Character("\r\n"),
		])
	}
	
	func testEscapeSpecialCharacters() {
		let tokens = try! Lexer.lex("\\.\\\\\\+\\*\\?\\^\\$\\[\\]\\{\\}\\(\\)\\|\\/")
		XCTAssertEqual(tokens, [
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
		let tokens = try! Lexer.lex("(ABC)")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.StartCaptureGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		])
	}
	
	func testNonCaptureGroup() {
		let tokens = try! Lexer.lex("(?:ABC)")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.StartGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		])
	}
	
	func testLookAhead() {
		let tokens = try! Lexer.lex("(?=ABC)")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.StartLookAheadGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		])
	}
	
	func testNegativeLookAhead() {
		let tokens = try! Lexer.lex("(?!ABC)")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.StartNegativeLookAheadGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		])
	}
	
	func testLookBehind() {
		let tokens = try! Lexer.lex("(?<=ABC)")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.StartLookBehindGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		])
	}
	
	func testNegativeLookbehind() {
		let tokens = try! Lexer.lex("(?<!ABC)")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.StartNegativeLookBehindGroup,
			.Character("A"),
			.Character("B"),
			.Character("C"),
			.EndGroup,
		])
	}
	
	func testOptional() {
		let tokens = try! Lexer.lex("a?")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.Optional,
		])
	}
	
	func testOneOrMore() {
		let tokens = try! Lexer.lex("a+")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.OneOrMore,
		])
	}
	
	func testZeroOrMore() {
		let tokens = try! Lexer.lex("a*")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.ZeroOrMore,
		])
	}
	
	func testAmount() {
		let tokens = try! Lexer.lex("a{4}")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.Amount(4),
		])
	}
	
	func testAmountOrLess() {
		let tokens = try! Lexer.lex("a{,4}")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.AmountOrLess(4),
		])
	}
	
	func testAmountOrMore() {
		let tokens = try! Lexer.lex("a{4,}")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.AmountOrMore(4),
		])
	}
	
	func testAmountRange() {
		let tokens = try! Lexer.lex("a{4,10}")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.AmountRange(4, 10)
		])
	}
	
	func testLazyOptional() {
		let tokens = try! Lexer.lex("a??")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyOptional,
		])
	}
	
	func testLazyOneOrMore() {
		let tokens = try! Lexer.lex("a+?")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyOneOrMore,
		])
	}
	
	func testLazyZeroOrMore() {
		let tokens = try! Lexer.lex("a*?")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyZeroOrMore,
		])
	}
	
	func testLazyAmount() {
		let tokens = try! Lexer.lex("a{5}?")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmount(5),
		])
	}
	
	func testLazyAmountOrLess() {
		let tokens = try! Lexer.lex("a{,5}?")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmountOrLess(5),
		])
	}
	
	func testLazyAmountOrMore() {
		let tokens = try! Lexer.lex("a{5,}?")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmountOrMore(5),
		])
	}
	
	func testLazyAmountRange() {
		let tokens = try! Lexer.lex("a{5,12}?")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.LazyAmountRange(5, 12),
		])
	}
	
	func testAlternation() {
		let tokens = try! Lexer.lex("ab|12")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Alternation,
			.Character("1"),
			.Character("2"),
		])
	}
	
	func testiFlag() {
		let tokens = try! Lexer.lex("/aB[cD\\W]\\u0050/i")
		XCTAssertEqual(tokens, [
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.CharacterSet(
				include: Set("cd".characters),
				exclude: Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".characters)
			),
			.Character("p"), // \u0050 -> P
		])
	}
	
	func testgFlag() {
		let tokens = try! Lexer.lex("/abc/g")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testmFlag() {
		let tokens = try! Lexer.lex("/abc/m")
		XCTAssertEqual(tokens, [
			.MultilineFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testMultipleFlags() {
		let tokens = try! Lexer.lex("/abc/igm")
		XCTAssertEqual(tokens, [
			.MultilineFlag,
			.GlobalSearchFlag,
			.CaseInsensitiveFlag,
			.Character("a"),
			.Character("b"),
			.Character("c"),
		])
	}
	
	func testMultiCharacter() {
		let tokens = try! Lexer.lex("ab12")
		XCTAssertEqual(tokens, [
			.GlobalSearchFlag,
			.Character("a"),
			.Character("b"),
			.Character("1"),
			.Character("2"),
		])
	}
	
	func testNestedGroups() {
		let tokens = try! Lexer.lex("(a(b(c)))")
		XCTAssertEqual(tokens, [
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
		])
	}

	func testDanglingBackslash() {
		do {
			let _ = try Lexer.lex("\\")
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.DanglingBackslash)
		} catch let err {
			XCTFail("\(err) was thrown")
		}
	}
	
	func testUnmatchedOpenBracket() {
		do {
			let _ = try Lexer.lex("[")
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedOpeningBracket)
		} catch let err {
			XCTFail("\(err) was thrown")
		}
	}
	
	func testUnmatchedClosingBracket() {
		do {
			let _ = try Lexer.lex("]")
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.UnmatchedClosingBracket)
		} catch let err {
			XCTFail("\(err) was thrown")
		}
	}
	
	func testQuantifierRangeError() {
		do {
			let _ = try Lexer.lex("{2,1}")
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidQuantifierRange)
		} catch let err {
			XCTFail("\(err) was thrown")
		}
	}
	
	func testSetReversedRangeError() {
		do {
			let _ = try Lexer.lex("[z-a]")
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.ReversedSetRange)
		} catch let err {
			XCTFail("\(err) was thrown")
		}
	}
	
	func testInvalidFlag() {
		do {
			let _ = try Lexer.lex("/a/d")
			XCTFail("No error was thrown")
		} catch let err as RegexError {
			XCTAssertEqual(err, RegexError.InvalidFlags)
		} catch let err {
			XCTFail("\(err) was thrown")
		}
	}
	
//	func testTokeninzerSpeedWith_AN_A_Expression_1() {
//		let n = 1_000
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		
//		measure { 
//			let _ = try! Lexer.lex(expression)
//		}
//	}
//	
//	func testTokeninzerSpeedWith_AN_A_Expression_2() {
//		let n = 10_000
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		
//		measure {
//			let _ = try! Lexer.lex(expression)
//		}
//	}
//	
//	func testTokeninzerSpeedWith_AN_A_Expression_3() {
//		let n = 100_000
//		print("Creating exression")
//		let expression = [String](repeating: "a?", count: n).reduce("", combine: +) + String(repeating: Character("a"), count: n)
//		
//		var passes = 0
//		measure {
//			passes += 1
//			print("Tokenizing \(passes)/10")
//			let _ = try! Lexer.lex(expression)
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
		("testInvalidOctEscape", testInvalidOctEscape),
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
		
		("testiFlag", testiFlag),
		("testgFlag", testgFlag),
		("testmFlag", testmFlag),
		("testMultipleFlags", testMultipleFlags),
		
		("testMultiCharacter", testMultiCharacter),
		("testNestedGroups", testNestedGroups),
		
		("testDanglingBackslash", testDanglingBackslash),
		("testUnmatchedOpenBracket", testUnmatchedOpenBracket),
		("testUnmatchedClosingBracket", testUnmatchedClosingBracket),
		("testQuantifierRangeError", testQuantifierRangeError),
		("testSetReversedRangeError", testSetReversedRangeError),
		("testInvalidFlag", testInvalidFlag),
		
//		("testTokeninzerSpeedWith_AN_A_Expression_1", testTokeninzerSpeedWith_AN_A_Expression_1),
//		("testTokeninzerSpeedWith_AN_A_Expression_2", testTokeninzerSpeedWith_AN_A_Expression_2),
//		("testTokeninzerSpeedWith_AN_A_Expression_3", testTokeninzerSpeedWith_AN_A_Expression_3),
	]
}

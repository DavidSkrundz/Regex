//
//  RegexTests.swift
//  Regex
//

@testable import Regex
import XCTest

class RegexTests: XCTestCase {
	func testAllCharactersButLines() {
		let regex = try! Regex(".")
		let matches = regex.match("1\nb%")
		XCTAssertEqual(matches, [
			RegexMatch(match: "1", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "b", range: 2..<3, groups: [], groupRanges: []),
			RegexMatch(match: "%", range: 3..<4, groups: [], groupRanges: []),
		])
	}
	
	func testAllCharacters() {
		let regex = try! Regex("[^]")
		let matches = regex.match("a\n1")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "\n", range: 1..<2, groups: [], groupRanges: []),
			RegexMatch(match: "1", range: 2..<3, groups: [], groupRanges: []),
		])
	}
	
	func testWordCharacters() {
		let regex = try! Regex("\\w")
		let matches = regex.match("0-_a")
		XCTAssertEqual(matches, [
			RegexMatch(match: "0", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "_", range: 2..<3, groups: [], groupRanges: []),
			RegexMatch(match: "a", range: 3..<4, groups: [], groupRanges: []),
		])
	}
	
	func testNonWordCharacters() {
		let regex = try! Regex("\\W")
		let matches = regex.match("1-_")
		XCTAssertEqual(matches, [
			RegexMatch(match: "-", range: 1..<2, groups: [], groupRanges: []),
		])
	}
	
	func testDigits() {
		let regex = try! Regex("\\d")
		let matches = regex.match("a12")
		XCTAssertEqual(matches, [
			RegexMatch(match: "1", range: 1..<2, groups: [], groupRanges: []),
			RegexMatch(match: "2", range: 2..<3, groups: [], groupRanges: []),
		])
	}
	
	func testNotDigits() {
		let regex = try! Regex("\\D")
		let matches = regex.match("a12")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testWhitespace() {
		let regex = try! Regex("\\s")
		let matches = regex.match("a 1")
		XCTAssertEqual(matches, [
			RegexMatch(match: " ", range: 1..<2, groups: [], groupRanges: []),
		])
	}
	
	func testNotWhitespace() {
		let regex = try! Regex("\\S")
		let matches = regex.match("a 1")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "1", range: 2..<3, groups: [], groupRanges: []),
		])
	}
	
	func testSet() {
		let regex = try! Regex("[ABC]")
		let matches = regex.match("AaD")
		XCTAssertEqual(matches, [
			RegexMatch(match: "A", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testNotSet() {
		let regex = try! Regex("[^ABC]")
		let matches = regex.match("aA")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testSetRange() {
		let regex = try! Regex("[A-Z]")
		let matches = regex.match("Hj")
		XCTAssertEqual(matches, [
			RegexMatch(match: "H", range: 0..<01, groups: [], groupRanges: []),
		])
	}
	
	func testBeginningOfString() {
		let regex = try! Regex("^a")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testEndOfString() {
		let regex = try! Regex("a$")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 1..<2, groups: [], groupRanges: []),
		])
	}
	
	func testWordBoundary() {
		let regex = try! Regex("\\ba")
		let matches = regex.match("a a")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "a", range: 2..<3, groups: [], groupRanges: []),
		])
	}
	
	func testNotWordBoundary() {
		let regex = try! Regex("\\Ba")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 1..<2, groups: [], groupRanges: []),
		])
	}
	
	func testOctalEscape() {
		let regex = try! Regex("\\251")
		let matches = regex.match("©")
		XCTAssertEqual(matches, [
			RegexMatch(match: "©", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testOctalEscapeTooLarge() {
		let regex = try! Regex("\\378")
		let matches = regex.match("\u{1F}8")
		XCTAssertEqual(matches, [
			RegexMatch(match: "\u{1F}8", range: 0..<2, groups: [], groupRanges: []),
		])
	}
	
	func testInvalidOctEscape() {
		let regex = try! Regex("\\555")
		let matches = regex.match("\u{2D}5")
		XCTAssertEqual(matches, [
			RegexMatch(match: "\u{2D}5", range: 0..<2, groups: [], groupRanges: []),
		])
	}
	
	func testHexEscape() {
		let regex = try! Regex("\\xA9")
		let matches = regex.match("©")
		XCTAssertEqual(matches, [
			RegexMatch(match: "©", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testHexEscapeTooSmall() {
		let regex = try! Regex("\\xAp")
		let matches = regex.match("xAp")
		XCTAssertEqual(matches, [
			RegexMatch(match: "xAp", range: 0..<3, groups: [], groupRanges: []),
		])
	}
	
	func testUnicodeEscape() {
		let regex = try! Regex("\\u00A9")
		let matches = regex.match("©")
		XCTAssertEqual(matches, [
			RegexMatch(match: "©", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testUnicodeEscapeTooSmall() {
		let regex = try! Regex("\\u00 ")
		let matches = regex.match("u00 ")
		XCTAssertEqual(matches, [
			RegexMatch(match: "u00 ", range: 0..<4, groups: [], groupRanges: []),
		])
	}
	
	func testControlEscape() {
		let regex = try! Regex("\\cI")
		let matches = regex.match("\t")
		XCTAssertEqual(matches, [
			RegexMatch(match: "\t", range: 0..<1, groups: [], groupRanges: []),
		])
	}
	
	func testControlEscapeTooSmall() {
		let regex = try! Regex("\\c,")
		let matches = regex.match("c,")
		XCTAssertEqual(matches, [
			RegexMatch(match: "c,", range: 0..<2, groups: [], groupRanges: []),
		])
	}
	
	func testEscapeCharactersInSets() {
		let regex = try! Regex("[\\100\\xA9\\u00C7\\cI]")
		let matches = regex.match("©Ç")
		XCTAssertEqual(matches, [
			RegexMatch(match: "©", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "Ç", range: 1..<2, groups: [], groupRanges: []),
		])
	}
	
	func testUnprintableEscapeCharacters() {
		let regex = try! Regex("\\t\\n\\v\\f\\r\\0\r\n")
		let matches = regex.match("\t\n\u{000B}\u{000C}\r\0\r\n")
		XCTAssertEqual(matches, [
			RegexMatch(match: "\t\n\u{0B}\u{0C}\r\0\r\n", range: 0..<7, groups: [], groupRanges: []),
		])
	}
	
	func testEscapeSpecialCharacters() {
		let regex = try! Regex("\\.\\\\\\+\\*\\?\\^\\$\\[\\]\\{\\}\\(\\)\\|\\/")
		let matches = regex.match(".\\+*?^$[]{}()|/")
		XCTAssertEqual(matches, [
			RegexMatch(match: ".\\+*?^$[]{}()|/", range: 0..<15, groups: [], groupRanges: []),
		])
	}
	
	func testCaptureGroup() {
		let regex = try! Regex("(ABC)")
		let matches = regex.match("ABC")
		XCTAssertEqual(matches, [
			RegexMatch(match: "ABC", range: 0..<3, groups: ["ABC"], groupRanges: [0..<3]),
		])
	}
	
//	func testBackReference() {
//		let regex = try! Regex("(A|B)\\1")
//		let matches = regex.match("AA AB BB")
//		XCTAssertEqual(matches, [
//			RegexMatch(match: "AA", range: 0..<2, groups: ["A"], groupRanges: [0..<1]),
//			RegexMatch(match: "BB", range: 6..<8, groups: ["B"], groupRanges: [6..<7]),
//		])
//	}
	
//	func testNonCaptureGroup() {
//		let regex = try! Regex("(?:ABC)")
//		let matches = regex.match("")
//		XCTAssertEqual(matches, [
//		])
//		XCTFail("Unimplemented")
//	}
	
//	func testLookAhead() {
//		let regex = try! Regex("(?=ABC)")
//		let matches = regex.match("")
//		XCTAssertEqual(matches, [
//		])
//		XCTFail("Unimplemented")
//	}
	
//	func testNegativeLookAhead() {
//		let regex = try! Regex("(?!ABC)")
//		let matches = regex.match("")
//		XCTAssertEqual(matches, [
//		])
//		XCTFail("Unimplemented")
//	}
	
//	func testLookBehind() {
//		let regex = try! Regex("(?<=ABC)")
//		let matches = regex.match("")
//		XCTAssertEqual(matches, [
//		])
//		XCTFail("Unimplemented")
//	}
	
//	func testNegativeLookbehind() {
//		let regex = try! Regex("(?<!ABC)")
//		let matches = regex.match("")
//		XCTAssertEqual(matches, [
//		])
//		XCTFail("Unimplemented")
//	}
	
	func testOptional() {
		let regex = try! Regex("a?")
		let matches = regex.match("a")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 1..<1, groups: [], groupRanges: []),
		])
	}
	
	func testOneOrMore() {
		let regex = try! Regex("a+")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aa", range: 0..<2, groups: [], groupRanges: []),
		])
	}
	
	func testZeroOrMore() {
		let regex = try! Regex("a*")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aa", range: 0..<2, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 2..<2, groups: [], groupRanges: []),
		])
	}
	
	func testAmount() {
		let regex = try! Regex("a{4}")
		let matches = regex.match("baaaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aaaa", range: 1..<5, groups: [], groupRanges: []),
		])
	}
	
	func testAmountOrLess() {
		let regex = try! Regex("a{,4}")
		let matches = regex.match("baaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "", range: 0..<0, groups: [], groupRanges: []),
			RegexMatch(match: "aaa", range: 1..<4, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 4..<4, groups: [], groupRanges: []),
		])
	}
	
	func testAmountOrMore() {
		let regex = try! Regex("a{4,}")
		let matches = regex.match("aaaaaaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aaaaaaa", range: 0..<7, groups: [], groupRanges: []),
		])
	}
	
	func testAmountRange() {
		let regex = try! Regex("a{4,10}")
		let matches = regex.match("aaaaaaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aaaaaaa", range: 0..<7, groups: [], groupRanges: []),
		])
	}
	
	func testLazyOptional() {
		let regex = try! Regex("a??")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "", range: 0..<0, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 1..<1, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 2..<2, groups: [], groupRanges: []),
		])
	}
	
	func testLazyOneOrMore() {
		let regex = try! Regex("a+?")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "a", range: 0..<1, groups: [], groupRanges: []),
			RegexMatch(match: "a", range: 1..<2, groups: [], groupRanges: []),
		])
	}
	
	func testLazyZeroOrMore() {
		let regex = try! Regex("a*?")
		let matches = regex.match("aa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "", range: 0..<0, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 1..<1, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 2..<2, groups: [], groupRanges: []),
		])
	}
	
	func testLazyAmount() {
		let regex = try! Regex("a{5}?")
		let matches = regex.match("aaaaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aaaaa", range: 0..<5, groups: [], groupRanges: []),
		])
	}
	
	func testLazyAmountOrLess() {
		let regex = try! Regex("a{,5}?")
		let matches = regex.match("aaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "", range: 0..<0, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 1..<1, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 2..<2, groups: [], groupRanges: []),
			RegexMatch(match: "", range: 3..<3, groups: [], groupRanges: []),
		])
	}
	
	func testLazyAmountOrMore() {
		let regex = try! Regex("a{5,}?")
		let matches = regex.match("aaaaaaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aaaaa", range: 0..<5, groups: [], groupRanges: []),
		])
	}
	
	func testLazyAmountRange() {
		let regex = try! Regex("a{5,12}?")
		let matches = regex.match("aaaaaaaaaa")
		XCTAssertEqual(matches, [
			RegexMatch(match: "aaaaa", range: 0..<5, groups: [], groupRanges: []),
			RegexMatch(match: "aaaaa", range: 5..<10, groups: [], groupRanges: []),
		])
	}
	
	func testAlternation() {
		let regex = try! Regex("ab|12")
		let matches = regex.match("ab12")
		XCTAssertEqual(matches, [
			RegexMatch(match: "ab", range: 0..<2, groups: [], groupRanges: []),
			RegexMatch(match: "12", range: 2..<4, groups: [], groupRanges: []),
		])
	}
	
	func testiFlag() {
		let regex = try! Regex("/aB[cD\\W]/i")
		let matches = regex.match("abcd")
		XCTAssertEqual(matches, [
			RegexMatch(match: "abc", range: 0..<3, groups: [], groupRanges: []),
		])
	}
	
	func testgFlag() {
		let regex = try! Regex("/abc/g")
		let matches = regex.match("abc abc")
		XCTAssertEqual(matches, [
			RegexMatch(match: "abc", range: 0..<3, groups: [], groupRanges: []),
			RegexMatch(match: "abc", range: 4..<7, groups: [], groupRanges: []),
		])
	}
	
	func testmFlag() {
		let regex = try! Regex("/^abc/m")
		let matches = regex.match("a\nabc")
		XCTAssertEqual(matches, [
			RegexMatch(match: "abc", range: 2..<5, groups: [], groupRanges: []),
		])
	}
	
	func testMultipleFlags() {
		let regex = try! Regex("/^abc/igm")
		let matches = regex.match("ABC\naBc")
		XCTAssertEqual(matches, [
			RegexMatch(match: "ABC", range: 0..<3, groups: [], groupRanges: []),
			RegexMatch(match: "aBc", range: 4..<7, groups: [], groupRanges: []),
		])
	}
	
	func testMultiCharacter() {
		let regex = try! Regex("ab12")
		let matches = regex.match("ab12")
		XCTAssertEqual(matches, [
			RegexMatch(match: "ab12", range: 0..<4, groups: [], groupRanges: []),
		])
	}
	
	func testNestedGroups() {
		let regex = try! Regex("(a(b(c)))")
		let matches = regex.match("abc")
		XCTAssertEqual(matches, [
			RegexMatch(match: "abc", range: 0..<3, groups: ["abc", "bc", "c"], groupRanges: [0..<3, 1..<3, 2..<3]),
		])
	}
	
	func testIntegerAndDecimalNumbers() {
		let regex = try! Regex("(?:\\d*\\.)?\\d+")
		let matches = regex.match("10rats + .36geese = 3.14cows")
		XCTAssertEqual(matches, [
			RegexMatch(match: "10", range: 0..<2, groups: [], groupRanges: []),
			RegexMatch(match: ".36", range: 9..<12, groups: [], groupRanges: []),
			RegexMatch(match: "3.14", range: 20..<24, groups: [], groupRanges: []),
		])
	}
	
	
	func testTest() {
		let regex = try! Regex("\\btest(er|ing|ed|s)?\\b")
		let matches = regex.match("that tested test is testing the tester's tests")
		XCTAssertEqual(matches, [
			RegexMatch(match: "tested", range: 5..<11, groups: ["ed"], groupRanges: [9..<11]),
			RegexMatch(match: "test", range: 12..<16, groups: [""], groupRanges: [0..<0]),
			RegexMatch(match: "testing", range: 20..<27, groups: ["ing"], groupRanges: [24..<27]),
			RegexMatch(match: "tester", range: 32..<38, groups: ["er"], groupRanges: [36..<38]),
			RegexMatch(match: "tests", range: 41..<46, groups: ["s"], groupRanges: [45..<46]),
		])
	}
	
	func testPhoneNumber() {
		let regex = try! Regex("\\b\\d{3}[-.]?\\d{3}[-.]?\\d{4}\\b")
		let matches = regex.match("p:444-555-1234 f:246.555.8888 m:1235554567")
		XCTAssertEqual(matches, [
			RegexMatch(match: "444-555-1234", range: 2..<14, groups: [], groupRanges: []),
			RegexMatch(match: "246.555.8888", range: 17..<29, groups: [], groupRanges: []),
			RegexMatch(match: "1235554567", range: 32..<42, groups: [], groupRanges: []),
		])
	}
	
	func testWord() {
		let regex = try! Regex("[a-zA-Z]+")
		let matches = regex.match("RegEx is tough, but useful.")
		XCTAssertEqual(matches, [
			RegexMatch(match: "RegEx", range: 0..<5, groups: [], groupRanges: []),
			RegexMatch(match: "is", range: 6..<8, groups: [], groupRanges: []),
			RegexMatch(match: "tough", range: 9..<14, groups: [], groupRanges: []),
			RegexMatch(match: "but", range: 16..<19, groups: [], groupRanges: []),
			RegexMatch(match: "useful", range: 20..<26, groups: [], groupRanges: []),
		])
	}
	
	func test24_32BitColors() {
		let regex = try! Regex("(?:#|0x)?(?:[0-9A-F]{2}){3,4}")
		let matches = regex.match("#FF006C 99AAB7FF 0xF0F73611")
		XCTAssertEqual(matches, [
			RegexMatch(match: "#FF006C", range: 0..<7, groups: [], groupRanges: []),
			RegexMatch(match: "99AAB7FF", range: 8..<16, groups: [], groupRanges: []),
			RegexMatch(match: "0xF0F73611", range: 17..<27, groups: [], groupRanges: []),
		])
	}
	
	func test4LetterWord() {
		let regex = try! Regex("\\b\\w{4}\\b")
		let matches = regex.match("drink beer, it's very nice!")
		XCTAssertEqual(matches, [
			RegexMatch(match: "beer", range: 6..<10, groups: [], groupRanges: []),
			RegexMatch(match: "very", range: 17..<21, groups: [], groupRanges: []),
			RegexMatch(match: "nice", range: 22..<26, groups: [], groupRanges: []),
		])
	}
	
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
//		("testBackReference", testBackReference),
//		("testNonCaptureGroup", testNonCaptureGroup),
//		("testLookAhead", testLookAhead),
//		("testNegativeLookAhead", testNegativeLookAhead),
//		("testLookBehind", testLookBehind),
//		("testNegativeLookbehind", testNegativeLookbehind),
		
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
		
		
		("testIntegerAndDecimalNumbers", testIntegerAndDecimalNumbers),
		("testTest", testTest),
		("testPhoneNumber", testPhoneNumber),
		("testWord", testWord),
		("test24_32BitColors", test24_32BitColors),
		("test4LetterWord", test4LetterWord),
	]
}

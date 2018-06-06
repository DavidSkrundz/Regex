//
//  LinuxMain.swift
//  Regex
//

@testable import RegexTests
import XCTest

XCTMain([
	testCase(LexerTests.allTests),
	testCase(ParserTests.allTests),
	testCase(CompilerTests.allTests),
	
	testCase(RegexTests.allTests),
])

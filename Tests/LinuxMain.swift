//
//  LinuxMain.swift
//  Regex
//

@testable import RegexTests
import XCTest

XCTMain([
	testCase(LexerTests.allTests),
	
	testCase(RegexTests.allTests),
])

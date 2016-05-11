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
	testCase(VMTests.allTests),
	testCase(RegexTests.allTests),
	
	testCase(LexerRegressionTests.allTests),
	testCase(ParserRegressionTests.allTests),
	testCase(CompilerRegressionTests.allTests),
	testCase(VMRegressionTests.allTests),
	testCase(RegexRegressionTests.allTests),
])

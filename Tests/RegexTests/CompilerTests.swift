//
//  CompilerTests.swift
//  RegexTests
//

@testable import Regex
import XCTest

class CompilerTests: XCTestCase {
	func testConversion1() {
		let nfa = Automaton()
		
		let s1 = nfa.newState()
		let s2 = nfa.newState()
		let s3 = nfa.newState()
		let s4 = nfa.newState()
		
		nfa.initialStates = [s1]
		nfa.acceptingStates = [s3, s4]
		
		nfa.addTransition(from: s1, to: s2, symbol: .Character("0"))
		nfa.addTransition(from: s2, to: s2, symbol: .Character("1"))
		nfa.addTransition(from: s2, to: s4, symbol: .Character("1"))
		nfa.addTransition(from: s3, to: s4, symbol: .Character("0"))
		nfa.addTransition(from: s4, to: s3, symbol: .Character("0"))
		
		nfa.addTransition(from: s1, to: s3, symbol: .None)
		nfa.addTransition(from: s3, to: s2, symbol: .None)
		
		
		let dfa = Compiler.compile(nfa)
		
		if dfa.initialStates.isEmpty {
			XCTFail("No s_1")
			return
		}
		let s_1 = dfa.initialStates.first!
		if dfa.transitions[s_1]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_2")
			return
		}
		let s_2 = dfa.transitions[s_1]![.Character("0")]!.first!
		if dfa.transitions[s_2]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_3")
			return
		}
		let s_3 = dfa.transitions[s_2]![.Character("0")]!.first!
		if dfa.transitions[s_3]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_4")
			return
		}
		let s_4 = dfa.transitions[s_3]![.Character("0")]!.first!
		
		XCTAssertEqual(dfa.acceptingStates, [s_1, s_2, s_3, s_4])
		XCTAssertEqual(dfa.transitions, [
			s_1 : [
				.Character("0") : [s_2],
				.Character("1") : [s_2]
			],
			s_2 : [
				.Character("1") : [s_2],
				.Character("0") : [s_3]
			],
			s_3 : [
				.Character("1") : [s_2],
				.Character("0") : [s_4]
			],
			s_4 : [
				.Character("0") : [s_3]
			]
		])
	}
	
	func testConversion2() {
		let nfa = Automaton()
		
		let s1 = nfa.newState()
		let s2 = nfa.newState()
		let s3 = nfa.newState()
		let s4 = nfa.newState()
		let s5 = nfa.newState()
		
		nfa.initialStates = [s1]
		nfa.acceptingStates = [s5]
		
		nfa.addTransition(from: s1, to: s1, symbol: .Character("0"))
		nfa.addTransition(from: s1, to: s1, symbol: .Character("1"))
		nfa.addTransition(from: s1, to: s2, symbol: .Character("1"))
		nfa.addTransition(from: s2, to: s3, symbol: .Character("0"))
		nfa.addTransition(from: s2, to: s3, symbol: .Character("1"))
		nfa.addTransition(from: s3, to: s4, symbol: .Character("0"))
		nfa.addTransition(from: s3, to: s4, symbol: .Character("1"))
		nfa.addTransition(from: s4, to: s5, symbol: .Character("0"))
		nfa.addTransition(from: s4, to: s5, symbol: .Character("1"))
		
		
		let dfa = Compiler.compile(nfa)
		
		if dfa.initialStates.isEmpty {
			XCTFail("No s_5")
			return
		}
		let s_5 = dfa.initialStates.first!
		if dfa.transitions[s_5]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_4")
			return
		}
		let s_4 = dfa.transitions[s_5]![.Character("1")]!.first!
		if dfa.transitions[s_4]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_1")
			return
		}
		let s_1 = dfa.transitions[s_4]![.Character("0")]!.first!
		if dfa.transitions[s_1]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_2")
			return
		}
		let s_2 = dfa.transitions[s_1]![.Character("0")]!.first!
		if dfa.transitions[s_2]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_3")
			return
		}
		let s_3 = dfa.transitions[s_2]![.Character("1")]!.first!
		if dfa.transitions[s_2]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_6")
			return
		}
		let s_6 = dfa.transitions[s_2]![.Character("0")]!.first!
		if dfa.transitions[s_4]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_10")
			return
		}
		let s_10 = dfa.transitions[s_4]![.Character("1")]!.first!
		if dfa.transitions[s_10]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_16")
			return
		}
		let s_16 = dfa.transitions[s_10]![.Character("1")]!.first!
		if dfa.transitions[s_16]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_15")
			return
		}
		let s_15 = dfa.transitions[s_16]![.Character("1")]!.first!
		if dfa.transitions[s_15]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_14")
			return
		}
		let s_14 = dfa.transitions[s_15]![.Character("0")]!.first!
		if dfa.transitions[s_14]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_13")
			return
		}
		let s_13 = dfa.transitions[s_14]![.Character("1")]!.first!
		if dfa.transitions[s_13]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_12")
			return
		}
		let s_12 = dfa.transitions[s_13]![.Character("1")]!.first!
		if dfa.transitions[s_12]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_11")
			return
		}
		let s_11 = dfa.transitions[s_12]![.Character("0")]!.first!
		if dfa.transitions[s_11]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_9")
			return
		}
		let s_9 = dfa.transitions[s_11]![.Character("0")]!.first!
		if dfa.transitions[s_1]?[.Character("1")]?.isEmpty ?? true {
			XCTFail("No s_8")
			return
		}
		let s_8 = dfa.transitions[s_1]![.Character("1")]!.first!
		if dfa.transitions[s_8]?[.Character("0")]?.isEmpty ?? true {
			XCTFail("No s_7")
			return
		}
		let s_7 = dfa.transitions[s_8]![.Character("0")]!.first!
		
		XCTAssertEqual(dfa.acceptingStates, [s_3, s_6, s_7, s_9, s_12, s_13, s_14, s_15])
		XCTAssertEqual(dfa.transitions, [
			s_1 : [
				.Character("0") : [s_2],
				.Character("1") : [s_8]
			],
			s_2 : [
				.Character("0") : [s_6],
				.Character("1") : [s_3]
			],
			s_3 : [
				.Character("0") : [s_1],
				.Character("1") : [s_10]
			],
			s_4 : [
				.Character("0") : [s_1],
				.Character("1") : [s_10]
			],
			s_5 : [
				.Character("0") : [s_5],
				.Character("1") : [s_4]
			],
			s_6 : [
				.Character("0") : [s_5],
				.Character("1") : [s_4]
			],
			s_7 : [
				.Character("0") : [s_2],
				.Character("1") : [s_8]
			],
			s_8 : [
				.Character("0") : [s_7],
				.Character("1") : [s_12]
			],
			s_9 : [
				.Character("0") : [s_6],
				.Character("1") : [s_3]
			],
			s_10 : [
				.Character("0") : [s_11],
				.Character("1") : [s_16]
			],
			s_11 : [
				.Character("0") : [s_9],
				.Character("1") : [s_13]
			],
			s_12 : [
				.Character("0") : [s_11],
				.Character("1") : [s_16]
			],
			s_13 : [
				.Character("0") : [s_7],
				.Character("1") : [s_12]
			],
			s_14 : [
				.Character("0") : [s_9],
				.Character("1") : [s_13]
			],
			s_15 : [
				.Character("0") : [s_14],
				.Character("1") : [s_15]
			],
			s_16 : [
				.Character("0") : [s_14],
				.Character("1") : [s_15]
			]
		] as [State : [Symbol : Set<State>]])
	}
	
	static var allTests = [
		("testConversion1", testConversion1),
		("testConversion2", testConversion2),
	]
}

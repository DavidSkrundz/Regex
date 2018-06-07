//
//  Compiler.swift
//  Regex
//

internal struct Compiler {
	private var dfa = Automaton()
	
	private init() {}
	
	internal static func compile(_ nfa: Automaton) -> Automaton {
		var compiler = Compiler()
		compiler.compile(nfa)
		return compiler.dfa
	}
	
	private mutating func compile(_ nfa: Automaton) {
		// TODO:
	}
}

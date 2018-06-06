//
//  Compiler.swift
//  Regex
//

internal struct Compiler {
	private var automaton = Automaton()
	
	private init() {}
	
	internal static func compile(_ automaton: Automaton) -> Automaton {
		var compiler = Compiler()
		compiler.compile(automaton)
		return compiler.automaton
	}
	
	private mutating func compile(_ automaton: Automaton) {
		// TODO:
	}
}

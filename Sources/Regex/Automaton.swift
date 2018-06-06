//
//  Automaton.swift
//  Regex
//

/// Meant to be used as an opaque type
internal typealias State = Int

internal class Automaton {
	internal var initialStates = Set<State>()
	internal var acceptingStates = Set<State>()
	
	private(set) internal var transitions = [State : [Symbol : Set<State>]]()
	
	internal init() {}
	
	private var stateCount = 0;
	internal func newState() -> State {
		self.stateCount += 1
		return stateCount
	}
	
	internal func addTransition(from: State, to: State, symbol: Symbol) {
		var stateDict = self.transitions[from] ?? [:]
		var set = stateDict[symbol] ?? []
		set.insert(to)
		stateDict[symbol] = set
		self.transitions[from] = stateDict
	}
}

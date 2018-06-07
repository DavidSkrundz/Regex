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
		self.transitions[from, default: [:]][symbol, default: []].insert(to)
	}
	
	internal func ε_closure(of state: State) -> Set<State> {
		var stack = [state]
		var closure = Set<State>()
		while !stack.isEmpty {
			let s = stack.removeFirst()
			closure.insert(s)
			if let newStates = self.transitions[s]?[.None] {
				stack.append(contentsOf: newStates)
			}
		}
		return closure
	}
	
	internal func ε_closure(of states: Set<State>) -> Set<State> {
		return states
			.map { self.ε_closure(of: $0) }
			.reduce(Set<State>()) { $0.union($1) }
	}
}

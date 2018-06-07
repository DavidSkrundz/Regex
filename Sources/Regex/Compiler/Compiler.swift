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
		/// `NewState -> [OldState]`
		var newStateMap = [State : Set<State>]()
		/// `[OldState] -> NewState`
		var oldStateMap = [Set<State> : State]()
		/// Register the equivent states in the state maps
		func register(_ newState: State, _ oldState: Set<State>) {
			newStateMap[newState] = oldState
			oldStateMap[oldState] = newState
		}
		
		let initialState = self.dfa.newState()
		self.dfa.initialStates = [initialState]
		let oldInitialState = nfa.ε_closure(of: nfa.initialStates)
		register(initialState, oldInitialState)
		if !oldInitialState.intersection(nfa.acceptingStates).isEmpty {
			dfa.acceptingStates.insert(initialState)
		}
		
		var stateQueue = [initialState]
		while !stateQueue.isEmpty {
			let state = stateQueue.removeFirst()
			let oldStates = newStateMap[state]!
			
			let transitionList = oldStates
				.compactMap { nfa.transitions[$0] }
				.flatMap { $0.map { $0 } }
				.filter { $0.key != .None }
			let transitions = transitionList
				.reduce(into: [Symbol : Set<State>]()) { dict, pair in
					dict[pair.key, default: []]
						.formUnion(nfa.ε_closure(of: pair.value))
			}
			for transition in transitions {
				let newState = oldStateMap[transition.value] ?? self.dfa.newState()
				if oldStateMap[transition.value] == nil {
					stateQueue.append(newState)
					register(newState, transition.value)
					if !newStateMap[newState]!.intersection(nfa.acceptingStates).isEmpty {
						dfa.acceptingStates.insert(newState)
					}
				}
				self.dfa.addTransition(from: state, to: newState,
				                       symbol: transition.key)
			}
		}
	}
}

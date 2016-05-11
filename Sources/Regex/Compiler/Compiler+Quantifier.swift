//
//  Compiler+Quantifier.swift
//  Regex
//

extension Compiler {
	/// Delegates the compilation of quantifier `Symbols` into their `Instruction`s
	internal static func compileQuantifier(_ symbol: Symbol, captureGroupCount: inout Int, _ instructionIndex: Int) -> [Instruction] {
		switch symbol {
			case .Optional(_),
			     .OneOrMore(_),
			     .ZeroOrMore(_),
			     .LazyOptional(_),
			     .LazyOneOrMore(_),
			     .LazyZeroOrMore(_):
				return compileBasicQuantifier(symbol, captureGroupCount: &captureGroupCount, instructionIndex)
			case .Amount(_, _),
			     .AmountOrLess(_, _),
			     .AmountOrMore(_, _),
			     .AmountRange(_, _, _),
			     .LazyAmount(_, _),
			     .LazyAmountOrLess(_, _),
			     .LazyAmountOrMore(_, _),
			     .LazyAmountRange(_, _, _):
				return compileAdvancedQuantifier(symbol, captureGroupCount: &captureGroupCount, instructionIndex)
			default: return []
		}
	}
	
	/// Compiles basic quantifier `Instruction`s
	private static func compileBasicQuantifier(_ symbol: Symbol, captureGroupCount: inout Int, _ instructionIndex: Int) -> [Instruction] {
		var startIndex = instructionIndex
		var endIndex = startIndex
		
		switch symbol {
			case let .Optional(quantifiedSymbol):
				startIndex += 1
				let instructions = compileSymbols([quantifiedSymbol], captureGroupCount: &captureGroupCount).offset(startIndex)
				endIndex += instructions.count + 1
				return [.Split(startIndex, endIndex)] + instructions
			
			case let .OneOrMore(quantifiedSymbol):
				let instructions = compileSymbols([quantifiedSymbol], captureGroupCount: &captureGroupCount).offset(instructionIndex)
				endIndex += instructions.count + 1
				return instructions + [.Split(startIndex, endIndex)]
			
			case let .ZeroOrMore(quantifiedSymbol):
				startIndex += 1
				let instructions = compileSymbols([quantifiedSymbol], captureGroupCount: &captureGroupCount).offset(instructionIndex)
				let splitIndex = instructionIndex
				endIndex += instructions.count + 2
				return [.Split(startIndex, endIndex)] + instructions + [.Jump(splitIndex)]
			
			case let .LazyOptional(quantifiedSymbol):
				startIndex += 1
				let instructions = compileSymbols([quantifiedSymbol], captureGroupCount: &captureGroupCount).offset(instructionIndex)
				endIndex += instructions.count + 1
				return [.Split(endIndex, startIndex)] + instructions
			
			case let .LazyOneOrMore(quantifiedSymbol):
				let instructions = compileSymbols([quantifiedSymbol], captureGroupCount: &captureGroupCount).offset(instructionIndex)
				endIndex += instructions.count + 1
				return instructions + [.Split(endIndex, startIndex)]
			
			case let .LazyZeroOrMore(quantifiedSymbol):
				startIndex += 1
				let instructions = compileSymbols([quantifiedSymbol], captureGroupCount: &captureGroupCount).offset(instructionIndex)
				let splitIndex = instructionIndex
				endIndex += instructions.count + 2
				return [.Split(endIndex, startIndex)] + instructions + [.Jump(splitIndex)]
				
			default: fatalError("\(symbol) should not have been here")
		}
	}
	
	/// Compiles advance quantifier `Instruction`s
	private static func compileAdvancedQuantifier(_ symbol: Symbol, captureGroupCount: inout Int, _ instructionIndex: Int) -> [Instruction] {
		let symbols: [Symbol]
		
		switch symbol {
			case let .Amount(amount, repeatedSymbol):
				symbols = [Symbol](repeating: repeatedSymbol, count: amount)
			case let .AmountOrMore(amount, repeatedSymbol):
				symbols = [Symbol](repeating: repeatedSymbol, count: amount - 1) + [.OneOrMore(repeatedSymbol)]
			case let .AmountOrLess(amount, repeatedSymbol):
				symbols = [Symbol](repeating: .Optional(repeatedSymbol), count: amount)
			case let .AmountRange(min, max, repeatedSymbol):
				symbols = [Symbol](repeating: repeatedSymbol, count: min) + [Symbol](repeating: .Optional(repeatedSymbol), count: max - min)
			
			case let .LazyAmount(amount, repeatedSymbol):
				symbols = [Symbol](repeating: repeatedSymbol, count: amount)
			case let .LazyAmountOrMore(amount, repeatedSymbol):
				symbols = [Symbol](repeating: repeatedSymbol, count: amount - 1) + [.LazyOneOrMore(repeatedSymbol)]
			case let .LazyAmountOrLess(amount, repeatedSymbol):
				symbols = [Symbol](repeating: .LazyOptional(repeatedSymbol), count: amount)
			case let .LazyAmountRange(lowAmount, highAmount, repeatedSymbol):
				symbols = [Symbol](repeating: repeatedSymbol, count: lowAmount) + [Symbol](repeating: .LazyOptional(repeatedSymbol), count: highAmount - lowAmount)
			
			default: fatalError("\(symbol) should not get here")
		}
		
		let instructions = compileSymbols(symbols, captureGroupCount: &captureGroupCount).offset(instructionIndex)
		return instructions
	}
}
